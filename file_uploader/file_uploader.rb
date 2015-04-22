require "open-uri"
require "aws-sdk"


AWS.config(
  access_key_id: params['aws_access'],
  secret_access_key: params['aws_secret'])

# options = { content_type: 'image/jpeg', acl: 'public_read', content_disposition: 'attachment' }
FileUpload = Struct.new(:bucket_name, :bucket_dir, :filename, :file_url, :options) do

  def upload_file
    filepath = filename
    puts "\nUploading the file to s3..."
    s3 = AWS::S3.new
    bucket = s3.buckets[bucket_name]
    object = bucket.objects[bucket_dir + '/' + filename]
    if object.write(Pathname.new(filepath), options)
      puts "Uploading succesful."
      link = object.public_url
      puts "\nYou can view the file here on s3:", link
    else
      puts "Error placing the file in s3."
    end
    puts "-"*60
  end

  def download_file
    filepath = filename
    File.open(filepath, 'wb') do |fout|
      open(file_url) do |fin|
        IO.copy_stream(fin, fout)
      end
    end
    filename
  end
end


puts "Creating file upload from params"

params['files'].each do |file_params|

  fu = FileUpload.new(
    params['aws_s3_bucket_name'],
    file_params['bucket_dir'],
    file_params['filename'],
    file_params['file_url'],
    file_params['options']
  )

  puts "Downloading file"

  fu.download_file

  fu.upload_file

end
