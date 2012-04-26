class gitolite::params {

  case $::operatingsystem {
    'debian': {
      $package = "gitolite"
    }
    default: {
      fail("Gitolite has not been tested on OS: $::operatingsystem")
    }
  }

  $base    = "/var/lib/gitolite"
  $user    = "gitolite"
  $group   = "gitolite"

}
