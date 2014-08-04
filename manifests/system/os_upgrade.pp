##
class jiocloud::system::os_upgrade {
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
}

