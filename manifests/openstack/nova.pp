## Class: jiocloud::openstack::nova

class jiocloud::openstack::nova (
  $iam_compute_node = $jiocloud::params::iam_compute_node,
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
  $memcached_server_url	= $jiocloud::params::memcached_server_url,
  $default_floating_pool = $jiocloud::params::default_floating_pool,
  $service_user_password = $jiocloud::params::service_user_password,
  $neutron_internal_url = $jiocloud::params::neutron_internal_url,
  $service_tenant = $jiocloud::params::service_tenant,
  $region = $jiocloud::params::region,
  $keystone_internal_url = $jiocloud::params::keystone_internal_url,
) {
  
  if $iam_compute_node {
    class { 'jiocloud::openstack::nova::compute': }
  } elsif $iam_os_controller_node {
      class { 'jiocloud::openstack::nova::controller':}
  }  
    
}
