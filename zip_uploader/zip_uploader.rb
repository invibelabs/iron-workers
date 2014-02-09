require "open-uri"
require "aws-sdk"
require "zip"

AWS.config(
  access_key_id: params['aws_access'],
  secret_access_key: params['aws_secret']
)


DownloadFiles = Struct.new(:files, :all_filenames) do
  def all
    files.each do |f|
      df = DownloadFile.new(f[:filename], f[:file_url])
      df.download_file
      all_filenames << df.filename
    end
  end
end

DownloadFile = Struct.new(:filename, :file_url) do
  def download_file
    puts "Downloading file #{filename}"
    filepath = filename
    File.open(filepath, 'wb') do |fout|
      open(file_url) do |fin|
        IO.copy_stream(fin, fout)
      end
    end
    filename
    puts "File Downloaded"
  end
end

ZipFile = Struct.new(:zip_name, :all_files) do
  def zip
    puts "Zipping file #{zip_name}"
    Zip::File.open(zip_name, Zip::File::CREATE) do |zipfile|
      all_files.each do |filename|
        zipfile.add(filename, filename)
      end
    end
    puts "File zipped"
  end
end

UploadFile = Struct.new(:bucket_name, :bucket_dir, :filename) do
  def perform
    filepath = filename
    puts "\nUploading the file to s3..."
    s3 = AWS::S3.new
    bucket = s3.buckets[bucket_name]
    object = bucket.objects[bucket_dir + '/' + filename]
    if object.write(Pathname.new(filepath), content_type: 'application/zip', acl: :public_read)
      puts "Uploading succesful."
      link = object.public_url
      puts "\nYou can view the file here on s3:", link
    else
      puts "Error placing the file in s3."
    end
    puts "-"*60
  end
end


dall = DownloadFiles.new(params[:files], [])
dall.all

zipped = ZipFile.new(params[:zip_name], dall.all_filenames)
zipped.zip

upload = UploadFile.new(params[:bucket_name], params[:bucket_dir], zipped.zip_name)
upload.perform

