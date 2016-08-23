# encoding: utf-8

require 'gooddata'

require_relative '../config'

DEFAULT_CRON = '0 0 * * *'

GoodData.with_connection($CONFIG[:username], $CONFIG[:password], :server => $CONFIG[:server], :verify_ssl => false) do |client|
  project = client.projects($CONFIG[:projects][:service])
  puts JSON.pretty_generate(project.json)

  path = '${PUBLIC_APPSTORE}:branch/tma:/apps/users_brick'

  ###############################
  # Deploy Users Brick - Domain #
  ###############################

  process = project.deploy_process(path, name: 'Users Brick - Domain')
  puts JSON.pretty_generate(process.json)

  options = {
    params: {
      organization: $CONFIG[:domain],
      CLIENT_GDC_PROTOCOL: 'https',
      CLIENT_GDC_HOSTNAME: $CONFIG[:hostname],
      ads_client: {
        username: $CONFIG[:ads][:username],
        password: $CONFIG[:ads][:password],
        ads_id: $CONFIG[:ads][:id]
      },
      input_source: {
        type: 'ads',
        query: $CONFIG[:ads][:query][:domain_users]
      },
      GDC_USERNAME: $CONFIG[:username]
    },
    sync_mode: 'add_to_organization',
    whitelists: %w(@gooddata.com)
  }

  schedule = process.create_schedule(DEFAULT_CRON, 'main.rb', options)
  puts JSON.pretty_generate(schedule.json)

  ################################
  # Deploy Users Brick - Project #
  ################################

  process = project.deploy_process(path, name: 'Users Brick - Project')
  puts JSON.pretty_generate(process.json)

  options = {
    params: {
      organization: $CONFIG[:domain],
      CLIENT_GDC_PROTOCOL: 'https',
      CLIENT_GDC_HOSTNAME: $CONFIG[:hostname],
      ads_client: {
        username: $CONFIG[:ads][:username],
        password: $CONFIG[:ads][:password],
        ads_id: $CONFIG[:ads][:id]
      },
      input_source: {
        type: 'ads',
        query: $CONFIG[:ads][:query][:project_users]
      },
      GDC_USERNAME: $CONFIG[:username]
    },
    sync_mode: 'sync_one_project_based_on_custom_id',
    multiple_projects_column: 'custom_project_id',
    whitelists: %w(@gooddata.com)
  }

  schedule = process.create_schedule(schedule, 'main.rb', options)
  puts JSON.pretty_generate(schedule.json)
end
