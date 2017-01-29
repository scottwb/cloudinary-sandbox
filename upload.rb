#!/usr/bin/env ruby

require 'json'
require 'shellwords'

# Load .env environment variables.
if File.exist?('.env')
  File.read('.env').lines.each do |line|
    next if line =~ /^\s*\#/
    key, val = line.strip.split('=')
    if key && val
      key.strip!
      val.strip!
      if val =~ /\$(.+)/
        val = ENV[$1]
      end
      ENV[key]=val
    end
  end
end
require 'cloudinary'
require 'securerandom'

def random_name
  [
    "jgroh9",
    "scottwb",
    "leif.jensen",
    "labradley",
    "bjensen",
    "mylagroh"
  ].shuffle.first
end

def image_dimensions(f)
  w,h = `identify #{Shellwords.escape(f)} | egrep -o \\\\s\\\\d+x\\\\d+\\\\s`.strip.split('x')
  [w.to_i,h.to_i]
end

@random_time = Time.now.utc - (60*60*24*5)
def random_time
  @random_time += rand(600)
  @random_time.strftime("%Y-%m-%dT%H:%M:%SZ")
end

def upload_file(image_file)
  public_id = SecureRandom.hex(8)
  w,h = image_dimensions(image_file)
  img = {
    "image_id"  => public_id,
    "author"    => random_name,
    "width"     => w,
    "height"    => h,
    "timestamp" => random_time
  }
  puts img.inspect + ","


  #public_id  = File.basename(image_file).split('.').first
  #puts "Uploading #{image_file} as #{public_id}"
  Cloudinary::Uploader.upload(
    image_file,
    :public_id => public_id,
  )

  #url = Cloudinary::Utils.cloudinary_url("#{public_id}.png")
  #puts "  #{url}"
end

dir = ARGV[0]
if dir.nil?
  raise "No directory provided on command line"
end

Dir.chdir(dir) do
  Dir.glob("*.{jpg,JPG,jpeg,JPEG,png,PNG,gif,GIF}").each { |e| upload_file(e) }
end
