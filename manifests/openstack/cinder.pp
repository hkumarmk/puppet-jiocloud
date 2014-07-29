## Class: jiocloud::openstack::cinder
class jiocloud::openstack::cinder (
  $cinder_backup_nodes = $jiocloud::params::cinder_backup_nodes,
  $cinder_volume_nodes = $jiocloud::params::cinder_volume_nodes,
  $cinder_api_nodes = $jiocloud::params::cinder_api_nodes,
  $cinder_scheduler_nodes = $jiocloud::params::cinder_scheduler_nodes,
  $cinder_db_url = $jiocloud::params::cinder_db_url,
  $cinder_rpc_backend = $jiocloud::params::cinder_rpc_backend,
  $nova_zmq_ipc_dir = $jiocloud::params::rpc_zmq_ipc_dir,
  $matchmaker_ringfile = $jiocloud::params::matchmaker_ringfile,
  $verbose = $jiocloud::params::verbose,
  $debug = $jiocloud::params::debug,
  $service_user_password = $jiocloud::params::service_user_password,
  $keystone_internal_address = $jiocloud::params::keystone_internal_address,
  $keystone_port = $jiocloud::params::keystone_port,
  $cinder_listen_port = $jiocloud::params::cinder_listen_port,
  $keystone_protocol = $jiocloud::params::keystone_protocol,
  $keystone_internal_url = $jiocloud::params::keystone_internal_url,
  $glance_protocol = $jiocloud::params::glance_protocol,
  $glance_public_address = $jiocloud::params::glance_public_address,
  $glance_port = $jiocloud::params::glance_port,
  $cinder_volume_rbd_pool = $jiocloud::params::cinder_volume_rbd_pool,
  $cinder_volume_rbd_user = $jiocloud::params::cinder_volume_rbd_user,
  $cinder_rbd_secret_uuid = $jiocloud::params::cinder_rbd_secret_uuid,
  $volume_tmp_dir = $jiocloud::params::volume_tmp_dir,
  $service_listen_address = $jiocloud::params::service_listen_address,
) inherits jiocloud::params {
  if (downcase($hostname) in downcase($cinder_backup_nodes)) or (downcase($hostname) in downcase($cinder_volume_nodes)) {
    package { 'ceph-common': ensure => 'installed', }
    jiocloud::ceph::auth::add_ceph_auth {'cinder_backup':
	file_owner => 'cinder',
    }  
    jiocloud::ceph::auth::add_ceph_auth {'cinder_volume':
	file_owner => 'cinder',
    }
  }
  if (downcase($hostname) in downcase($cinder_api_nodes)) or (downcase($hostname) in downcase($cinder_scheduler_nodes)) or (downcase($hostname) in downcase($cinder_volume_nodes)) {
    class { '::cinder':
      sql_connection     => $cinder_db_url,
      rpc_backend        => $cinder_rpc_backend,
      rpc_zmq_ipc_dir    => $nova_zmq_ipc_dir,
      matchmaker_ringfile => $matchmaker_ringfile,
      verbose             => $verbose,
      debug               => $debug,
    }
  }


  if downcase($hostname) in downcase($cinder_api_nodes) {
    class {'::cinder::api':
      keystone_password       => $service_user_password,
      keystone_auth_host      => $keystone_internal_address,
      service_port            => $keystone_port,
      bind_port               => $cinder_listen_port,
      bind_host		      => $service_listen_address,
      keystone_auth_protocol  => $keystone_protocol,
      keystone_auth_uri       => $keystone_internal_url,
      enabled                 => true,
      glance_host             => "${glance_protocol}://${glance_public_address}",
      glance_port             => $glance_port,
    }
  }

  if downcase($hostname) in downcase($cinder_scheduler_nodes) {
    class { '::cinder::scheduler':
      scheduler_driver => 'cinder.scheduler.simple.SimpleScheduler',
    }
  }

  if downcase($hostname) in downcase($cinder_volume_nodes) {
    class { '::cinder::volume': }
    class { '::cinder::volume::rbd':
      rbd_pool        => $cinder_volume_rbd_pool,
      rbd_user        => $cinder_volume_rbd_user,
      rbd_secret_uuid => $cinder_rbd_secret_uuid,
      volume_tmp_dir  => $volume_tmp_dir,
    }
  }

    # configure apache - glance-api
  apache::vhost { 'cinder-api':
    servername => $cinder_public_address,
    serveradmin => $admin_email,
    port => $cinder_port,
    ssl => $ssl_enabled,
    docroot => $os_apache_docroot,
    error_log_file => 'cinder-api.log',
    access_log_file => 'cinder-api.log',
    proxy_pass => [ { path => '/', url => "http://localhost:${cinder_listen_port}/"  } ],
  }


}
