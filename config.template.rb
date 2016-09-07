$CONFIG = {
  username: '<USERNAME>',
  password: '<PASSWORD>',
  domain: '<DOMAIN>',
  hostname: '<HOSTNAME>',
  server: '<SERVER>',
  token: '<TOKEN>',

  segments: {
    'basic' => '<MASTER_PID>',
    'premium' => '<MASTER_PID>'
  },

  # ADS Settings
  ads: {
    username: '<USERNAME>',
    password: '<PASSWORD>',
    id: '<INSTANCE_ID>',
    query: {
      provisioning: 'SELECT identifier as client_id, name as project_title, segment as segment_id FROM lcm_projects LIMIT 1;',
      domain_users: 'SELECT distinct LOWER(login) as login, LOWER(login) as email, first_name, last_name FROM lcm_users;',
      project_users: 'SELECT client_id as custom_project_id, LOWER(login) as login, role FROM lcm_users;',
      release: 'SELECT * from lcm_release'
    }
  },

  # Deployment Settings
  deploy: {
    username: '<USERNAME>',
    password: '<PASSWORD>',
    server: '<SERVER>'
  }
}
