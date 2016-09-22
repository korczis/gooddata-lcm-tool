$CONFIG = {
  appstore: '${PUBLIC_APPSTORE}:branch/tma:/apps',
  username: '<USERNAME>',
  password: '<PASSWORD>',
  domain: '<DOMAIN>',
  hostname: '<HOSTNAME>',
  server: 'https://<SERVER>',

  tokens: {
    postgres: '<TOKEN_POSTGRES>',
    vertica: '<TOKEN_VERTICA>',
  },

  segments: {
    basic: {
      name: 'PostgreSQL Master ##{version}',
      driver: 'Pg',
      master_project: 'pid'
    },
    premium: {
      name: 'Vertica Master ##{version}',
      driver: 'vertica'
    }
  },

  projects: {
    development: 'qlqru2j19kikaddvhbm6jz76kjye24l4',
    service: 'lt8xrgfpi9k9r56nwhurjt48ftikzezz'
  },

  # ADS Settings
  ads: {
    hostname: '<ADS_HOSTNAME>',
    username: '<USERNAME>',
    password: '<PASSWORD>',
    id: 'w9c4aec5c9944ac5789e8bcc7b352b23',
    query: {
      provisioning: 'SELECT identifier as client_id, name as project_title, segment as segment_id FROM lcm_project;',
      domain_users: 'SELECT distinct LOWER(login) as login, LOWER(login) as email, first_name, last_name FROM lcm_user;',
      project_users: 'SELECT client_id as custom_project_id, LOWER(login) as login, role FROM lcm_user;',
      release: 'SELECT segment_id, master_project_id from lcm_release;'
    }
  },

  # Deployment Settings
  deploy: {
    username: '<USERNAME>',
    password: '<PASSWORD>',
    domain: '<DOMAIN>',
    server: 'https://<SERVER>'
  },

  # Ignore list for user brick
  whitelist: [
    '@gooddata.com'
  ]
}
