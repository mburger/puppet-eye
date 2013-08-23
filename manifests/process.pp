define eye::process (
  $template       = 'eye/process.rb.erb',
  $process        = '',
  $pidfile        = '',
  $startprogram   = '',
  $stopprogram    = '',
  $cycles         = '5',
  $config_hash    = {},
  $enable         = 'true') {

  $ensure = bool2ensure($enable)

  require eye

  $real_process = $process ? {
    ''      => $process,
    default => $name,
  }

  case $config_hash['eye'] {
    '', undef: {}
    default: {
      $eye_config_hash = $config_hash['eye']
      $checks = $eye_config_hash['checks'] ? {
        ''      => undef,
        default => $eye_config_hash['checks']
      }

      $triggers = $eye_config_hash['triggers'] ? {
        ''      => undef,
        default => $eye_config_hash['triggers']
      }
    }
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
