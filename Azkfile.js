/**
 * Documentation: http://docs.azk.io/Azkfile.js
 */

function ruby_system(command, extra) {
  var merge = require('azk')._.merge;
  var extra = extra || {};

  return merge({
    // Dependent systems
    depends: ["postgres", "mongodb", "redis", "mail"],
    // More images:  http://images.azk.io
    image: "gullitmiranda/ruby",
    // Steps to execute before running instances
    provision: [
      "bundle install --path /azk/bundler",
      "bundle exec rake db:create",
      "bundle exec rake db:migrate",
    ],
    workdir: "/azk/#{manifest.dir}",
    command: "bundle exec " + command,
    shell: "/bin/bash",
    // not expect application response
    wait: { retry: 20, timeout: 1000 },
    scalable: { "default": 1 },
    // Mounts folders to assigned paths
    mounts: {
      // equivalent mount_folders
      '/azk/#{manifest.dir}'  : path('.'),
      '/www/gems'             : path('../gems', { required: false }),
      '/azk/bundler'          : persistent('bundler'), // Volume nomed
    },
    http: {
      // aircrm.azk.dev
      domains: [ "#{system.name}.#{azk.default_domain}" ]
    },
    envs: {
      // set instances variables
      RUBY_ENV: "development",
      RACK_ENV: "development",
      RAILS_ENV: "development",
      ENABLE_AZK: true,
      HOST: "#{system.name}.#{azk.default_domain}",

      MERCADOLIBRE_APP_ID: 5227026097385184,
      MERCADOLIBRE_APP_SECRET: "6PLlf1ybZP9RyM6jZYvxHpUDgejpEuP5",
    },
    export_envs: {
      HTTP_PORT: "#{azk.default_domain}:#{net.port.http}",
      HTTPS_PORT: "#{azk.default_domain}:#{net.port.http}"
    }
  }, extra);
};

// Adds the systems that shape your system
systems({
  aircrm : ruby_system('rails server --pid /tmp/rails.pid --port $HTTP_PORT'),
  sidekiq: ruby_system('sidekiq', {
    // Disable balancer and wait
    http: null,
    wait: false,
  }),

  mongodb: {
    image              : "dockerfile/mongodb",
    command            : 'mongod --rest --httpinterface',
    scalable: false,
    ports: {
      http: "28017",
    },
    http      : {
      // aircrm-mongodb.azk.dev
      domains: [ "#{manifest.dir}-#{system.name}.#{azk.default_domain}" ],
    },
    // Mounts folders to assigned paths
    mounts: {
      // equivalent persistent_folders
      '/data/db'          : persistent('mongodb'), // Volume nomed
    },
    export_envs        : {
      MONGODB_URI: "mongodb://#{net.host}:#{net.port[27017]}/aircrm_development",
    },
  },
  postgres: {
    image: "wyaeld/postgres:9.3",
    scalable           : false,
    // Mounts folders to assigned paths
    mounts: {
      // equivalent persistent_folders
      '/var/lib/postgresql' : persistent('postgresql'), // Volume nomed
      '/var/log/postgresql' : path('./log/postgresql'),
    },
    ports: {
      data: "5432/tcp",
    },
    envs: {
      // Move this to .env file
      POSTGRESQL_USER: "admin",
      POSTGRESQL_PASS: "oe9jaacZLbR9pN",
      POSTGRESQL_DB  : "aircrm_development",
      POSTGRESQL_HOST: "#{net.host}",
      POSTGRESQL_PORT: "#{net.port.data}",
    },

    export_envs: {
      DATABASE_URL: "postgres://#{envs.POSTGRESQL_USER}:#{envs.POSTGRESQL_PASS}@#{net.host}:#{net.port.data}/#{envs.POSTGRESQL_DB}",
      // DATABASE_URL: "postgres://aircrm_db_user:password14@aircrm1-production.cebfxomjiiwp.us-west-2.rds.amazonaws.com:5432/aircrm_production",
    },
  },
  redis: {
    image: "dockerfile/redis",
    scalable           : false,
    ports: {
      data: "6379/tcp",
    },
    export_envs: {
      REDIS_URL: "redis://#{net.host}:#{net.port.data}/#{manifest.dir}"
    },
    // Mounts folders to assigned paths
    mounts: {
      // equivalent persistent_folders
      '/data' : persistent('redis'), // Volume nomed
    },
  },
  mail: {
    image              : "kdihalas/mail",
    scalable           : false,
    http               : {
      domains: [ "#{manifest.dir}-#{system.name}.#{azk.default_domain}" ],
    },
    ports              : {
      smtp : "25:25/tcp",
      http : "1080/tcp"
    },
    export_envs: {
      MAIL_PORT: "#{net.port.smtp}",
    },
  },
  ngrok: {
    // Dependent systems
    depends: ["aircrm"],
    image     : "gullitmiranda/docker-ngrok",
    // Mounts folders to assigned paths
    mounts: {
      // equivalent persistent_folders
      '/#{system.name}' : path("./log"),
    },
    scalable: { default: 0,  limit: 1 }, // disable auto start
    // not expect application response
    wait: false,
    http      : {
      domains: [ "#{manifest.dir}-#{system.name}.#{azk.default_domain}" ],
    },
    ports     : {
      http : "4040"
    },
    envs      : {
      NGROK_LOG       : "/#{system.name}/log/ngrok.log",
      NGROK_SUBDOMAIN : "aircrm-ml",
      NGROK_AUTH      : "ehXzJi7CGRc8jj74W1Ed",
    }
  }
});

// Sets a default system (to use: start, stop, status, scale)
setDefault("aircrm");
