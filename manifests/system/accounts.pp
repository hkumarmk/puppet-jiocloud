## Class: jiocloud::system::accounts
## Purpose is to group all system user account actions in single class
## Parameters: 
## sudo_users: user list to be in sudo list
## Changelog:
## 2014-06-18: Hkumar: initial setup
## 2014-06-25: AlokJani : moving local account creation list from hardcoded manifest to hiera

class jiocloud::system::accounts (
  $active_users,
  $sudo_users, 
  $users, 
  $root_password,
) {

  user { 'root': 
        name => 'root',
        ensure => present,
        password => $root_password,
  }


  create_resources(add_accounts,$users,{active_users => $active_users})

  define add_accounts (
    $active_users,
    $realname,
    $sshkeys = '',
    $password = '*',
    $shell = '/bin/bash'
  ) {
    if member($active_users,$name) {
      account::localuser { $name:
        realname => $realname,
        sshkeys => $sshkeys,
        password => $password,
        shell => $shell,  
      }
    } 
  }

  class { 'sudo':
        purge => false,
        config_file_replace => false,
  }

  sudo_conf { $sudo_users: }

  define sudo_conf {
    sudo::conf { $name:
        content  => "#Managed By Puppet\n$name ALL=(ALL) NOPASSWD: ALL", 
    }
  }

}
