class gitolite::install {

  # We roll our own to get access to gl-admin-push from latest code
  package { $gitolite::package: ensure => absent }

  # Create user/group at install to have a dir to unpack in
  group { "$gitolite::group":
    ensure  => present,
  }

  user { "$gitolite::user":
    ensure  => present,
    gid     => "$gitolite::group",
    home    => "$gitolite::base",
    shell   => "/bin/bash",
  }

  file { ["$gitolite::base","$gitolite::base/tmp"]:
    ensure  => directory,
    mode    => 0755,
    owner   => "$gitolite::user",
    group   => "$gitolite::group",
    require => [
       User[$gitolite::user],
       Group[$gitolite::group],
    ]
  }

  file {"$gitolite::base/.gitconfig":
     ensure  => file,
     mode    => 0644,
     owner   => "$gitolite::user",
     group   => "$gitolite::group",
     content => template('gitolite/gitconfig.erb'),
     require => File[$gitolite::base],
  }


  file { "$gitolite::base/gitolite.src.tgz":
    ensure => present,
    source => "puppet:///modules/gitolite/gitolite.src.tgz",
  }
  ~>
  exec { "Install Gitolite":
    command     => "/bin/tar xzf $gitolite::base/gitolite.src.tgz",
    cwd         => "/",
    refreshonly => true,
  }
}
