# https://collectd.org/wiki/index.php/Plugin:SNMP
class collectd::plugin::snmp (
  $ensure = present,
  $data   = undef,
  $hosts  = undef,
) {
  include collectd

  $conf_dir = $collectd::plugin_conf_dir

  validate_hash($data, $hosts)

  file { 'snmp.conf':
    ensure    => $ensure,
    path      => "${conf_dir}/snmp.conf",
    mode      => '0644',
    owner     => 'root',
    group     => 'root',
    content   => template('collectd/snmp.conf.erb'),
    notify    => Service['collectd']
  }
}
