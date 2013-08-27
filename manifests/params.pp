# Class: eye::params
#
# This class defines default parameters used by the main module class eye
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to eye class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class eye::params {

  ### Application related parameters

  $package = $::operatingsystem ? {
    default => 'eye',
  }

  $package_provider = $::operatingsystem ? {
    default => 'gem',
  }

  $service = $::operatingsystem ? {
    default => 'eye',
  }

  $service_status = $::operatingsystem ? {
    default => true,
  }

  $process = $::operatingsystem ? {
    default => 'eye',
  }

  $process_args = $::operatingsystem ? {
    default => '',
  }

  $process_user = $::operatingsystem ? {
    default => 'root',
  }

  $config_dir = $::operatingsystem ? {
    default => '/etc/eye',
  }

  $config_file = $::operatingsystem ? {
    default => '/etc/eye/eye.rb',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_init = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc/default/eye',
    default                   => '/etc/sysconfig/eye',
  }

  $pid_file = $::operatingsystem ? {
    default => '/var/run/eye.pid',
  }

  $plugin_check_dir = $::operatingsystem ? {
    default => '/etc/eye/checks',
  }

  $plugin_trigger_dir = $::operatingsystem ? {
    default => '/etc/eye/triggers',
  }

  $initd_path = $::operatingsystem ? {
    default => '/etc/init.d/eye',
  }

  $initd_template = $::operatingsystem ? {
    default => 'eye/eye.initd.erb',
  }

  # General Settings
  $my_class = ''
  $source_dir = ''
  $source_dir_purge = false
  $options = ''
  $service_autorestart = true
  $version = 'present'
  $absent = false
  $disable = false
  $disableboot = false
  $install_plugins = false
  $install_plugin_dependencies = false
  $plugin_check_source_dir = 'puppet:///modules/eye/plugins/checks'
  $plugin_trigger_source_dir = 'puppet:///modules/eye/plugins/triggers'

  ### General module variables that can have a site or per module default
  $monitor = false
  $monitor_tool = ''
  $monitor_target = $::ipaddress
  $puppi = false
  $puppi_helper = 'standard'
  $debug = false
  $audit_only = false
  $noops = false

}
