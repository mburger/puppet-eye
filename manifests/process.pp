define eye::process (
  $template       = 'eye/process.rb.erb',
  $process        = '',
  $pidfile        = '',
  $startprogram   = '',
  $stopprogram    = '',
  $cycles         = '5',
  $cpu_below      = '',
  $cpu_every      = '5',
  $cpu_times      = [3,5],
  $memory_below   = '',
  $memory_every   = '5',
  $memory_times   = [3,5],
  $enable         = 'true') {

  $ensure = bool2ensure($enable)

  $manage_cpu_check = $cpu_below ? {
    ''      => false,
    default => true,
  }

  $manage_memory_check = $memory_below ? {
    ''      => false,
    default => true,
  }

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
