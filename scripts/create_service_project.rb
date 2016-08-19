# encoding: utf-8

require 'gooddata'

require_relative '../config'

GoodData.with_connection($CONFIG[:username], $CONFIG[:password], :server => $CONFIG[:server], :verify_ssl => false) do |client|
  timestamp = DateTime.now.strftime('%Y%m%d%H%M%S')

  project = client.create_project(title: "LCM Service project - #{timestamp}", auth_token: $CONFIG[:token])

  puts JSON.pretty_generate(project.json)
end
