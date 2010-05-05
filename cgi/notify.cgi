#!/usr/bin/env ruby

require 'cgi'
require 'rubygems'
require 'sqlite3'

cgi = CGI.new

db_filename = File.join(File.dirname(__FILE__), '..', 'db', 'notification_emails.sqlite3')

create_schema = !(File.exists? db_filename)
db = SQLite3::Database.new(db_filename)
if create_schema
  db.execute('CREATE TABLE notifications (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, created_at datetime, ip_address varchar(255), email varchar(255))')
end

# created at , IP address, email  -- email is truncated
db.execute('insert into notifications VALUES(NULL, ?, ?, ?)', Time.new, cgi.remote_addr, cgi['email'][0,255])
db.close

puts cgi.header('text/html')

# You would usually do a HTTP redirect in response to a POST.
# But we simply replace a section from index.html for the response.

index_html = IO.read(File.join(File.dirname(__FILE__), '..', 'index.html'))

p_inform = <<END_P_INFORM
<p id="inform">
  Cheers! Will keep you informed.
</p>
END_P_INFORM

puts index_html.sub(/<p id="notify".*form>/m, p_inform)
