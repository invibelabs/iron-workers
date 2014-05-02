require "open-uri"
require "aws-sdk"


AWS.config(
  access_key_id: params['aws_access'],
  secret_access_key: params['aws_secret'])


AudioUpload = Struct.new(:bucket_name, :bucket_dir, :filename, :audio_url) do

  def upload_file
    filepath = filename
    puts "\nUploading the file to s3..."
    s3 = AWS::S3.new
    bucket = s3.buckets[bucket_name]
    object = bucket.objects[bucket_dir + '/' + filename]
    if object.write(Pathname.new(filepath), content_type: 'audio/mpeg', acl: :public_read)
      puts "Uploading succesful."
      link = object.public_url
      puts "\nYou can view the file here on s3:", link
    else
      puts "Error placing the file in s3."
    end
    puts "-"*60
  end

  def download_audio
    filepath = filename
    File.open(filepath, 'wb') do |fout|
      open(audio_url) do |fin|
        IO.copy_stream(fin, fout)
      end
    end
    filename
  end
end

if params['upload_audio'] == true
  puts "Creating audio upload from params"

  params['audio_files'].each do |audio_params|
    au = AudioUpload.new(
      params['aws_s3_bucket_name'],
      params['bucket_dir'],
      audio_params['filename'],
      audio_params['audio_url']
    )

    puts "Downloading audio"

    au.download_audio

    au.upload_file

  end

else
  puts "Audio Uploader not configured to upload."
end
