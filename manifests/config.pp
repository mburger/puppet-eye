#Class: eye::config
#
# This class manages eye configuration
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
class eye::config ( ) {

  # The whole eye configuration directory can be recursively overriden
  if $eye::source_dir {
    file { 'eye.dir':
      ensure  => directory,
      path    => $eye::config_dir,
      notify  => $eye::manage_service_autorestart,
      source  => $eye::source_dir,
      recurse => true,
      purge   => $eye::bool_source_dir_purge,
      force   => $eye::bool_source_dir_purge,
      replace => $eye::manage_file_replace,
      audit   => $eye::manage_audit,
      noop    => $eye::bool_noops,
    }
  }
  else {
    file { 'eye.dir':
      ensure  => $eye::data_dir_ensure,
      path    => $eye::config_dir,
      replace => $eye::manage_file_replace,
      audit   => $eye::manage_audit,
      noop    => $eye::bool_noops,
    }
  }

  include concat::setup

  concat { $eye::config_file:
    mode    => $eye::config_file_mode,
    owner   => $eye::config_file_owner,
    group   => $eye::config_file_group,
  }

  concat::fragment { 'eye_head':
    ensure  => present,
    order   => '01',
    target  => $eye::config_file,
    content => template('eye/eye_head.rb.erb'),
    require => File['eye.dir'],
  }

  concat::fragment { 'eye_footer':
    ensure  => present,
    order   => '03',
    target  => $eye::config_file,
    content => template('eye/eye_footer.rb.erb'),
    require => File['eye.dir'],
  }
}
