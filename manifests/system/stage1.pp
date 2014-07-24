## Class: jiocloud::system::stage1
## Purpose: Stage1 of system configurations, This is the first set of manifests run. add all dependancies for stage2 here.
## Parameters:
## dnsdomainname: dns domain name
## dnssearch: array of dns search domains
## dnsservers: array of dns servers
##
## ChangeLog:
# 2014-06-18: Hkumar: migrated to jiocloud module 
# 2014-06-25: AlokJani: Adding local_users parameter

class jiocloud::system::stage1 ( 
  $dnsdomainname = $jiocloud::params::dnsdomainname,
  $dnssearch = $jiocloud::params::dnssearch,
  $dnsservers = $jiocloud::params::dnsservers,
  $active_users = $jiocloud::params::active_users,
  $sudo_users = $jiocloud::params::sudo_users,
  $users = $jiocloud::params::users,
)  {

  ### Set resolv.conf
  include "resolver"
  resolv_conf { "resolv_mu":
    domainname  => $dnsdomainname,
    searchpath  => $dnssearch,
    nameservers => $dnsservers,
  }

  ## Setup user accounts
  class {'jiocloud::system::accounts':
    active_users => $active_users,
    sudo_users => $sudo_users,
    users => $users,
    root_password => $root_password,
  }

  ## Apt source and mirror setup
  class { 'jiocloud::system::apt': 
    require => Resolv_conf['resolv_mu'],
  }

}
