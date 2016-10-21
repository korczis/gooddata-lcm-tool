# encoding: utf-8

require 'gooddata'

require_relative '../config'

DEFAULT_CRON = '0 0 * * *'

NAME = 'Rollout Brick'

GoodData.with_connection($CONFIG[:username], $CONFIG[:password], :server => $CONFIG[:server], :verify_ssl => false) do |client|
  project = client.projects($CONFIG[:projects][:service])
  puts JSON.pretty_generate(project.json)

  path = "#{$CONFIG[:appstore]}/rollout_brick"

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
    technical_user: [
      $CONFIG[:username]
    ],
    user_for_deployment: {
      login: $CONFIG[:username],
      password: $CONFIG[:password],
      server: $CONFIG[:server],
      verify_ssl: false
    },
    additional_hidden_params: {
      GD_ADS_PASSWORD: $CONFIG[:ads][:password],
      ads_client: {
        username: $CONFIG[:ads][:username],
        password: $CONFIG[:ads][:password],
        jdbc_url: "jdbc:dss://#{$CONFIG[:ads][:hostname]}/gdc/dss/instances/#{$CONFIG[:ads][:id]}"
      },
      gd_encoded_hidden_params: {}
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
        query: $CONFIG[:ads][:query][:release]
      },
      GDC_USERNAME: $CONFIG[:username],
      query: {
        release: $CONFIG[:ads][:query][:release]
      },
      update_preference: {},
      maql_replacements: $CONFIG[:maql_replacements]
    },
    hidden_params: {}
  }

  puts JSON.pretty_generate(options[:params].merge(gd_encoded_hidden_params))

  #  process.create_schedule(DEFAULT_CRON, 'main.rb', options)
  schedule = process.create_schedule(DEFAULT_CRON, 'main.rb', options)
  schedule.hidden_params = {
    'gd_encoded_hidden_params' => JSON.generate(gd_encoded_hidden_params)
  }
  schedule.save

  puts JSON.pretty_generate(schedule.json)
  schedule.disable!
end
