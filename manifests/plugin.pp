#
define collectd::plugin (
  $ensure = 'present',
) {

  include collectd

  $plugin = $name
  $conf_dir = $collectd::plugin_conf_dir

  file { "${plugin}.load":
    ensure  => $ensure,
    path    => "${conf_dir}/${plugin}.conf",
    owner   => root,
    group   => root,
    mode    => '0644',
    content => "LoadPlugin ${plugin}\n",
    notify  => Service['collectd'],
  }

}
