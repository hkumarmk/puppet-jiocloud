## Class: jiocloud::system
## Purpose: to group all system level configuration together.
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

class jiocloud::system {
  ## Run stage1 of system configuration
  class {'jiocloud::system::stage1':
    before => Class['jiocloud::system::stage2'],
  }
  ## Run stage2 of system configuration
  class {'jiocloud::system::stage2':
    require => Class['jiocloud::system::stage1'],
  }

}
