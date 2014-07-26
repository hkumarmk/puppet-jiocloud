## Class: jiocloud::system::stage2
## Purpose: to setup stage2 of system configuration - add all items which have dependancy on stage1 here
## Parameters:
## dnsdomainname: dns domain name
## dnssearch: array of dns search domains
## dnsservers: array of dns servers
## dns_master_server: master dns server 
## update_dns: true to create cnames with functional based short names for the servers.
## dnsupdate_key: secure key to update dns server
## local_users : users for whom local accounts is to be created
## sudo_users: users to setup sudo with all commands allowed
## all_nodes_services_to_run: services to assure to be started on all nodes
## ntp_server_servers: list of ntp servers to be configured on local ntp servers
## ntp_servers: list of local ntp servers
##
## ChangeLog:
# 2014-06-18: Hkumar: migrated to jiocloud module 
# 2014-06-25: AlokJani: Adding local_users parameter

class jiocloud::system::stage2 ( 
  $dnsdomainname = $jiocloud::params::dnsdomainname,
  $dnssearch = $jiocloud::params::dnssearch,
  $dnsservers = $jiocloud::params::dnsservers,
  $dns_master_server = $jiocloud::params::dns_master_server,
  $dnsupdate_key = $jiocloud::params::dnsupdate_key,
  $update_dns = $jiocloud::params::update_dns,
  $all_nodes_services_to_run = $jiocloud::params::all_nodes_services_to_run,
  $ntp_server_servers = $jiocloud::params::ntp_server_servers,
  $ntp_servers = $jiocloud::params::ntp_servers,
) inherits jiocloud::params {

  ## Set hostname based on reverse dns lookup
  if $manage_hostname {
    class {'::sethostname':
      domain_name           => $dnsdomainname,
      dns_master_server     => $dns_master_server,
      dnsupdate_key         => $dnsupdate_key,
      update_dns            => $update_dns,
    }
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
  if $jiocloud::params::iam_ntpserver_node == 'true' {
    class { '::ntp': servers => $ntp_server_servers, udlc => true }
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

  ## unmount /mnt for virtualcloud environment
  if downcase($my_environment) == 'virtualcloud' {
    mount { 'unmount_slash_mnt_for_virtualcloud': 
      name => '/mnt',
      ensure => absent,
    }
  }

  ## Setup nscd
  class {'nscd':
    package_name => 'unscd',
    service_name => 'unscd',
  }

  ## set /etc/hosts entry to 127.0.0.1 to hostname 
  host { 'localhost':
    ip => '127.0.0.1',
    host_aliases => ["${hostname}.${dnsdomainname}",$hostname],
  }

  if $hosts_entries {
    create_resources(host,$hosts_entries)
  }

}
