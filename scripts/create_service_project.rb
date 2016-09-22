# encoding: utf-8

require 'gooddata'

require_relative '../config'

GoodData.with_connection($CONFIG[:username], $CONFIG[:password], :server => $CONFIG[:server], :verify_ssl => false) do |client|
  timestamp = DateTime.now.strftime('%Y%m%d%H%M%S')

  project = client.create_project(title: "LCM Service project - #{timestamp}", auth_token: $CONFIG[:tokens][:postgres])

  puts JSON.pretty_generate(project.json)

  # Update config
  config_path = File.expand_path(File.join(File.dirname(__FILE__), '../config.rb'))
  config = File.read(config_path)
  config = config.gsub(/service: '.*'/, "service: '#{project.pid}'")
  File.open(config_path, 'w') { |file| file.puts config }
end
