class jiocloud::system::accounts (
  $local_users,
  $sudo_users,
) {
  include account
  realize Account::Localuser[user1,user2]


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

