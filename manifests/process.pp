define eye::process (
  $template       = 'eye/process.rb.erb',
  $process        = '',
  $pidfile        = '',
  $startprogram   = '',
  $stopprogram    = '',
  $cycles         = '5',
  $enable         = 'true') {

  $ensure = bool2ensure($enable)

  require eye

  $real_process = $process ? {
    ''      => $process,
    default => $name,
  }

  $real_pidfile = $pidfile ? {
    ''      => "/var/run/${process}.pid",
    default => $pidfile,
  }

  $real_startprogram = $startprogram ? {
    ''      => "/etc/init.d/${process} start",
    default => $startprogram,
  }

  $real_stopprogram = $stopprogram ? {
    ''      => "/etc/init.d/${process} stop",
    default => $stopprogram,
  }

  concat::fragment { "eye_process_${name}":
    ensure  => $ensure,
    order   => '02',
    target  => $eye::config_file,
    content => template($template),
  }
}
