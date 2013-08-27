class eye::plugins inherits eye {

  file { 'eye.checks.dir':
    ensure  => directory,
    path    => $eye::plugin_check_dir,
    notify  => $eye::manage_service_autorestart,
    source  => $eye::plugin_check_source_dir,
    recurse => true,
    purge   => $eye::bool_source_dir_purge,
    force   => $eye::bool_source_dir_purge,
    replace => $eye::manage_file_replace,
    audit   => $eye::manage_audit,
    noop    => $eye::bool_noops,
  }

  file { 'eye.triggers.dir':
    ensure  => directory,
    path    => $eye::plugin_trigger_dir,
    notify  => $eye::manage_service_autorestart,
    source  => $eye::plugin_trigger_source_dir,
    recurse => true,
    purge   => $eye::bool_source_dir_purge,
    force   => $eye::bool_source_dir_purge,
    replace => $eye::manage_file_replace,
    audit   => $eye::manage_audit,
    noop    => $eye::bool_noops,
  }
}
