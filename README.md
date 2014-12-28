# magick_pipe

**WARNING: this is a proof-of-concept/experimental library. Expect things to break.**

Serialize RMagick operations into a processing pipeline that can be executed out-of-process.

To set up a processing pipe:

    script = MagickPipe.new("/Users/julik/VFX_Projectery/MattePaintings/IMG_9500.psd", frame: 0)
    script.auto_orient
    script.strip!
    script.geometry! '512x512'
    script.sharpen 0.0, 0.85
    script.write("/Users/julik/VFX_Projectery/MattePaintings/IMG_9500_tiny.png")
  
No images are allocated at this point. Only when you call

    script.execute!

will the actual reading of the image happen. All the images allocated at the various stages
of the processing will be deallocated using `Magick::Image#destroy!` at the end of the method.

## Why is this actually useful?

Well, you could do this (using [exceptional_fork](https://github.com/julik/exceptional_fork)):

    ExceptionalFork.fork_and_wait { script.execute! }
  
This will put all the image allocations _outside_ of your main Ruby process. This will ensure
that the fabulous RMagick memory leaks or bad deallocations will die together with the process
that has been spun up.

## Calling convention

Every method that is available on a `Magick::Image` object is available in the `MagickPipe`
object. Blocks will be preserved where possible. Since `change_geometry` with the default block is
used so often it is made available under 

## Future problems

The idea is to be able to actually _serialize_ the whole processing pipe so that it can be
passed via JSON or a query string.

## Contributing to image_pipeline
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2014 Julik Tarkhanov. See LICENSE.txt for
further details.

