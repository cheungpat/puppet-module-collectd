# See http://collectd.org/documentation/manpages/collectd.conf.5.shtml#plugin_exec
define collectd::plugin::exec (
  $user,
  $group,
  $exec              = [],
  $notification_exec = [],
) {
  include collectd

  validate_array($exec)
  validate_array($notification_exec)

  $conf_dir = $collectd::plugin_conf_dir

  file {
    "${name}.load":
      path    => "${conf_dir}/${name}.conf",
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('collectd/exec.conf.erb'),
      notify  => Service['collectd'],
  }
}
