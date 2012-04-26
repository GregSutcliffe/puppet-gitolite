class test {

  # Create the admin repo in the inital call, using defaults
  class { 'gitolite': }

  # Optionally override with your own config and keys
  #class { 'gitolite':
  #  authfile => 'puppet:///modules/test/admin.conf',
  #  keydir   => 'puppet:///modules/test/admin-keys',
  #}

  # Add extra repos
  gitolite::repo { 'puppet':
    authfile => 'puppet:///modules/test/puppet.conf',
    keydir   => 'puppet:///modules/test/puppet-keys',
  }

  # Another repo, sharing the keys
  gitolite::repo { 'external':
    authfile => 'puppet:///modules/test/external.conf',
    keydir   => 'puppet:///modules/test/puppet-keys',
  }


}
