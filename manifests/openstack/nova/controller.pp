## Class: jiocloud::openstack::nova::controller

class jiocloud::openstack::nova::controller (
  $quota_key_pairs = $jiocloud::params::quota_key_pairs,
  $os_controller_nodes_pkgs_to_install = $jiocloud::params::os_controller_nodes_pkgs_to_install,
  $nova_vncproxy_nodes = $jiocloud::params::nova_vncproxy_nodes,
  $nova_api_nodes = $jiocloud::params::nova_api_nodes,
  $nova_scheduler_nodes = $jiocloud::params::nova_scheduler_nodes,
  $nova_consoleauth_nodes = $jiocloud::params::nova_consoleauth_nodes,
  $conductor_nodes = $jiocloud::params::conductor_nodes,
  $nova_cert_nodes = $jiocloud::params::nova_cert_nodes,
  $nova_osapi_compute_listen_port = $jiocloud::params::nova_osapi_compute_listen_port,
  $nova_ec2_listen_port = $jiocloud::params::nova_ec2_listen_port,
  $keystone_protocol = $jiocloud::params::keystone_protocol,
  $keystone_internal_address = $jiocloud::params::keystone_internal_address,
  $nova_workers = $jiocloud::params::nova_workers,
  $nova_port_to_apache = $jiocloud::params::nova_port_to_apache,
  $nova_neutron_metadata_proxy_shared_secret = $jiocloud::params::nova_neutron_metadata_proxy_shared_secret,
  $nova_conductor_workers = $jiocloud::params::nova_conductor_workers,
  $nova_vncproxy_listen_port = $jiocloud::params::nova_vncproxy_listen_port,
  $nova_db_url = $jiocloud::params::nova_db_url,
  $nova_rpc_backend = $jiocloud::params::nova_rpc_backend,
  $nova_glance_api_servers = $jiocloud::params::nova_glance_api_servers,
  $glance_protocol = $jiocloud::params::glance_protocol,
  $rpc_zmq_ipc_dir = $jiocloud::params::rpc_zmq_ipc_dir,
  $matchmaker_ringfile = $jiocloud::params::matchmaker_ringfile,
  $verbose = $jiocloud::params::verbose,
  $debug = $jiocloud::params::debug,
  $nova_use_syslog = $jiocloud::params::nova_use_syslog,
  $nova_syslog_log_facility = $jiocloud::params::nova_syslog_log_facility,
  $memcached_server_url = $jiocloud::params::memcached_server_url,
  $default_floating_pool = $jiocloud::params::default_floating_pool,
  $service_user_password = $jiocloud::params::service_user_password,
  $neutron_internal_url = $jiocloud::params::neutron_internal_url,
  $neutron_url_timeout = $jiocloud::params::neutron_url_timeout,
  $service_tenant = $jiocloud::params::service_tenant,
  $region = $jiocloud::params::region,
  $keystone_internal_url = $jiocloud::params::keystone_internal_url,
  $service_listen_address = $jiocloud::params::service_listen_address,

) inherits jiocloud::params {
  
  if downcase($hostname) in downcase($nova_vncproxy_nodes) { $nova_vncproxy_enabled = true }
  else { $nova_vncproxy_enabled	= false }

  if downcase($hostname) in downcase($nova_api_nodes) { $nova_api_enabled = true }
  else { $nova_api_enabled = false }

  if downcase($hostname) in downcase($nova_scheduler_nodes) { $nova_scheduler_enabled = true }
  else { $nova_scheduler_enabled = false }

  if downcase($hostname) in downcase($nova_consoleauth_nodes) { $nova_consoleauth_enabled = true }
  else { $nova_consoleauth_enabled = false }

  if downcase($hostname) in downcase($conductor_nodes) { $nova_conductor_enabled = true } 
  else { $nova_conductor_enabled = false }

  if downcase($hostname) in downcase($nova_cert_nodes) { $nova_cert_enabled	= true }
  else { $nova_cert_enabled	= false }

  package {'python-six': ensure => 'latest', }
  
  package { $os_controller_nodes_pkgs_to_install:
    ensure => installed,
  }
  
  class { '::nova::client': }
  class { '::nova::scheduler': enabled	=> true, }	
  
  class { '::nova':
    database_connection	=> $nova_db_url,
    rpc_backend		=> $nova_rpc_backend,
    glance_api_servers	=> $nova_glance_api_servers,
    glance_protocol	=> $glance_protocol,
    rpc_zmq_ipc_dir	=> $rpc_zmq_ipc_dir,	
    matchmaker_ringfile	=> $matchmaker_ringfile,
    verbose             => $verbose,
    debug               => $debug,	
    use_syslog		=> $nova_use_syslog,
    log_facility	=> $nova_syslog_log_facility,
    memcached_servers	=> $memcached_server_url,
    default_floating_pool	=> $default_floating_pool,
  }
      
  class {'::nova::quota': 
    quota_instances		=> $quota_instances,
    quota_cores		=> $quota_cores,
    quota_ram		=> $quota_ram,
    quota_volumes		=> $quota_volumes,
    quota_gigabytes		=> $quota_gigabytes,
    quota_floating_ips	=> $quota_floating_ips,
    quota_max_injected_files	=> $quota_max_injected_files,
    quota_security_groups	=> $quota_security_groups,
    quota_security_group_rules	=> $quota_security_group_rules,
    quota_key_pairs		=> $quota_key_pairs,
  }
  
  class { '::nova::network::neutron':
    neutron_admin_password	=> $service_user_password,
    neutron_url			=> $neutron_internal_url,
    neutron_admin_tenant_name	=> $service_tenant,
    neutron_region_name		=> $region,
    neutron_admin_auth_url	=> $keystone_internal_url,
    neutron_url_timeout		=> $neutron_url_timeout,
  }
  

  class { 'nova::api':
    admin_password		=> $service_user_password,
    enabled			=> $nova_api_enabled,
    auth_host			=> $keystone_internal_address,
    osapi_compute_listen_port	=> $nova_osapi_compute_listen_port,
    api_bind_address		=> $service_listen_address,
    ec2_listen_port		=> $nova_ec2_listen_port,
    auth_protocol		=> $keystone_protocol,
    auth_strategy		=> 'keystone',
    auth_uri			=> $keystone_internal_url,
    workers			=> $nova_workers,
    port_to_apache		=> $nova_port_to_apache,
    neutron_metadata_proxy_shared_secret	=> $nova_neutron_metadata_proxy_shared_secret,
    keystone_ec2_url => "${keystone_internal_url}/ec2tokens",
  }

  class { 'nova::conductor':
    enabled => $nova_conductor_enabled,
    workers => $nova_conductor_workers,
  }

  class { 'nova::cert':
    enabled => $nova_cert_enabled,
  }	

  class { 'nova::consoleauth':
    enabled => $nova_consoleauth_enabled,
  }	

  class { 'nova::vncproxy':
    host => $service_listen_address,
    port => $nova_vncproxy_listen_port,
    enabled => $nova_vncproxy_enabled,
  }	

  ## Configure apache reverse proxy
  apache::vhost { 'nova-api':
      servername => $nova_public_address,
      serveradmin => $admin_email,
      port => $nova_port,
      ssl => $ssl_enabled,
      docroot => $os_apache_docroot,
      error_log_file => 'nova-api.log',
      access_log_file => 'nova-api.log',
      proxy_pass => [ { path => '/', url => "http://localhost:${nova_osapi_compute_listen_port}/"  } ],
    }

  ## Configure apache reverse proxy
  apache::vhost { 'nova-ec2':
      servername => $nova_public_address,
      serveradmin => $admin_email,
      port => $nova_ec2_port,
      ssl => $ssl_enabled,
      docroot => $os_apache_docroot,
      error_log_file => 'nova-ec2.log',
      access_log_file => 'nova-ec2.log',
      proxy_pass => [ { path => '/', url => "http://localhost:${nova_ec2_listen_port}/"  } ],
    }

  ## Configure apache reverse proxy
  apache::vhost { 'nova-vncproxy':
      servername => $nova_public_address,
      serveradmin => $admin_email,
      port => $nova_vncproxy_port,
      ssl => $ssl_enabled,
      docroot => $os_apache_docroot,
      error_log_file => 'nova-vncproxy.log',
      access_log_file => 'nova-vncproxy.log',
      proxy_pass => [ { path => '/', url => "http://localhost:${nova_vncproxy_listen_port}/"  } ],
    }

}  
