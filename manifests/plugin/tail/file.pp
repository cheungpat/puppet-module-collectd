#
define collectd::plugin::tail::file (
  $filename,
  $instance,
  $matches,
  $ensure = 'present',
) {
  include collectd
  include collectd::plugin::tail

  $conf_dir = $collectd::plugin_conf_dir

  validate_absolute_path($filename)
  validate_string($instance)
  validate_array($matches)
  validate_hash($matches[0])

  file { "${name}.conf":
    ensure    => $ensure,
    path      => "${conf_dir}/tail-${name}.conf",
    mode      => '0644',
    owner     => 'root',
    group     => 'root',
    content   => template('collectd/tail-file.conf.erb'),
    notify    => Service['collectd'],
  }
}
