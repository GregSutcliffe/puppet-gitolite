class gitolite (
  $authfile = 'puppet:///modules/gitolite/admin.conf',
  $keydir   = 'puppet:///modules/gitolite/admin-keys',
  $base     = $gitolite::params::base,
  $package  = $gitolite::params::package,
  $user     = $gitolite::params::user,
  $group    = $gitolite::params::group
) inherits gitolite::params {

  class { 'git': }->
  class { 'gitolite::install': }~>
  class { 'gitolite::config': }

}
