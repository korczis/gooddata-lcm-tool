# encoding: utf-8

require 'gooddata'

require_relative '../config'

GoodData.with_connection($CONFIG[:username], $CONFIG[:password], :server => $CONFIG[:server], :verify_ssl => false) do |client|
  # Domain
  domain = client.domain($CONFIG[:domain])

  segments = $CONFIG[:segments] || {}

  segments.each do |name, master_project_pid|
    segment = domain.create_segment(segment_id: name, master_project: client.projects(master_project_pid))
    segment.synchronize_clients
    puts JSON.pretty_generate(segment.json)
  end
end
