# encoding: utf-8

require 'gooddata'

require_relative '../config'

DEFAULT_CRON = '0 15 * * *'

NAME = 'Users Brick - Domain'

GoodData.with_connection($CONFIG[:username], $CONFIG[:password], :server => $CONFIG[:server], :verify_ssl => false) do |client|
  project = client.projects($CONFIG[:projects][:service])
  puts JSON.pretty_generate(project.json)

  path = "#{$CONFIG[:appstore]}/users_brick"

  ###############################
  # Deploy Users Brick - Domain #
  ###############################

  process = project.processes.find { |p| p.name == NAME }
  process.delete if process

  process = project.deploy_process(path, name: NAME)
  puts JSON.pretty_generate(process.json)

  options = {
    params: {
      organization: $CONFIG[:domain],
      CLIENT_GDC_PROTOCOL: 'https',
      CLIENT_GDC_HOSTNAME: $CONFIG[:hostname],
      ads_client: {
        username: $CONFIG[:ads][:username],
        password: $CONFIG[:ads][:password],
        jdbc_url: "jdbc:dss://#{$CONFIG[:hostname]}/gdc/dss/instances/#{$CONFIG[:ads][:id]}"
      },
      input_source: {
        type: 'ads',
        query: $CONFIG[:ads][:query][:domain_users]
      },
      GDC_USERNAME: $CONFIG[:username],
      sync_mode: 'add_to_organization',
      whitelists: $CONFIG[:whitelist]
    }
  }

  schedule = process.create_schedule(DEFAULT_CRON, 'main.rb', options)
  puts JSON.pretty_generate(schedule.json)
end
