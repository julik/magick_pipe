require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "MagickPipe" do
  after :each do
    File.unlink('out.png') if File.exist?('out.png')
  end
  
  it "responds to Magick::Image methods" do
    subject = MagickPipe.new("/foo.tif")
    expect(subject).to respond_to(:resize)
    expect(subject).to respond_to(:sharpen)
  end
  
  it 'resizes and sharpens the PSD file using change_geometry and a block' do
    path = File.dirname(__FILE__) + '/IMG_3241.psd'
    
    subject = MagickPipe.new(path)
    subject.change_geometry('64x64') do |r, c, img|
      img.resize(r, c)
    end
    subject.sharpen 0.0, 0.85
    subject.write('out.png')
    
    expect(File).not_to be_exist('out.png')
    subject.execute!
    expect(File).to be_exist('out.png')
    
    image = Magick::Image.read('out.png')[0]
    expect(image.rows).to be <= 64
    expect(image.columns).to be <= 64
  end
  
  it 'runs a GC after execution' do
    path = File.dirname(__FILE__) + '/IMG_3241.psd'
    
    subject = MagickPipe.new(path)
    subject.write('out.png')
    
    expect(GC).to receive(:start).once
    subject.execute!
  end
  
  it 'resizes and sharpens the PSD file using geometry!' do
    path = File.dirname(__FILE__) + '/IMG_3241.psd'
    
    subject = MagickPipe.new(path)
    subject.geometry! '64x64'
    subject.sharpen 0.0, 0.85
    subject.write('out.png')
    
    expect(File).not_to be_exist('out.png')
    subject.execute!
    expect(File).to be_exist('out.png')
    
    image = Magick::Image.read('out.png')[0]
    expect(image.rows).to be <= 64
    expect(image.columns).to be <= 64
  end
  
  it 'resizes and sharpens the PSD file using chained calls' do
    path = File.dirname(__FILE__) + '/IMG_3241.psd'
    
    subject = MagickPipe.new(path)
    subject.geometry!('64x64').sharpen(0.0, 0.85).write('out.png').execute!
    expect(File).to be_exist('out.png')
    
    image = Magick::Image.read('out.png')[0]
    expect(image.rows).to be <= 64
    expect(image.columns).to be <= 64
  end
end
