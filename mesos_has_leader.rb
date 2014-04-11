#!/usr/bin/env ruby

require 'net/http'
require 'json'

begin
  uri      = URI('http://localhost:5050/master/state.json')
  http     = Net::HTTP.new(uri.host, uri.port)
  request  = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(request)
  state    = JSON.parse(response.body) # => String
rescue
  puts "CRITICAL - error occured getting mesos-master state"
  exit 2 
end 

#puts JSON.pretty_generate(state)
no_leader = state["leader"].nil? || state["leader"].empty?

#puts response.code

case response.code
when "200"
  if no_leader
    puts "CRITICAL - no leader"
    exit 3
  else
    puts "OK - leader #{state["leader"]}"
    exit 0
  end
#when "X"
#  puts "WARNING"
#  exit 1
#when "Y"
#  puts "CRITICAL"
#  exit 2
else
  puts "UNKNOWN"
  exit 3
end

