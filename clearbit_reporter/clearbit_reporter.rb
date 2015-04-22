require 'net/http'

apikey = params["apikey"]
email = params["email"]
id = params["webhook_id"]
uri = URI("https://person.clearbit.com/v1/people/email/#{email}?webhook_id=#{id}")


Net::HTTP.start(uri.host, uri.port,
  :use_ssl => uri.scheme == 'https') do |http|
  request = Net::HTTP::Get.new uri
  request['Authorization'] = "Bearer #{apikey}"

  response = http.request request

  puts response.body if response.is_a?(Net::HTTPSuccess)
end
