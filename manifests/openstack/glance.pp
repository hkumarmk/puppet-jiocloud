## Class: jiocloud::openstack::glance
class jiocloud::openstack::glance (
  $verbose = $jiocloud::params::verbose,
  $debug = $jiocloud::params::debug,
  $use_syslog = $jiocloud::params::glance_use_syslog,
  $syslog_log_facility = $jiocloud::params::glance_syslog_log_facility,
  $verbose = $jiocloud::params::verbose,
  $debug = $jiocloud::params::debug,
  $registry_host = $jiocloud::params::glance_public_address,
  $registry_protocol = $jiocloud::params::glance_protocol,
  $registry_bind_port = $jiocloud::params::glance_registry_listen_port,
  $keystone_port = $jiocloud::params::keystone_port,
  $keystone_host = $jiocloud::params::keystone_internal_address,
  $keystone_protocol = $jiocloud::params::keystone_protocol,
  $keystone_auth_uri = $jiocloud::params::keystone_internal_url,
  $keystone_tenant = $jiocloud::params::service_tenant,
  $keystone_password = $jiocloud::params::service_user_password,
  $sql_connection = $jiocloud::params::glance_db_url,
  $use_syslog = $jiocloud::params::glance_use_syslog,
  $log_facility = $jiocloud::params::glance_syslog_log_facility,
  $api_bind_port = $jiocloud::params::glance_api_listen_port,
  $glance_nodes = $jiocloud::params::glance_nodes,
  $backend = $jiocloud::params::glance_backend,
  $service_listen_address = $jiocloud::params::service_listen_address,
) {
  if downcase($hostname) in downcase($glance_nodes) {

#    add_ceph_auth_glance {'glance': }
    jiocloud::ceph::auth::add_ceph_auth {'glance':
      file_owner => 'glance',
    }

    # Install and configure glance-api
    class { '::glance::api':
      verbose           => $verbose,
      debug             => $debug,
      registry_host     => $registry_host,
      registry_protocol	=> $registry_protocol,
      bind_port		=> $api_bind_port,
      bind_host		=> $service_listen_address,
      auth_type         => 'keystone',
      auth_port         => $keystone_port,
      auth_host         => $keystone_host,
      auth_protocol	=> $keystone_protocol,
      auth_uri	      => $keystone_auth_uri,
      keystone_tenant   => $keystone_tenant,
      keystone_user     => 'glance',
      keystone_password => $keystone_password,
      sql_connection    => $sql_connection,
      use_syslog        => $use_syslog,
      log_facility      => $log_facility,
      enabled           => true,
    }

    # Install and configure glance-registry
    class { '::glance::registry':
      verbose           => $verbose,
      debug             => $debug,
      bind_port		=> $registry_bind_port,
      bind_host         => $service_listen_address,
      auth_host         => $keystone_host,
      auth_uri          => $keystone_auth_uri,
      auth_port         => $keystone_port,
      auth_protocol	=> $keystone_protocol,
      auth_type         => 'keystone',
      keystone_tenant   => $keystone_tenant,
      keystone_user     => 'glance',
      keystone_password => $keystone_password,
      sql_connection    => $sql_connection,
      use_syslog        => $use_syslog,
      log_facility      => $log_facility,
      enabled           => true,
    }

    # Configure file storage backend
    if($backend == 'swift') {
      if ! $swift_store_user {
	fail('swift_store_user must be set when configuring swift as the glance backend')
      }
      if ! $swift_store_key {
	fail('swift_store_key must be set when configuring swift as the glance backend')
      }

      class { '::glance::backend::swift':
	swift_store_user                    => $swift_store_user,
	swift_store_key                     => $swift_store_key,
	swift_store_auth_address            => $swift_store_auth_address,
	swift_store_create_container_on_put => true,
      }
    } elsif($backend == 'file') {
    # Configure file storage backend
      class { '::glance::backend::file': }
    } elsif($backend == 'rbd') {
      class { '::glance::backend::rbd':
	rbd_store_user => $rbd_store_user,
	rbd_store_pool => $rbd_store_pool,
      }
    } else {
      fail("Unsupported backend ${backend}")
    }

  }
}
