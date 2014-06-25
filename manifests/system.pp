## Class: jiocloud::system
## Purpose: to group all system level configuration together.
## Parameters:
## dnsdomainname: dns domain name
## dnssearch: array of dns search domains
## dnsservers: array of dns servers
## dns_master_server: master dns server 
## update_dns: true to create cnames with functional based short names for the servers.
## dnsupdate_key: secure key to update dns server
## sudo_users: users to setup sudo with all commands allowed
## all_nodes_services_to_run: services to assure to be started on all nodes
## ntp_server_servers: list of ntp servers to be configured on local ntp servers
## ntp_servers: list of local ntp servers
##
## ChangeLog:
# 2014-06-18: Hkumar: migrated to jiocloud module 

class jiocloud::system ( 
  $dnsdomainname = $jiocloud::params::dnsdomainname,
  $dnssearch = $jiocloud::params::dnssearch,
  $dnsservers = $jiocloud::params::dnsservers,
  $dns_master_server = $jiocloud::params::dns_master_server,
  $dnsupdate_key = $jiocloud::params::dnsupdate_key,
  $update_dns = $jiocloud::params::update_dns,
  $sudo_users = $jiocloud::params::sudo_users,
  $all_nodes_services_to_run = $jiocloud::params::all_nodes_services_to_run,
  $ntp_server_servers = $jiocloud::params::ntp_server_servers,
  $ntp_servers = $jiocloud::params::ntp_servers,
) inherits jiocloud::params {

  ### Set resolv.conf
  import "resolver"
  resolv_conf { "resolv_mu":
    domainname  => $dnsdomainname,
    searchpath  => $dnssearch,
    nameservers => $dnsservers,
  }

  ## Set hostname based on reverse dns lookup
  class {'::sethostname':
    domain_name           => $dnsdomainname,
    dns_master_server     => $dns_master_server,
    dnsupdate_key         => $dnsupdate_key,
# Alok - Disableing this for now. Amar will be uploading a new module
#    update_dns            => $update_dns,
  }
    
  ## Setup user accounts
  class {'jiocloud::system::accounts':
    sudo_users => $sudo_users,
  }

  ## File distribution/configuration
  include 'jiocloud::system::files'
  
  ## Make sure services are running:
  service { $all_nodes_services_to_run:
      ensure     => running,
      enable     => true,
      hasstatus  => true,
      hasrestart => false,
      #provider  => "upstart",
  }

  ###Setup Timezone Asia/Kolkata
  class { '::timezone':
    timezone => 'Asia/Calcutta',
  }

  ## Setup ntp servers
  if $hostname in $ntp_servers {
    class { '::ntp': servers => $ntp_server_servers, }
  } else {
    class {'::ntp': servers => $ntp_servers, }
  }

  ### Installing base packages required on all servers
  package { $all_nodes_pkgs_to_install:
    ensure => installed,
  }

  ### Remove unwanted packages
  package { $all_nodes_pkgs_to_remove:
    ensure => absent,
  }

  ## Network Setup
  class { 'jiocloud::system::network_config': }


  ## Apt source and mirror setup
  class { 'jiocloud::system::apt': }
}
