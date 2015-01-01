# Load .env environment variables.
if File.exist?('.env')
  File.read('.env').lines.each do |line|
    next if line =~ /^\s*\#/
    key, val = line.strip.split('=')
    if key
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
