require "twilio-ruby"

twilio_credentials = params["twilio_credentials"]
account_sid = twilio_credentials["sid"]
auth_token = twilio_credentials["token"]

to_phone_number = params["to_phone_number"]
from_twilio_number = params["from_phone_number"]
message = params["message"]


twilio_client = Twilio::REST::Client.new(account_sid, auth_token)

puts "Sending sms to #{to_phone_number} with message: #{message}"

sms = twilio_client.account.messages.create({
  to: to_phone_number,
  from: from_twilio_number,
  body: message
})

puts sms
