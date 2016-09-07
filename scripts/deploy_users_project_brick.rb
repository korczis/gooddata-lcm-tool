# encoding: utf-8

require 'gooddata'

require_relative '../config'

DEFAULT_CRON = '0 0 * * *'

NAME = 'Users Brick - Project'

GoodData.with_connection($CONFIG[:username], $CONFIG[:password], :server => $CONFIG[:server], :verify_ssl => false) do |client|
  $CONFIG[:segments].each do |segment, master_pid|

    project = client.projects(master_pid)
    puts JSON.pretty_generate(project.json)

    path = '${PUBLIC_APPSTORE}:branch/tma:/apps/users_brick'

    ################################
    # Deploy Users Brick - Project #
    ################################

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

    schedule = process.create_schedule(DEFAULT_CRON, 'main.rb', options)
    puts JSON.pretty_generate(schedule.json)
  end

end
