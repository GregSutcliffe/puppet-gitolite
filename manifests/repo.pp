define gitolite::repo (
  $authfile,
  $keydir
) {

  file { "$gitolite::base/tmp/gitolite-admin/conf/auto/${name}.conf":
    ensure  => present,
    mode    => 0644,
    owner   => "$gitolite::user",
    group   => "$gitolite::group",
    source  => "$authfile",
    require => Exec["Clone admin"],
    notify  => Exec["Update admin"]
  }

  file { "$gitolite::base/tmp/gitolite-admin/keydir/${name}-keys":
    ensure  => directory,
    recurse => true,
    purge   => true,
    mode    => 0644,
    owner   => "$gitolite::user",
    group   => "$gitolite::group",
    source  => "$keydir",
    require => Exec["Clone admin"],
    notify  => Exec["Update admin"]
  }

}
