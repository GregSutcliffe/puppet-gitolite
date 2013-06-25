# Gitolite Puppet Module

Puppet module for configuring the Git auth system, Gitolite (http://sitaramc.github.com/gitolite). This not only installs Gitolite, but allows configuration of Gitolite from Puppet itself.

This is useful if you already have your SSH keys in Puppet (eg. for user account creation), as you can configure both users, their SSH access rights, and their Git access rights, all from Puppet

# Dependencies

* Git (http://github.com/theforeman/puppet-git)

# Compatibility

This module has only been tested on Debian Squeeze. Patches for other OSes welcome!

# Basic install

This installs a bogus SSH key, so you will _only_ be able to manage the `gitolite-admin.git` repository via Puppet

    class { 'gitolite': }

If you want to supply your own config/keys to the `gitolite-admin.git` repository, pass them in like so:

    class { 'gitolite':
      authfile => 'puppet:///modules/mymodule/admin.conf',
      keydir   => 'puppet:///modules/mymodule/admin-keys',
    }

By default, gitolite is installed to '/var/lib/gitolite', with a user & group of 'gitolite'. This is configurable:

    class { 'gitolite':
      base     => "/etc/gitolite",
      user     => "git",
      group    => "git",
    }

# Adding more repositories

For real repositories (i.e anything other than `gitolite-admin.git`) use the custom define:

    gitolite::repo { 'puppet':
      authfile => 'puppet:///modules/test/puppet.conf',
      keydir   => 'puppet:///modules/test/puppet-keys',
    }

See `tests/*` for examples of the config file and keys directory.

# TODO

* Don't include the src.tgz in the module (tiny though it is)

# Contributing

* Fork the project
* Commit and push until you are happy with your contribution

# More info

Copyright (c) 2012 Greg Sutcliffe

This entire repository is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
