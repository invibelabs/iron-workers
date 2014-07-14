require "mandrill"

puts "Starting Mandrill Mailer"

mandrill_api_key = params["mandrill_api_key"]

from_email = params["from_email"]
from_name = params["from_name"]
subject = params["subject"]
content = params["content"]
to_email = params["to_email"]

mandrill = Mandrill::API.new mandrill_api_key

puts "Building email message"

message = {
  text: content,
  subject: subject,
  from_email: from_email,
  from_name: from_name,
  to: [{
    email: to_email
  }]
}

puts "Sending Email"

result = mandrill.messages.send(message)

puts result

puts "Email Sent"

