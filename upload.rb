#!/usr/bin/env ruby

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

def upload_file(image_file)
  public_id  = File.basename(image_file).split('.').first

  puts "Uploading #{image_file} as #{public_id}"
  Cloudinary::Uploader.upload(
    image_file,
    :public_id => public_id,
  )

  url = Cloudinary::Utils.cloudinary_url("#{public_id}.png")
  puts "  #{url}"
end

dir = ARGV[0]
if dir.nil?
  raise "No directory provided on command line"
end

Dir.chdir(dir) do
  Dir.glob("*.png").each { |e| upload_file(e) }
end
