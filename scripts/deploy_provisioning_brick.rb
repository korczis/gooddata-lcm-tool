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

  gd_encoded_hidden_params = {
    GDC_PASSWORD: $CONFIG[:password],
    ads_client: {
      username: $CONFIG[:ads][:username],
      password: $CONFIG[:ads][:password],
      jdbc_url: "jdbc:dss://#{$CONFIG[:ads][:hostname]}/gdc/dss/instances/#{$CONFIG[:ads][:id]}"
    },
    user_for_deployment: {
      login: $CONFIG[:username],
      password: $CONFIG[:password],
      server: $CONFIG[:server],
      verify_ssl: false
    },
    tokens: {
      Pg: $CONFIG[:tokens][:postgres],
      vertica: $CONFIG[:tokens][:vertica]
    },
    additional_hidden_params: {
      GD_ADS_PASSWORD: $CONFIG[:ads][:password]
    }.merge($CONFIG[:extra_params] || {})
  }

  options = {
    params: {
      scriptNextVersion: true,
      organization: $CONFIG[:domain],
      CLIENT_GDC_PROTOCOL: 'https',
      CLIENT_GDC_HOSTNAME: $CONFIG[:hostname],
      input_source: {
        type: 'ads',
        query: $CONFIG[:ads][:query][:provisioning]
      },
      technical_user: [
        $CONFIG[:username]
      ],
      GDC_USERNAME: $CONFIG[:username],
      query: {
        provisioning: $CONFIG[:ads][:query][:provisioning],
        release: $CONFIG[:ads][:query][:release]
      },
      delete_extra: $CONFIG[:provisioning][:delete_extra],
      delete_projects: $CONFIG[:provisioning][:delete_projects]
    },
    hidden_params: {}
  }

  #  process.create_schedule(DEFAULT_CRON, 'main.rb', options)
  schedule = process.create_schedule(DEFAULT_CRON, 'main.rb', options)
  schedule.hidden_params = {
    'gd_encoded_hidden_params' => JSON.generate(gd_encoded_hidden_params)
  }
  schedule.save

  puts JSON.pretty_generate(schedule.json)
  schedule.disable!
end
