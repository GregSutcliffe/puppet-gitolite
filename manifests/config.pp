class gitolite::config {

  # Install the one-time admin key. This could be done better
  file { "$gitolite::base/.gitolite.rc":
    ensure  => present,
    mode    => 0660,
    owner   => "gitolite",
    group   => "gitolite",
    source  => "puppet:///modules/gitolite/gitolite-rc",
  }

  file { "$gitolite::base/admin-update.sh":
    ensure => present,
    mode    => 0770,
    owner   => "gitolite",
    group   => "gitolite",
    content => template('gitolite/admin-update.sh.erb'),
  }

  # Build a onetime key. This is replaced in the admin repo setup section
  exec { 'one-time-key':
    cwd     => "$gitolite::base",
    command => "/usr/bin/ssh-keygen -f $gitolite::base/admin -P '' -q",
    creates => "$gitolite::base/admin.pub",
  }

  # Build the repo
  exec { "/usr/bin/gl-setup $gitolite::base/admin.pub":
    cwd         => "$gitolite::base",
    user        => "$gitolite::user",
    environment => "HOME=$gitolite::base",
    creates     => "$gitolite::base/.gitolite",
    require     => [Exec['one-time-key'],File["$gitolite::base/.gitolite.rc"]],
  }
  ->
  exec { "Clone admin":
    command => "/usr/bin/git clone $gitolite::base/repositories/gitolite-admin.git",
    cwd     => "$gitolite::base/tmp",
    user    => "$gitolite::user",
    creates => "$gitolite::base/tmp/gitolite-admin",
  }
  ->
  file { "$gitolite::base/tmp/gitolite-admin/keydir/admin.pub": ensure => absent }

  file { "$gitolite::base/tmp/gitolite-admin/conf/gitolite.conf":
    ensure  => present,
    mode    => 0644,
    owner   => "$gitolite::user",
    group   => "$gitolite::group",
    source  => "puppet:///modules/gitolite/gitolite.conf",
    require => Exec["Clone admin"],
    notify  => Exec["Update admin"]
  }

  file { "$gitolite::base/tmp/gitolite-admin/conf/auto":
    ensure  => directory,
    mode    => 0755,
    owner   => "$gitolite::user",
    group   => "$gitolite::group",
    require => Exec["Clone admin"],
    notify  => Exec["Update admin"],
  }

  exec { "Update admin":
    command     => "/bin/su -c '$gitolite::base/admin-update.sh' - $gitolite::user",
    cwd         => "$gitolite::base/tmp/gitolite-admin",
    refreshonly => true,
    require     => File["$gitolite::base/admin-update.sh"],
  }

  # Create the base repo from the user values
  gitolite::repo { 'admin':
    authfile => "$gitolite::authfile",
    keydir => "$gitolite::keydir",
  }

}
