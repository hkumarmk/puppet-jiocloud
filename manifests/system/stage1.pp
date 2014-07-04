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
)  {

  ### Set resolv.conf
  include "resolver"
  resolv_conf { "resolv_mu":
    domainname  => $dnsdomainname,
    searchpath  => $dnssearch,
    nameservers => $dnsservers,
  }

  ## Apt source and mirror setup
  class { 'jiocloud::system::apt': 
    require => Resolv_conf['resolv_mu'],
  }

}
