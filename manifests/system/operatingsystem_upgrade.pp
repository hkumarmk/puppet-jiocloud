##
class jiocloud::system::operatingsystem_upgrade (
  $autoreboot = $jiocloud::params::autoreboot,
) {
  ## Set a factor $no_operatingsystem_upgrade, to avoid operating system upgrade on the node.
  unless $no_operatingsystem_upgrade == 1 {
    ## Update release version  
    file { '/etc/jiocloud-release':
      ensure => file,
      content => "$apt_snapshot_version\n",
      validate_cmd => 'apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" --no-act upgrade  | grep "0 *upgraded,"',
      require => Exec['operatingsystem_upgrade'],
    }

    ## Run upgrade
    ## FIXME: Need to handle vrouter module generation before doing dist-upgrade
    exec {'operatingsystem_upgrade':
      command => 'apt-get update ; apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade',
      logoutput => true,
      environment => 'DEBIAN_FRONTEND=noninteractive',
      onlyif => 'apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" --no-act upgrade  | grep "[1-9][0-9]* *upgraded,"',
    }


    ## Reboot the system if required
    if $autoreboot {
      exec {'operatingsystem_reboot':
        command => 'reboot -f ; sleep 60',
        logoutput => true,
        onlyif => 'grep System.restart.required /var/run/reboot-required',
      }
    }
  }
}

