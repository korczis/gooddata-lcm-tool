$CONFIG = {
  appstore: '${PUBLIC_APPSTORE}:branch/tma:/apps',
  username: '<USERNAME>',
  password: '<PASSWORD>',
  domain: '<DOMAIN>',
  hostname: 'staging.intgdc.com',
  server: 'https://staging.intgdc.com',

  tokens: {
    postgres: '<POSTGRES_TOKEN>',
    vertica: '<VERTICA_TOKEN>',
  },

  segments: {
    basic: '<BASIC_MASTER_PID>',
    premium: '<PREMIUM_MASTER_PID>'
  },

  projects: {
    development: '<DEVELOPMENT_PID>',
    service: '<SERVICE_PID>'
  },

  # ADS Settings
  ads: {
    username: '<SECURE_USERNAME>',
    password: '<SECURE_PASSWORD>',
    id: '<INSTANCE_ID>',
    query: {
      provisioning: 'SELECT identifier as client_id, name as project_title, segment as segment_id FROM lcm_project LIMIT 1;',
      domain_users: 'SELECT distinct LOWER(login) as login, LOWER(login) as email, first_name, last_name FROM lcm_users;',
      project_users: 'SELECT client_id as custom_project_id, LOWER(login) as login, role FROM lcm_user;',
      release: 'SELECT segment_id, master_project_pid as master_project_id from lcm_release;'
    }
  },

  # Deployment Settings
  deploy: {
    username: '<USERNAME>',
    password: '<PASSWORD>',
    domain: '<DOMAIN>',
    server: 'https://staging.intgdc.com'
  },

  # Ignore list for user brick
  whitelist: [
    '@gooddata.com'
  ]
}
