class gitolite (
  $authfile = 'puppet:///modules/test/admin.conf',
  $keydir   = 'puppet:///modules/test/admin-keys',
  $base     = $gitolite::params::base,
  $package  = $gitolite::params::package,
  $user     = $gitolite::params::user,
  $group    = $gitolite::params::group
) inherits gitolite::params {

  class { 'git': }->
  class { 'gitolite::install': }~>
  class { 'gitolite::config': }

}
