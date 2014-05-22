require 'google_drive'

# Params
google_user = params['google_user']
google_pass = params['google_pass']
spreadsheet_key = params['spreadsheet_key']
worksheet_title = params['worksheet_title']
row_hash = params['row_hash']

puts "\nRow Hash: #{row_hash}"

session = GoogleDrive.login(google_user, google_pass)
if worksheet_title.is_a?(String)
  worksheet = session.spreadsheet_by_key(spreadsheet_key).worksheet_by_title(worksheet_title)
else
  worksheet = session.spreadsheet_by_key(spreadsheet_key).worksheets[0]
end

puts "\nFound #{worksheet}"
puts "\nAdding row."

worksheet.list.push(row_hash)
worksheet.save

puts "\nSaved worksheet."


puts "-"*60
