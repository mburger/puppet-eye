# Class: eye::service
#
# This class manages eye services
#
# == Variables
#
# Refer to eye class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It's automatically included by eye
#
class eye::service inherits eye {

  service { 'eye':
    ensure     => $eye::manage_service_ensure,
    name       => $eye::service,
    enable     => $eye::manage_service_enable,
    hasstatus  => $eye::service_status,
    pattern    => $eye::process,
    noop       => $eye::bool_noops,
  }

  case $eye::package_provider {
    gem: {
      file { 'eye.initd':
        ensure  => $eye::manage_file,
        path    => $eye::initd_path,
        mode    => '0755',
        owner   => $eye::config_file_owner,
        group   => $eye::config_file_group,
        before  => Service['eye'],
        content => template($eye::initd_template),
        audit   => $eye::manage_audit,
      }
    }
    default: {}
  }
}
