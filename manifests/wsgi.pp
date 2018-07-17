# == Class sentry::wsgi
#
# Install an Apache virtual host, configure mod_wsgi,
# and run Sentry.  HTTPS support is optional.
#
# === Authors
#
# Dan Sajner <dsajner@covermymeds.com>
# Scott Merrill <smerrill@covermymeds.com>
#
# === Copyright
#
# Copyright 2015 CoverMyMeds
#
# === Params
#
# @param path the virtualenv path for your Sentry installation
#
class sentry::wsgi (
  $path = $sentry::path,
) {

  include ::nginx

  file { "${path}/app_init.wsgi":
    ensure  => present,
    content => template('sentry/app_init.wsgi.erb'),
  }

}
