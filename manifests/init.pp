# = Class: eye
#
# This is the main eye class
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, eye class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $eye_myclass
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, eye main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $eye_source
#
# [*source_dir*]
#   If defined, the whole eye configuration directory content is retrieved
#   recursively from the specified source
#   (source => $source_dir , recurse => true)
#   Can be defined also by the (top scope) variable $eye_source_dir
#
# [*source_dir_purge*]
#   If set to true (default false) the existing configuration directory is
#   mirrored with the content retrieved from source_dir
#   (source => $source_dir , recurse => true , purge => true)
#   Can be defined also by the (top scope) variable $eye_source_dir_purge
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, eye main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $eye_template
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $eye_options
#
# [*service_autorestart*]
#   Automatically restarts the eye service when there is a change in
#   configuration files. Default: true, Set to false if you don't want to
#   automatically restart the service.
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $eye_absent
#
# [*disable*]
#   Set to 'true' to disable service(s) managed by module
#   Can be defined also by the (top scope) variable $eye_disable
#
# [*disableboot*]
#   Set to 'true' to disable service(s) at boot, without checks if it's running
#   Use this when the service is managed by a tool like a cluster software
#   Can be defined also by the (top scope) variable $eye_disableboot
#
# [*monitor*]
#   Set to 'true' to enable monitoring of the services provided by the module
#   Can be defined also by the (top scope) variables $eye_monitor
#   and $monitor
#
# [*monitor_tool*]
#   Define which monitor tools (ad defined in Example42 monitor module)
#   you want to use for eye checks
#   Can be defined also by the (top scope) variables $eye_monitor_tool
#   and $monitor_tool
#
# [*monitor_target*]
#   The Ip address or hostname to use as a target for monitoring tools.
#   Default is the fact $ipaddress
#   Can be defined also by the (top scope) variables $eye_monitor_target
#   and $monitor_target
#
# [*puppi*]
#   Set to 'true' to enable creation of module data files that are used by puppi
#   Can be defined also by the (top scope) variables $eye_puppi and $puppi
#
# [*puppi_helper*]
#   Specify the helper to use for puppi commands. The default for this module
#   is specified in params.pp and is generally a good choice.
#   You can customize the output of puppi commands for this module using another
#   puppi helper. Use the define puppi::helper to create a new custom helper
#   Can be defined also by the (top scope) variables $eye_puppi_helper
#   and $puppi_helper
#
# [*debug*]
#   Set to 'true' to enable modules debugging
#   Can be defined also by the (top scope) variables $eye_debug and $debug
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#   Can be defined also by the (top scope) variables $eye_audit_only
#   and $audit_only
#
# [*noops*]
#   Set noop metaparameter to true for all the resources managed by the module.
#   Basically you can run a dryrun for this specific module if you set
#   this to true. Default: false
#
# Default class params - As defined in eye::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
# [*package*]
#   The name of eye package
#
# [*service*]
#   The name of eye service
#
# [*service_status*]
#   If the eye service init script supports status argument
#
# [*process*]
#   The name of eye process
#
# [*process_args*]
#   The name of eye arguments. Used by puppi and monitor.
#   Used only in case the eye process name is generic (java, ruby...)
#
# [*process_user*]
#   The name of the user eye runs with. Used by puppi and monitor.
#
# [*config_dir*]
#   Main configuration directory. Used by puppi
#
# [*config_file*]
#   Main configuration file path
#
# [*config_file_mode*]
#   Main configuration file path mode
#
# [*config_file_owner*]
#   Main configuration file path owner
#
# [*config_file_group*]
#   Main configuration file path group
#
# [*pid_file*]
#   Path of pid file. Used by monitor
#
# [*data_dir*]
#   Path of application data directory
#
# See README for usage patterns.
#
class eye (
  $my_class            = params_lookup( 'my_class' ),
  $source_dir          = params_lookup( 'source_dir' ),
  $source_dir_purge    = params_lookup( 'source_dir_purge' ),
  $service_autorestart = params_lookup( 'service_autorestart' , 'global' ),
  $options             = params_lookup( 'options' ),
  $version             = params_lookup( 'version' ),
  $absent              = params_lookup( 'absent' ),
  $disable             = params_lookup( 'disable' ),
  $disableboot         = params_lookup( 'disableboot' ),
  $monitor             = params_lookup( 'monitor' , 'global' ),
  $monitor_tool        = params_lookup( 'monitor_tool' , 'global' ),
  $monitor_target      = params_lookup( 'monitor_target' , 'global' ),
  $puppi               = params_lookup( 'puppi' , 'global' ),
  $puppi_helper        = params_lookup( 'puppi_helper' , 'global' ),
  $debug               = params_lookup( 'debug' , 'global' ),
  $audit_only          = params_lookup( 'audit_only' , 'global' ),
  $noops               = params_lookup( 'noops' ),
  $package             = params_lookup( 'package' ),
  $package_provider    = params_lookup( 'package_provider' ),
  $service             = params_lookup( 'service' ),
  $service_status      = params_lookup( 'service_status' ),
  $process             = params_lookup( 'process' ),
  $process_args        = params_lookup( 'process_args' ),
  $process_user        = params_lookup( 'process_user' ),
  $config_dir          = params_lookup( 'config_dir' ),
  $config_file         = params_lookup( 'config_file' ),
  $config_file_mode    = params_lookup( 'config_file_mode' ),
  $config_file_owner   = params_lookup( 'config_file_owner' ),
  $config_file_group   = params_lookup( 'config_file_group' ),
  $pid_file            = params_lookup( 'pid_file' ),
  $data_dir            = params_lookup( 'data_dir' ),
  $initd_path          = params_lookup( 'initd_path' ),
  $initd_template      = params_lookup( 'initd_template' )
  ) inherits eye::params {

  $bool_source_dir_purge=any2bool($source_dir_purge)
  $bool_service_autorestart=any2bool($service_autorestart)
  $bool_absent=any2bool($absent)
  $bool_disable=any2bool($disable)
  $bool_disableboot=any2bool($disableboot)
  $bool_monitor=any2bool($monitor)
  $bool_puppi=any2bool($puppi)
  $bool_debug=any2bool($debug)
  $bool_audit_only=any2bool($audit_only)
  $bool_noops=any2bool($noops)

  ### Definition of some variables used in the module
  $manage_package = $eye::bool_absent ? {
    true  => 'absent',
    false => $eye::version,
  }

  $manage_service_enable = $eye::bool_disableboot ? {
    true    => false,
    default => $eye::bool_disable ? {
      true    => false,
      default => $eye::bool_absent ? {
        true  => false,
        false => true,
      },
    },
  }

  $manage_service_ensure = $eye::bool_disable ? {
    true    => 'stopped',
    default =>  $eye::bool_absent ? {
      true    => 'stopped',
      default => 'running',
    },
  }

  $manage_service_autorestart = $eye::bool_service_autorestart ? {
    true    => Service[eye],
    false   => undef,
  }

  $manage_file = $eye::bool_absent ? {
    true    => 'absent',
    default => 'present',
  }

  if $eye::bool_absent == true
  or $eye::bool_disable == true
  or $eye::bool_disableboot == true {
    $manage_monitor = false
  } else {
    $manage_monitor = true
  }

  $manage_audit = $eye::bool_audit_only ? {
    true  => 'all',
    false => undef,
  }

  $manage_file_replace = $eye::bool_audit_only ? {
    true  => false,
    false => true,
  }

  $data_dir_ensure = $eye::bool_absent ? {
    true  => 'absent',
    false => 'directory',
  }

  ### Managed resources
  class { 'eye::install': }
  class { 'eye::config':
    require => Class['eye::install']
  }
  class { 'eye::service':
    require => Class['eye::config']
  }


  ### Include custom class if $my_class is set
  if $eye::my_class {
    include $eye::my_class
  }


  ### Provide puppi data, if enabled ( puppi => true )
  if $eye::bool_puppi == true {
    $classvars=get_class_args()
    puppi::ze { 'eye':
      ensure    => $eye::manage_file,
      variables => $classvars,
      helper    => $eye::puppi_helper,
      noop      => $eye::bool_noops,
    }
  }


  ### Service monitoring, if enabled ( monitor => true )
  if $eye::bool_monitor == true {
    if $eye::service != '' {
      monitor::process { 'eye_process':
        process  => $eye::process,
        service  => $eye::service,
        pidfile  => $eye::pid_file,
        user     => $eye::process_user,
        argument => $eye::process_args,
        tool     => $eye::monitor_tool,
        enable   => $eye::manage_monitor,
        noop     => $eye::bool_noops,
      }
    }
  }


  ### Debugging, if enabled ( debug => true )
  if $eye::bool_debug == true {
    file { 'debug_eye':
      ensure  => $eye::manage_file,
      path    => "${settings::vardir}/debug-eye",
      mode    => '0640',
      owner   => 'root',
      group   => 'root',
      content => inline_template('<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime.*|path|timestamp|free|.*password.*|.*psk.*|.*key)/ }.to_yaml %>'),
      noop    => $eye::bool_noops,
    }
  }

}
