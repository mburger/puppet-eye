class eye::dependencies inherits eye {

  case $eye::package_provider {
    gem: {
      if !defined(Package[active_record]) {
        package { 'active_record':
          ensure    => $eye::manage_package,
          provider  => gem,
          notify    => $eye::manage_service_autorestart,
          noop      => $eye::bool_noops,
        }
      }
      if !defined(Package[radiustar]) {
        package { 'radiustar':
          ensure    => $eye::manage_package,
          provider  => gem,
          notify    => $eye::manage_service_autorestart,
          noop      => $eye::bool_noops,
        }
      }
      if !defined(Package[net-tftp]) {
        package { 'net-tftp':
          ensure    => $eye::manage_package,
          provider  => gem,
          notify    => $eye::manage_service_autorestart,
          noop      => $eye::bool_noops,
        }
      }
      if !defined(Package[opentsdb]) {
        package { 'opentsdb':
          ensure    => $eye::manage_package,
          provider  => gem,
          notify    => $eye::manage_service_autorestart,
          noop      => $eye::bool_noops,
        }
      }
    }
    rbenv: {
      if !defined(Rbenv::Gem[activerecord]) {
        rbenv::gem { 'activerecord':
          ruby_version  => '2.0.0-p247',
          notify        => $eye::manage_service_autorestart,
          noop          => $eye::bool_noops,
        }
      }
      if !defined(Rbenv::Gem[radiustar]) {
        rbenv::gem { 'radiustar':
          ruby_version  => '2.0.0-p247',
          version       => '0.0.3',
          notify        => $eye::manage_service_autorestart,
          noop          => $eye::bool_noops,
        }
      }
      if !defined(Rbenv::Gem[net-tftp]) {
        rbenv::gem { 'net-tftp':
          ruby_version  => '2.0.0-p247',
          notify        => $eye::manage_service_autorestart,
          noop          => $eye::bool_noops,
        }
      }
      if !defined(Rbenv::Gem[opentsdb]) {
        rbenv::gem { 'opentsdb':
          ruby_version  => '2.0.0-p247',
          notify        => $eye::manage_service_autorestart,
          noop          => $eye::bool_noops,
        }
      }
    }
  }
}
