#!/usr/bin/env ruby

# Load .env environment variables.
if File.exist?('.env')
  File.read('.env').lines.each do |line|
    next if line =~ /^\s*\#/
    key, val = line.strip.split('=')
    key.strip!
    val.strip!
    if val =~ /\$(.+)/
      val = ENV[$1]
    end
    ENV[key]=val
  end
end
require 'cloudinary'
require 'securerandom'

image_file = ARGV[0]
public_id  = SecureRandom.hex

if image_file.nil?
  raise "No image file provided on command line"
end

puts "Uploading #{image_file} as #{public_id}"
Cloudinary::Uploader.upload(
  image_file,
  :public_id => public_id,
  :type => :private
)

