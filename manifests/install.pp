# Class: eye::install
#
# This class installs eye
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
class eye::install inherits eye {

  case $eye::package_provider {
    gem: {
      package { $eye::package:
        ensure    => $eye::manage_package,
        provider  => $eye::package_provider,
        noop      => $eye::noops,
      }
    }
    rbenv: {
      rbenv::gem { 'eye':
        ruby_version => '2.0.0-p247'
      }
    }
  }
}
