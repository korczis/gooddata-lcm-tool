# encoding: utf-8

require 'gooddata'

require_relative '../config'

DEFAULT_CRON = '0 0 * * *'

NAME = 'Provisioning Brick'

GoodData.with_connection($CONFIG[:username], $CONFIG[:password], :server => $CONFIG[:server], :verify_ssl => false) do |client|
  project = client.projects($CONFIG[:projects][:service])
  puts JSON.pretty_generate(project.json)

  path = "#{$CONFIG[:appstore]}/provisioning_brick"

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
        jdbc_url: "jdbc:dss://secure.gooddata.com/gdc/dss/instances/#{$CONFIG[:ads][:id]}"
      },
      input_source: {
        type: 'ads',
        query: $CONFIG[:ads][:query][:provisioning]
      },
      technical_user: [
        $CONFIG[:username]
      ],
      user_for_deployment: {
        login: $CONFIG[:username],
        password: $CONFIG[:password],
        server: $CONFIG[:server],
        verify_ssl: false
      },
      GDC_USERNAME: $CONFIG[:username]
    },
    hidden_params: {
      GDC_PASSWORD: $CONFIG[:password],
      additional_hidden_params: {
        GD_ADS_PASSWORD: $CONFIG[:ads][:password]
      }
    }
  }

  #  process.create_schedule(DEFAULT_CRON, 'main.rb', options)
  schedule = process.create_schedule(DEFAULT_CRON, 'main.rb', options)
  puts JSON.pretty_generate(schedule.json)
  schedule.disable!
end
