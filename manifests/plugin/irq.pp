# https://collectd.org/wiki/index.php/Plugin:IRQ
class collectd::plugin::irq (
  $ensure         = present,
  $irqs           = [],
  $ignoreselected = false,
) {
  include collectd

  $conf_dir = $collectd::plugin_conf_dir
  validate_array($irqs)
  validate_bool($ignoreselected)

  file { 'irq.conf':
    ensure    => $collectd::plugin::irq::ensure,
    path      => "${conf_dir}/irq.conf",
    mode      => '0644',
    owner     => 'root',
    group     => 'root',
    content   => template('collectd/irq.conf.erb'),
    notify    => Service['collectd']
  }
}
