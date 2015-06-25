#!/usr/bin/env ruby
#
require 'hipchat'
require 'json'
require 'pony'


if $ARGV[0]  =~/help/ or $ARGV[0] == '-h'
  puts "#{$0} is a hipchat room scraper to spit out standup statuses."
  puts "Possible configurations are: "
  puts "  HIPCHAT_ROOM  -- self explanatory"
  puts "  HIPCHAT_API_TOKEN  -- your api key for hipchat (v1 api)"
  puts "  ENABLE_EMAIL -- by default no email is sent, just stdout."
  puts "  EMAIL_TARGET -- who you send the email to"
  puts "  EMAIL_FROM -- who sends the standup email?"
  exit 1
end

hipchat_room = ENV['HIPCHAT_ROOM'] || 'release-new'
api_token    = ENV['HIPCHAT_API_TOKEN']
enable_email = ENV['ENABLE_EMAIL'] ||  'false'
email_target = ENV['EMAIL_TARGET'] || 'release-team@puppetlabs.com'
email_from   = ENV['EMAIL_FROM'] || 'standup-bot@puppetlabs.com'

if api_token.nil?
  puts "You must set HIPCHAT_API_TOKEN"
  exit 2
end

date = Time.now.strftime('%Y-%m-%d')
client = HipChat::Client.new(api_token, :api_version => 'v1')
standups=""
subject = "#{date} standup summary for #{hipchat_room}"

blob =  client[hipchat_room].history(:date => date , :timezone => 'PST')
blob.each_line do | messages |
  JSON.parse(messages).each do |m|
    m[1].each do |mess|
      next unless (mess['message'] =~ /#standup/i || mess['message'] =~ /(standup)/i)
      standups <<  mess['from']['name'] + ": " + mess['message'] + "\n\n"
    end
  end
end

puts standups
if enable_email
  puts "Sending mail to #{email_target}"
  Pony.mail(:to => email_target, :from => email_from, :subject => subject,
            :body => standups )
end
