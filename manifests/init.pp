#
class collectd(
  $fqdnlookup   = true,
  $interval     = 10,
  $purge        = undef,
  $purge_config = false,
  $recurse      = undef,
  $threads      = 5,
  $timeout      = 2,
  $version      = installed,
  $package      = $collectd::params::package,
  $provider     = $collectd::params::provider,
  $plugin_conf_dir = $collectd::params::plugin_conf_dir,
  $config_file  = $collectd::params::config_file,
  $root_group   = $collectd::params::root_group,
  $service_name   = $collectd::params::service_name,
) inherits collectd::params {

  validate_bool($purge_config, $fqdnlookup)

  package { 'collectd':
    ensure   => $version,
    name     => $package,
    provider => $provider,
    before   => File['collectd.conf', 'collectd.d'],
  }

  file { 'collectd.d':
    ensure  => directory,
    name    => $plugin_conf_dir,
    mode    => '0644',
    owner   => 'root',
    group   => $root_group,
    purge   => $purge,
    recurse => $recurse,
  }

  $conf_content = $purge_config ? {
    true    => template('collectd/collectd.conf.erb'),
    default => undef,
  }

  file { 'collectd.conf':
    path    => $config_file,
    content => $conf_content,
    notify  => Service['collectd'],
  }

  if $purge_config != true {
    # former include of conf_d directory
    file_line { 'include_conf_d':
      ensure  => absent,
      line    => "Include \"${plugin_conf_dir}/\"",
      path    => $config_file,
      notify  => Service['collectd'],
    }
    # include (conf_d directory)/*.conf
    file_line { 'include_conf_d_dot_conf':
      ensure  => present,
      line    => "Include \"${plugin_conf_dir}/*.conf\"",
      path    => $config_file,
      notify  => Service['collectd'],
    }
  }

  service { 'collectd':
    ensure    => running,
    name      => $service_name,
    enable    => true,
    require   => Package['collectd'],
  }
}
