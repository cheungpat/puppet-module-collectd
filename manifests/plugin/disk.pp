# https://collectd.org/wiki/index.php/Plugin:Disk
class collectd::plugin::disk (
  $ensure         = present,
  $disks          = [],
  $ignoreselected = false,
) {
  include collectd

  $conf_dir = $collectd::plugin_conf_dir
  validate_array($disks)
  validate_bool($ignoreselected)

  file { 'disk.conf':
    ensure    => $collectd::plugin::disk::ensure,
    path      => "${conf_dir}/disk.conf",
    mode      => '0644',
    owner     => 'root',
    group     => 'root',
    content   => template('collectd/disk.conf.erb'),
    notify    => Service['collectd']
  }

}
