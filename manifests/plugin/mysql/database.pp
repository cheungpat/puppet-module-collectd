#
define collectd::plugin::mysql::database (
  $ensure      = 'present',
  $database    = $name,
  $host        = 'UNSET',
  $username    = 'UNSET',
  $password    = 'UNSET',
  $port        = '3306',
  $masterstats = false,
  $slavestats  = false,
) {
  include collectd
  include collectd::plugin::mysql

  $conf_dir = $collectd::plugin_conf_dir

  validate_string($database, $host, $username, $password, $port)
  validate_bool($masterstats, $slavestats)

  if ($masterstats == true and $slavestats == true) {
    fail('master and slave statistics are mutually exclusive.')
  }

  file { "${name}.conf":
    ensure    => $ensure,
    path      => "${conf_dir}/mysql-${name}.conf",
    mode      => '0644',
    owner     => 'root',
    group     => 'root',
    content   => template('collectd/mysql-database.conf.erb'),
    notify    => Service['collectd'],
  }
}
