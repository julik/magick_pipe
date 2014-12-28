require 'RMagick'

class MagickPipe
  VERSION = '0.0.1'
  
  NOOP_PROC = Proc.new {} # To prevent allocating new Procs every time we have a method with no Proc
  
  # Initialize a processing script with a path to the source file and the frame to use.
  # To reliably "squash" Photoshop documents that have been saved with "Maximize Compatibiliy"
  # enabled, set the frame to 0 (this is also the default). This will preserve the transparency
  # throughout the whole script.
  def initialize(source_path, frame: 0)
    @source_path = source_path
    @frame = frame.to_i
    @steps = []
  end
  
  # Shorcut for change_geometry() with a block argument
  def geometry!(geometry_argument)
    change_geometry(geometry_argument) do | rows, cols, img |
      img.resize(rows, cols)
    end
  end
  
  # Perform all the recorded steps in sequence, and 
  # deallocate all of the Magick::Image objects at the end.
  def execute!
    allocated_images = []
    allocated_images << Magick::Image.read(@source_path)[0]
    @steps.each do | (method_name, tail_args, block_proc) |
      last_image = allocated_images[-1]
      
      # Apply the method to the image, and grab the return result
      result = last_image.public_send(method_name, *tail_args, &block_proc)
      
      # If that is a new image - put it on the stack
      if result.is_a?(Magick::Image) && result.object_id != last_image.object_id
        allocated_images << result
      end
    end
  ensure
    allocated_images.each {|i| i.destroy! unless i.destroyed? }
    GC.start
  end
  
  # Will tell whether a method is available on Magick::Image objects.
  def respond_to_missing?(m, *a)
    Magick::Image.public_instance_methods.include?(m)
  end
  
  # Save the method name, it's tail arguments and the optional block
  # for later execution.
  def method_missing(m, *a)
    return super unless respond_to?(m)
    proc_block = block_given? ? Proc.new : NOOP_PROC
    @steps << [m, a, proc_block]
  end
end

