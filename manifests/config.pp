class sentry::config (
  $admin_email       = $sentry::admin_email,
  $admin_password    = $sentry::admin_password,
  $custom_config     = $sentry::custom_config,
  $custom_settings   = $sentry::custom_settings,
  $db_engine         = $sentry::db_engine,
  $db_host           = $sentry::db_host,
  $db_name           = $sentry::db_name,
  $db_password       = $sentry::db_password,
  $db_port           = $sentry::db_port,
  $db_user           = $sentry::db_user,
  $email_from        = $sentry::email_from,
  $group             = $sentry::group,
  $ldap_base_ou      = $sentry::ldap_base_ou,
  $ldap_domain       = $sentry::ldap_domain,
  $ldap_group_base   = $sentry::ldap_group_base,
  $ldap_group_dn     = $sentry::ldap_group_dn,
  $ldap_host         = $sentry::ldap_host,
  $ldap_user         = $sentry::ldap_user,
  $ldap_password     = $sentry::ldap_password,
  $memcached_host    = $sentry::memcached_host,
  $memcached_port    = $sentry::memcached_port,
  $metrics_enable    = $sentry::metrics_enable,
  $metrics_backend   = $sentry::metrics_backend,
  $organization      = $sentry::organization,
  $path              = $sentry::path,
  $redis_host        = $sentry::redis_host,
  $redis_port        = $sentry::redis_port,
  $secret_key        = $sentry::secret_key,
  $smtp_host         = $sentry::smtp_host,
  $statsd_host       = $sentry::statsd_host,
  $statsd_port       = $sentry::statsd_port,
  $url_prefix        = $sentry::url_prefix,
  $user              = $sentry::user,
  $wsgi_host         = $sentry::wsgi_host,
  $wsgi_port         = $sentry::wsgi_port,
  $wsgi_workers      = $sentry::wsgi_workers,
) {
  assert_private()

  if $url_prefix {
    $_url_prefix = $url_prefix
  } else {
    $_url_prefix = "https://${sentry::vhost}"
  }
  $_db_engine = $db_engine? {
    'mysql'      => 'django.db.backends.mysql',
    'postgresql' => 'sentry.db.postgres',
    'pgsql'      => 'sentry.db.postgres',
    default      => $db_engine,
  }

  if $db_port == 'default' {
    $_db_port = $_db_engine? {
      'django.db.backends.mysql' => '3306',
      'sentry.db.postgres'       => '5432',
      default                    => '',
    }
    if $_db_port == '' {
      fail('unknown db engine and no port specified')
    }
  } else {
    $_db_port = $db_port
  }

  file { "${path}/sentry.conf.py":
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0644',
    content => template('sentry/sentry.conf.py.erb'),
  }

  file { "${path}/config.yml":
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => '0644',
    content => template('sentry/config.yml.erb'),
  }
}
