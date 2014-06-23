### class: jiocloud::openstack
class jiocloud::openstack (
  $os_controller_nodes = $jiocloud::params::os_controller_nodes,
  $nova_api_nodes = $jiocloud::params::nova_api_nodes,
  $conductor_nodes = $jiocloud::params::conductor_nodes,
  $nova_cert_nodes = $jiocloud::params::nova_cert_nodes,
  $nova_consoleauth_nodes = $jiocloud::params::nova_consoleauth_nodes,
  $nova_scheduler_nodes = $jiocloud::params::nova_scheduler_nodes,
  $compute_nodes = $jiocloud::params::compute_nodes,
  $nova_vncproxy_nodes = $jiocloud::params::nova_vncproxy_nodes,
  $cinder_api_nodes = $jiocloud::params::cinder_api_nodes,
  $cinder_scheduler_nodes = $jiocloud::params::cinder_scheduler_nodes,
  $cinder_volume_nodes = $jiocloud::params::cinder_volume_nodes,
  $cinder_backup_nodes = $jiocloud::params::cinder_backup_nodes,
  $glance_nodes = $jiocloud::params::glance_nodes,
  $memcached_nodes = $jiocloud::params::memcached_nodes,
  $os_mgmt_nodes = $jiocloud::params::os_mgmt_nodes,
  $admin_email = $jiocloud::params::admin_email,
  $admin_password = $jiocloud::params::admin_password,
  $admin_token = $jiocloud::params::admin_token,
  $ceph_mon_key = $jiocloud::params::ceph_mon_key,
  $ceph_radosgw_admin_address = $jiocloud::params::ceph_radosgw_admin_address,
  $ceph_radosgw_internal_address = $jiocloud::params::ceph_radosgw_internal_address,
  $ceph_radosgw_internal_port = $jiocloud::params::ceph_radosgw_internal_port,
  $ceph_radosgw_protocol = $jiocloud::params::ceph_radosgw_protocol,
  $ceph_radosgw_public_address = $jiocloud::params::ceph_radosgw_public_address,
  $ceph_radosgw_public_port = $jiocloud::params::ceph_radosgw_public_port,
  $cinder_admin_address = $jiocloud::params::cinder_admin_address,
  $cinder_internal_address = $jiocloud::params::cinder_internal_address,
  $cinder_listen_port = $jiocloud::params::cinder_listen_port,
  $cinder_protocol = $jiocloud::params::cinder_protocol,
  $cinder_public_address = $jiocloud::params::cinder_public_address,
  $cinder_public_port = $jiocloud::params::cinder_public_port,
  $cinder_rbd_secret_uuid = $jiocloud::params::cinder_rbd_secret_uuid,
  $cinder_rpc_backend = $jiocloud::params::cinder_rpc_backend,
  $cinder_volume_rbd_pool = $jiocloud::params::cinder_volume_rbd_pool,
  $cinder_volume_rbd_user = $jiocloud::params::cinder_volume_rbd_user,
  $controller_nodes_pkgs_to_install = $jiocloud::params::controller_nodes_pkgs_to_install,
  $db_host_ip = $jiocloud::params::db_host_ip,
  $debug = $jiocloud::params::debug,
  $default_floating_pool = $jiocloud::params::default_floating_pool,
  $glance_admin_address = $jiocloud::params::glance_admin_address,
  $glance_api_listen_port = $jiocloud::params::glance_api_listen_port,
  $glance_backend = $jiocloud::params::glance_backend,
  $glance_db_password = $jiocloud::params::glance_db_password,
  $glance_internal_address = $jiocloud::params::glance_internal_address,
  $glance_port = $jiocloud::params::glance_port,
  $glance_public_address = $jiocloud::params::glance_public_address,
  $glance_public_port = $jiocloud::params::glance_public_port,
  $glance_public_protocol = $jiocloud::params::glance_public_protocol,
  $glance_rbd_store_pool = $jiocloud::params::glance_rbd_store_pool,
  $glance_rbd_store_user = $jiocloud::params::glance_rbd_store_user,
  $glance_registry_listen_port = $jiocloud::params::glance_registry_listen_port,
  $horizon_api_result_limit = $jiocloud::params::horizon_api_result_limit,
  $horizon_package_ensure = $jiocloud::params::horizon_package_ensure,
  $horizon_public_address = $jiocloud::params::horizon_public_address,
  $horizon_secret_key = $jiocloud::params::horizon_secret_key,
  $horizon_ssl_cacert = $jiocloud::params::horizon_ssl_cacert,
  $horizon_ssl_cert = $jiocloud::params::horizon_ssl_cert,
  $horizon_ssl_enabled = $jiocloud::params::horizon_ssl_enabled,
  $horizon_ssl_key = $jiocloud::params::horizon_ssl_key,
  $host_prefix = $jiocloud::params::host_prefix,
  $jiocloud_registration_package_ensure = $jiocloud::params::jiocloud_registration_package_ensure,
  $keystone_accepted_roles = $jiocloud::params::keystone_accepted_roles,
  $keystone_admin_address = $jiocloud::params::keystone_admin_address,
  $keystone_admin_listen_port = $jiocloud::params::keystone_admin_listen_port,
  $keystone_admin_port = $jiocloud::params::keystone_admin_port,
  $keystone_cache_backend = $jiocloud::params::keystone_cache_backend,
  $keystone_cache_backend_argument = $jiocloud::params::keystone_cache_backend_argument,
  $keystone_cache_config_prefix = $jiocloud::params::keystone_cache_config_prefix,
  $keystone_cache_enabled = $jiocloud::params::keystone_cache_enabled,
  $keystone_cache_expiration_time = $jiocloud::params::keystone_cache_expiration_time,
  $keystone_db_password = $jiocloud::params::keystone_db_password,
  $keystone_internal_address = $jiocloud::params::keystone_internal_address,
  $keystone_port = $jiocloud::params::keystone_port,
  $keystone_protocol = $jiocloud::params::keystone_protocol,
  $keystone_public_address = $jiocloud::params::keystone_public_address,
  $keystone_public_listen_port = $jiocloud::params::keystone_public_listen_port,
  $keystone_public_port = $jiocloud::params::keystone_public_port,
  $keystone_token_format = $jiocloud::params::keystone_token_format,
  $keystone_version = $jiocloud::params::keystone_version,
  $matchmaker_ringfile = $jiocloud::params::matchmaker_ringfile,
  $memcached_listen = $jiocloud::params::memcached_listen,
  $memcached_max_memory = $jiocloud::params::memcached_max_memory,
  $memcached_port = $jiocloud::params::memcached_port,
  $/*memcached_server*/_url = $jiocloud::params::memcached_server_url,
  $mgmt_vm_virsh_secret_uuid = $jiocloud::params::mgmt_vm_virsh_secret_uuid,
  $network_device_mtu = $jiocloud::params::network_device_mtu,
  $neutron_admin_address = $jiocloud::params::neutron_admin_address,
  $neutron_enabled = $jiocloud::params::neutron_enabled,
  $neutron_internal_address = $jiocloud::params::neutron_internal_address,
  $neutron_libvirt_vif_driver = $jiocloud::params::neutron_libvirt_vif_driver,
  $neutron_protocol = $jiocloud::params::neutron_protocol,
  $neutron_public_address = $jiocloud::params::neutron_public_address,
  $neutron_public_port = $jiocloud::params::neutron_public_port,
  $neutron_url_timeout = $jiocloud::params::neutron_url_timeout,
  $nova_admin_address = $jiocloud::params::nova_admin_address,
  $nova_api_enabled = $jiocloud::params::nova_api_enabled,
  $nova_conductor_use_local = $jiocloud::params::nova_conductor_use_local,
  $nova_conductor_workers = $jiocloud::params::nova_conductor_workers,
  $nova_ec2_listen_port = $jiocloud::params::nova_ec2_listen_port,
  $nova_glance_api_servers = $jiocloud::params::nova_glance_api_servers,
  $nova_internal_address = $jiocloud::params::nova_internal_address,
  $nova_libvirt_images_type = $jiocloud::params::nova_libvirt_images_type,
  $nova_logical_volume = $jiocloud::params::nova_logical_volume,
  $nova_neutron_metadata_proxy_shared_secret = $jiocloud::params::nova_neutron_metadata_proxy_shared_secret,
  $nova_osapi_compute_listen_port = $jiocloud::params::nova_osapi_compute_listen_port,
  $nova_physical_volumes = $jiocloud::params::nova_physical_volumes,
  $nova_port_to_apache = $jiocloud::params::nova_port_to_apache,
  $nova_protocol = $jiocloud::params::nova_protocol,
  $nova_public_address = $jiocloud::params::nova_public_address,
  $nova_public_port = $jiocloud::params::nova_public_port,
  $nova_rpc_backend = $jiocloud::params::nova_rpc_backend,
  $nova_snapshot_image_format = $jiocloud::params::nova_snapshot_image_format,
  $nova_syslog_log_facility = $jiocloud::params::nova_syslog_log_facility,
  $nova_use_syslog = $jiocloud::params::nova_use_syslog,
  $nova_vncproxy_listen_port = $jiocloud::params::nova_vncproxy_listen_port,
  $nova_volume_group = $jiocloud::params::nova_volume_group,
  $nova_workers = $jiocloud::params::nova_workers,
  $nova_zmq_ipc_dir = $jiocloud::params::nova_zmq_ipc_dir,
  $quota_cores = $jiocloud::params::quota_cores,
  $quota_floating_ips = $jiocloud::params::quota_floating_ips,
  $quota_gigabytes = $jiocloud::params::quota_gigabytes,
  $quota_instances = $jiocloud::params::quota_instances,
  $quota_key_pairs = $jiocloud::params::quota_key_pairs,
  $quota_max_injected_files = $jiocloud::params::quota_max_injected_files,
  $quota_ram = $jiocloud::params::quota_ram,
  $quota_security_group_rules = $jiocloud::params::quota_security_group_rules,
  $quota_security_groups = $jiocloud::params::quota_security_groups,
  $quota_volumes = $jiocloud::params::quota_volumes,
  $region = $jiocloud::params::region,
  $rpc_zmq_ipc_dir = $jiocloud::params::rpc_zmq_ipc_dir,
  $service_tenant = $jiocloud::params::service_tenant,
  $service_user_password = $jiocloud::params::service_user_password,
  $ssl_ca_file = $jiocloud::params::ssl_ca_file,
  $ssl_ca_file_source = $jiocloud::params::ssl_ca_file_source,
  $ssl_cert_file = $jiocloud::params::ssl_cert_file,
  $ssl_cert_file_source = $jiocloud::params::ssl_cert_file_source,
  $ssl_enabled = $jiocloud::params::ssl_enabled,
  $ssl_key_file = $jiocloud::params::ssl_key_file,
  $ssl_key_file_source = $jiocloud::params::ssl_key_file_source,
  $verbose = $jiocloud::params::verbose,
  $virtio_nic = $jiocloud::params::virtio_nic,
  $vncproxy_host = $jiocloud::params::vncproxy_host,
  $vncproxy_protocol = $jiocloud::params::vncproxy_protocol,
  $vncserver_proxyclient_address = $jiocloud::params::vncserver_proxyclient_address,
  $volume_tmp_dir = $jiocloud::params::volume_tmp_dir,

) inherits jiocloud::params { 
  $controller_nodes_lc	= downcase($os_controller_nodes)
  $hostname_lc    	= downcase($hostname)
  $nova_api_nodes_lc	= downcase($nova_api_nodes)
  $conductor_nodes_lc	= downcase($conductor_nodes)
  $nova_cert_nodes_lc 	= downcase($nova_cert_nodes)
  $nova_consoleauth_nodes_lc 	= downcase($nova_consoleauth_nodes)
  $nova_scheduler_nodes_lc 	= downcase($nova_scheduler_nodes)
  $nova_compute_nodes_lc 	= downcase($compute_nodes)
  $nova_vncproxy_nodes_lc	= downcase($nova_vncproxy_nodes)
  $cinder_api_nodes_lc 		= downcase($cinder_api_nodes)
  $cinder_scheduler_nodes_lc 	= downcase($cinder_scheduler_nodes)
  $cinder_volume_nodes_lc 	= downcase($cinder_volume_nodes)
  $cinder_backup_nodes_lc 	= downcase($cinder_backup_nodes)
  $glance_nodes_lc 	= downcase($glance_nodes)
  $memcached_nodes_lc	= downcase($memcached_nodes)
  $os_mgmt_nodes_lc	= downcase($os_mgmt_nodes)	
#  $all_openstack_hostgroups	= ['Openstack Controller','Openstack Compute Node']
  $all_openstack_hostgroups	= ['os_controller_node','os_compute_node']

#############
#vncserver_proxyclient_address
## tobe comply with env.pp 
## ensure users and groups
  
#  ensure_resource('user',['nova','cinder','glance'],
####FIXME: CURRENTLY ADDING GLANCE, CINDER, NOVA IN OPENSTACK GROUP IS NOT DONE

#  $vncserver_proxyclient_address = inline_template("<%= @ipaddress_eth3 || @ipaddress_br0 %>")




  if ($hostname_lc in $cinder_backup_nodes_lc) or ($hostname_lc in $cinder_volume_nodes_lc) {
	package { 'ceph-common': ensure	=> 'installed', }
	add_ceph_auth_cinder_backup {'cinder_backup':}
	add_ceph_auth_cinder_volume {'cinder_volume':}
  }




### Setup memcache on memcache nodes
  if $hostname_lc in $memcached_nodes_lc {
    class { 'memcached':
  	listen_ip 	=> $memcached_listen,
  	tcp_port  	=> $memcached_port,
  	udp_port  	=> $memcached_port,
	max_memory 	=> $memcached_max_memory,
    }
  }


  if ($hostname_lc in $cinder_api_nodes_lc) or ($hostname_lc in $cinder_scheduler_nodes_lc) or ($hostname_lc in $cinder_volume_nodes_lc) {
    class { 'cinder':
	sql_connection     => "mysql://${cinder_db_user}:${cinder_db_password}@${db_host_ip}/${cinder_db_name}?charset=utf8",
	rpc_backend             => $cinder_rpc_backend,
	rpc_zmq_ipc_dir         => $nova_zmq_ipc_dir,
        matchmaker_ringfile     => $matchmaker_ringfile,
        verbose                 => $verbose,
        debug                   => $debug,
    }		
  }

  if $hostname_lc in $cinder_api_nodes_lc {
    class {'cinder::api':
	keystone_password       => $service_user_password,
	keystone_auth_host      => $keystone_internal_address,
	service_port		=> $keystone_port,
        bind_port		=> $cinder_listen_port,
	keystone_auth_protocol	=> $keystone_protocol,
	keystone_auth_uri	=> "${::os_env::keystone_protocol}://${::os_env::keystone_internal_address}:${::os_env::keystone_port}/${::os_env::keystone_version}",
	enabled			=> $true,
    	glance_host		=> "${::os_env::glance_protocol}://${::os_env::glance_public_address}",
        glance_port		=> $::os_env::glance_port,
    }
  }

  if $hostname_lc in $cinder_scheduler_nodes_lc {
    class { 'cinder::scheduler':
  	scheduler_driver => 'cinder.scheduler.simple.SimpleScheduler',
    }
  }

  if $hostname_lc in $cinder_volume_nodes_lc {

    class { 'cinder::volume': }

    class { 'cinder::volume::rbd': 
	rbd_pool	=> $::os_env::cinder_volume_rbd_pool,
	rbd_user	=> $::os_env::cinder_volume_rbd_user,
	rbd_secret_uuid	=> $::os_env::cinder_rbd_secret_uuid,
	volume_tmp_dir  => $::os_env::volume_tmp_dir,
    }

  }

## Setup nova client, nova scheduler (dependancy of zeromq receiver), nova zeromq receiver on all openstack systems.


  if $hostname_lc in $controller_nodes_lc {

   

#FIXME: WORKAROUND TO ENABLE SSL

  if $::global_env::ssl_enabled  {
        $apache_config_ensure = file
  } else {
        $apache_config_ensure = absent
  }




    include ::apache
    include ::apache::mod::wsgi
    include apache::mod::rewrite
    include apache::mod::ssl
    include apache::mod::proxy
    include apache::mod::proxy_http
## this is required to proxy novncproxy
    ::apache::mod { 'proxy_wstunnel': }	

  file { '/etc/apache2/conf.d/glance.conf':
    ensure  => $apache_config_ensure,
    owner   => www-data,
    group   => www-data,
    source => "${puppet_master_files}/apache2/glance.conf",
    mode    => '0644',
    notify  => Service['httpd'],
  }



  file { '/etc/apache2/conf.d/glance-registry.conf':
    ensure  => $apache_config_ensure,
    owner   => www-data,
    group   => www-data,
    source => "${puppet_master_files}/apache2/glance-registry.conf",
    mode    => '0644',
    notify  => Service['httpd'],
  }

  file { '/etc/apache2/conf.d/horizon.conf':
    ensure  => file,
    owner   => www-data,
    group   => www-data,
    content => template("${puppet_master_files}/apache2/horizon.conf.erb"),
    mode    => '0644',
    notify  => Service['httpd'],
  }
 
  file { '/etc/apache2/conf.d/jiocloud-registration-service.conf':
    ensure  => file,
    owner   => www-data,
    group   => www-data,
    content => template("${puppet_master_files}/apache2/jiocloud-registration-service.conf"),
    mode    => '0644',
    notify  => Service['httpd'],
  }

   
  file { '/etc/apache2/certs':
	ensure	=> directory,
	owner   => www-data,
    	group   => www-data,
  }

  if  $ssl_cert_file_source != undef {
    file { $ssl_cert_file:
        ensure        => file,
        owner         => www-data,
        group         => www-data,
        mode          => 640,
        source        => $ssl_cert_file_source,
	notify  => Service['httpd'],
    }
  }


  if  $ssl_key_file_source != undef {
    file { $ssl_key_file:
        ensure        => file,
        owner         => www-data,
        group         => www-data,
        mode          => 640,
        source        => $ssl_key_file_source,
	notify  => Service['httpd'],
    }
  }

  if  $ssl_ca_file_source != undef {
    file { $ssl_ca_file:
        ensure          => file,
        owner           => www-data,
        group           => www-data,
        mode            => 640,
        source          => $ssl_ca_file_source,
	notify  => Service['httpd'],
    }
  }

  file {'/var/log/horizon':
     ensure 	=> directory,
     owner 	=> horizon,
     group	=> horizon,
     mode	=> '0755',
     notify  => Service['httpd'],
  }

  if ($nova_port_to_apache) {
    file { '/etc/apache2/conf.d/compute.conf':
    	ensure  => $apache_config_ensure,
    	owner   => www-data,
    	group   => www-data,
    	source => "${puppet_master_files}/apache2/compute.conf.wsgi",
    	mode    => '0644',
    	notify  => Service['httpd'],
    }
  } else {
    file { '/etc/apache2/conf.d/compute.conf':
        ensure  => $apache_config_ensure,
        owner   => www-data,
        group   => www-data,
        source => "${puppet_master_files}/apache2/compute.conf.proxy",
        mode    => '0644',
        notify  => Service['httpd'],
    }
  }

  file { '/etc/apache2/conf.d/ec2.conf':
    ensure  => $apache_config_ensure,
    owner   => www-data,
    group   => www-data,
    source => "${puppet_master_files}/apache2/ec2.conf",
    mode    => '0644',
    notify  => Service['httpd'],
  }

  file { '/etc/apache2/conf.d/cinder.conf':
    ensure  => $apache_config_ensure,
    owner   => www-data,
    group   => www-data,
    source => "${puppet_master_files}/apache2/cinder.conf",
    mode    => '0644',
    notify  => Service['httpd'],
  }
  
  file { '/etc/apache2/conf.d/keystone.conf':
    ensure  => $apache_config_ensure,
    owner   => www-data,
    group   => www-data,
    source => "${puppet_master_files}/apache2/keystone.conf",
    mode    => '0644',
    notify  => Service['httpd'],
  }

################################################
  class { 'openstack::keystone':
   	db_host               	=> $db_host_ip,
   	db_password           	=> $keystone_db_password,
   	admin_token           	=> $admin_token,
   	admin_email           	=> $admin_email,
   	admin_password        	=> $admin_password,
        ## cache configuration
	keystone_cache_enabled	=> $keystone_cache_enabled,
	keystone_cache_config_prefix	=> $keystone_cache_config_prefix,
	keystone_cache_expiration_time	=> $keystone_cache_expiration_time,
	keystone_cache_backend	=> $keystone_cache_backend,
 	keystone_cache_backend_argument	=> $keystone_cache_backend_argument,
	###End: Cache configuration
	keystone_public_port		=> $keystone_public_listen_port,
	keystone_admin_port		=> $keystone_admin_listen_port,
	token_format		=> $keystone_token_format,
   	region		 	=> $region,
   	glance_user_password  	=> $service_user_password,
   	nova_user_password    	=> $service_user_password,
   	cinder_user_password  	=> $service_user_password,
   	neutron_user_password 	=> $service_user_password,
	neutron			=> $neutron_enabled,
   	public_address        	=> $keystone_public_address,
	internal_address	=> $keystone_internal_address,
	admin_address		=> $keystone_admin_address,
	keystone_public_url	=> "${::os_env::keystone_protocol}://${::os_env::keystone_public_address}:${::os_env::keystone_public_port}/${::os_env::keystone_version}",
	keystone_admin_url	=> "${::os_env::keystone_protocol}://${::os_env::keystone_admin_address}:${::os_env::keystone_admin_port}/${::os_env::keystone_version}",
	keystone_internal_url	=> "${::os_env::keystone_protocol}://${::os_env::keystone_internal_address}:${::os_env::keystone_port}/${::os_env::keystone_version}",

	neutron_public_address	=> $neutron_public_address,
	neutron_internal_address        => $neutron_internal_address,
        neutron_admin_address           => $neutron_admin_address,
	neutron_public_port	=> $neutron_public_port,
	neutron_public_protocol	=> $os_env::neutron_protocol,
	neutron_internal_protocol => $os_env::neutron_protocol,

        cinder_public_address  => $cinder_public_address,
        cinder_internal_address        => $cinder_internal_address,
        cinder_admin_address           => $cinder_admin_address,
	cinder_public_port	=> $cinder_public_port,
	cinder_public_protocol	=> $cinder_protocol,

        nova_public_address  => $nova_public_address,
        nova_internal_address        => $nova_internal_address,
        nova_admin_address           => $nova_admin_address,
	nova_public_port	 => $nova_public_port,
	nova_public_protocol	=> $nova_protocol,

        glance_public_address  => $glance_public_address,
        glance_internal_address => $glance_internal_address,
        glance_admin_address    => $glance_admin_address,
	glance_public_port	=> $glance_public_port,
	glance_public_protocol	=> $glance_public_protocol,
	glance_internal_protocol => $glance_public_protocol,

   	verbose		 	=> $verbose,
   	debug		 	=> $debug,
  }
   ->
  class { 'openstack::glance':
	db_host                 => $db_host_ip,
        db_password             => $glance_db_password,
	user_password		=> $service_user_password,
	keystone_host		=> $keystone_internal_address,
        keystone_protocol	=> $keystone_protocol,
	verbose                 => $verbose,
        debug                   => $debug,
        keystone_auth_uri	=> "${::os_env::keystone_protocol}://${::os_env::keystone_internal_address}:${::os_env::keystone_port}/${::os_env::keystone_version}",
	backend			=> $glance_backend,
	rbd_store_user		=> $glance_rbd_store_user,
	rbd_store_pool		=> $glance_rbd_store_pool,
	registry_bind_port	=> $glance_registry_listen_port,
	api_bind_port		=> $glance_api_listen_port,
	registry_host		=> $glance_public_address,
	registry_protocol	=> $glance_public_protocol,
  }

  if $ceph_env::ceph_radosgw_enabled { 
    class { 'keystone::radosgw':
        keystone_accepted_roles => $os_env::keystone_accepted_roles,
        region                  => $os_env::region,
        public_address          => $ceph_env::ceph_radosgw_public_address,
        public_port             => $ceph_env::ceph_radosgw_public_port,
        admin_address           => $ceph_env::ceph_radosgw_admin_address,
  #      admin_port              => $ceph_env::radosgw_admin_port,
        internal_address        => $ceph_env::ceph_radosgw_internal_address,
        port           		=> $ceph_env::ceph_radosgw_internal_port,
	public_protocol		=> $ceph_env::ceph_radosgw_protocol,
    }
  }
 
  class { '::horizon':
#    cache_server_ip     => $horizon_cache_server_ip,
#    cache_server_port   => $horizon_cache_server_port,
    fqdn		=> $horizon_public_address,
    secret_key          => $horizon_secret_key,
    django_debug        => $debug,
    api_result_limit    => $horizon_api_result_limit,
    keystone_url	=> "${::os_env::keystone_protocol}://${::os_env::keystone_internal_address}:${::os_env::keystone_port}/${::os_env::keystone_version}",
    listen_ssl		=> $horizon_ssl_enabled,
    horizon_key		=> $horizon_ssl_key,
    horizon_cert	=> $horizon_ssl_cert,
    horizon_ca		=> $horizon_ssl_cacert,
    regservice_url      => "https://${horizon_public_address}/horizonreg",
    package_ensure    	=> $horizon_package_ensure

  }

 class { '::jiocloud_registration':
    fqdn                => $horizon_public_address,
    keystone_add        => $keystone_public_address,
    listen_ssl          => $horizon_ssl_enabled,
    horizon_key         => $horizon_ssl_key,
    horizon_cert        => $horizon_ssl_cert,
    horizon_ca          => $horizon_ssl_cacert,
    keystone_public_port => $keystone_port,
    keystone_admin_token => $admin_token,
    package_ensure      => $jiocloud_registration_package_ensure,
  }



  
  
    class { 'openstack::auth_file':
        admin_password  => $admin_password,
        controller_node => $::os_env::keystone_public_address,
        region_name     => $region,
        keystone_protocol => $::os_env::keystone_protocol,
        keystone_port   => $::os_env::keystone_public_port,
        keystone_admin_port     => $::os_env::keystone_admin_port,
        keystone_version        => $::os_env::keystone_version,
        admin_tenant    => 'admin',
    }
  } 
} 


#########################################3

  if $hostname_lc in $nova_vncproxy_nodes_lc {
	$nova_vncproxy_enabled	= true
  } else {
	$nova_vncproxy_enabled	= false
  }
 
  if $hostname_lc in $nova_api_nodes_lc {
	$nova_api_enabled	= true
  } else {
	$nova_api_enabled	= false
  }


  if $hostname_lc in $nova_scheduler_nodes_lc {
	$nova_scheduler_enabled	= true
  } else {
	$nova_scheduler_enabled	= false
  }

  if $hostname_lc in $nova_consoleauth_nodes_lc {
	$nova_consoleauth_enabled	= true
  } else {
	$nova_consoleauth_enabled	= false
  }

  if $hostname_lc in $conductor_nodes_lc {
	$nova_conductor_enabled	= true
  } else {
	$nova_conductor_enabled	= false
  }

  if $hostname_lc in $nova_cert_nodes_lc {
	$nova_cert_enabled	= true
  } else {
	$nova_cert_enabled	= false
  }

  
## Added to nova/compute.pp

## Setup nova compute on all compute nodes
if is_array($compute_nodes) and $hostname in $compute_nodes  or $compute_nodes and $compute_nodes == $host_prefix { 

    class { 'nova::compute': 
	enabled			=> true,
	vncserver_proxyclient_address	=> $vncserver_proxyclient_address,
	vncproxy_host		=> $vncproxy_host,
	vncproxy_protocol	=> $vncproxy_protocol,
	virtio_nic		=> $virtio_nic,
	neutron_enabled		=> $neutron_enabled,
	network_device_mtu	=> $::system_env::network_device_mtu,
	use_local		=> $nova_conductor_use_local,
    }
### Enabling vm migration support
    class { 'nova::compute::libvirt':
  	migration_support => true,
	vncserver_listen => '0.0.0.0',
	libvirt_images_type => $::os_env::nova_libvirt_images_type,
	snapshot_image_format => $::os_env::nova_snapshot_image_format,
#	libvirt_images_volume_group => $::os_env::nova_volume_group,
    }

    class { 'nova::compute::neutron':
	libvirt_vif_driver	=> $::os_env::neutron_libvirt_vif_driver
    }
    
      
## Creation of volume group.
    class { '::lvm':
      vg => $nova_volume_group,
      pv => $nova_physical_volumes,
      ensure => present
      }

     exec { "lv_$nova_logical_volume": 
	command => "lvcreate -n $nova_logical_volume -l 100%VG $nova_volume_group",
	unless  => "lvs --noheading /dev/${nova_volume_group}/${nova_logical_volume}",
	require => Class['lvm'],
     }

     ensure_resource('package','xfsprogs',{'ensure' => 'present'})

      exec { "mkfs_/dev/${nova_volume_group}/${nova_logical_volume}":
        command => "mkfs.xfs -f -d agcount=${::processorcount} -l \
size=1024m -n size=64k /dev/${nova_volume_group}/${nova_logical_volume}",
        unless  => "xfs_admin -l /dev/${nova_volume_group}/${nova_logical_volume}",
        require => [Package['xfsprogs'],Exec["lv_$nova_logical_volume"]],
      }

      file_line { "fstab_/dev/${nova_volume_group}/${nova_logical_volume}":
        line => "/dev/${nova_volume_group}/${nova_logical_volume} /var/lib/nova/instances xfs rw,noatime,inode64 0 2",
        path => "/etc/fstab",
        require => Exec["mkfs_/dev/${nova_volume_group}/${nova_logical_volume}"],
      }

      exec { "mount_/dev/${nova_volume_group}/${nova_logical_volume}":
        command => "mount /dev/${nova_volume_group}/${nova_logical_volume}",
        unless  => "df /var/lib/nova/instances | grep /dev/mapper/${nova_volume_group}-${nova_logical_volume}",
        require => File_line["fstab_/dev/${nova_volume_group}/${nova_logical_volume}"],
     }

    file { '/var/lib/nova/instances':
       ensure  => directory,
       owner   => 'nova',
       group   => 'nova',
       mode    => '0755',
       require => Exec["mount_/dev/${nova_volume_group}/${nova_logical_volume}"],
    } 
   
    exec { "secret_define_cinder_volume":
        command => "echo \"<secret ephemeral='no' private='no'><uuid>$cinder_rbd_secret_uuid</uuid><usage type='ceph'><name>client.cinder_volume</name></usage></secret>\" > /tmp/secret.xml_$mgmt_vm_virsh_secret_uuid && virsh secret-define --file /tmp/secret.xml_$mgmt_vm_virsh_secret_uuid && rm -f /tmp/secret.xml_$mgmt_vm_virsh_secret_uuid",
        unless => "virsh secret-list | egrep $cinder_rbd_secret_uuid",
    }

    exec { "secret_set_value_cinder_volume":
        command => "ceph-authtool /tmp/.exec_add_ceph_auth_admin.tmp \
--create-keyring \
--name=mon. \
--add-key='${::ceph_env::ceph_mon_key}' \
--cap mon 'allow *' && virsh secret-set-value --secret $cinder_rbd_secret_uuid --base64 $(ceph --name mon. --keyring /tmp/.exec_add_ceph_auth_admin.tmp \
  auth get-or-create-key client.cinder_volume) && rm -f /tmp/.exec_add_ceph_auth_admin.tmp",
        unless => "ceph-authtool /tmp/.exec_add_ceph_auth_admin.tmp \
--create-keyring \
--name=mon. \
--add-key='${::ceph_env::ceph_mon_key}' \
--cap mon 'allow *' && ceph --name mon. --keyring /tmp/.exec_add_ceph_auth_admin.tmp \
  auth get-or-create-key client.cinder_volume |grep '$(virsh -q secret-get-value $cinder_rbd_secret_uuid)'",
	require => Exec["secret_define_cinder_volume"],
        notify => Service ['libvirt'],
    }
    
  }



#  if is_array($compute_nodes) or  is_array($controller_nodes) or $compute_nodes  or $controller_nodes {
#  if $hostname in $compute_nodes or  $hostname in $controller_nodes or $compute_nodes == $host_prefix  or $controlle*r_node == $host_prefix {
 
  if is_array($compute_nodes) and $hostname in $compute_nodes  or $compute_nodes and $compute_nodes == $host_prefix {
        package { 'ceph-common': ensure	=> 'installed', }
	add_ceph_auth_cinder_volume {'cinder_volume':
		file_owner => 'nova',	
	}
	add_ceph_auth_mgmt_vm {'mgmt_vm':}
  }

## Added to nova/compute.pp - end

## Added to nova/controller.pp

  if $hostname_lc in $os_mgmt_nodes_lc {
    class {'nova::quota': 
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
  }	

## Added to nova/controller.pp
  
   if is_array($compute_nodes) or  is_array($controller_nodes) or $compute_nodes  or $controller_nodes {
  if $hostname in $compute_nodes or  $hostname in $controller_nodes or $compute_nodes == $host_prefix  or $controller_node == $host_prefix {
		
    package {'python-six': ensure => 'latest', }
    class { 'nova::client': }
    class { 'nova::scheduler': enabled	=> $nova_scheduler_enabled, }	
    class { '::zeromq': }
#    ensure_resource('package','python-neutronclient',{'ensure' => '2.3.0-0ubuntu1'})

    if $hostname_lc in $controller_nodes_lc {
      class { 'nova':
	database_connection	=> "mysql://${nova_db_user}:${nova_db_password}@${db_host_ip}/${nova_db_name}?charset=utf8",
	rpc_backend		=> $nova_rpc_backend,
	glance_api_servers	=> $nova_glance_api_servers,
	glance_protocol		=> $glance_public_protocol,
	rpc_zmq_ipc_dir		=> $rpc_zmq_ipc_dir,	
	matchmaker_ringfile	=> $matchmaker_ringfile,
	verbose                 => $verbose,
        debug                   => $debug,	
	use_syslog		=> $nova_use_syslog,
	log_facility		=> $nova_syslog_log_facility,
	memcached_servers	=> $memcached_server_url,
	default_floating_pool	=> $default_floating_pool,
      }	
    } else {
      class { 'nova':
        database_connection     => "mysql://${nova_db_user}:${nova_db_password}@${db_host_ip}/${nova_db_name}?charset=utf8",
        rpc_backend             => $nova_rpc_backend,
        glance_api_servers      => $nova_glance_api_servers,
        glance_protocol         => $glance_public_protocol,
        rpc_zmq_ipc_dir         => $rpc_zmq_ipc_dir,
        matchmaker_ringfile     => $matchmaker_ringfile,
        verbose                 => $verbose,
        debug                   => $debug,
        use_syslog              => $nova_use_syslog,
        log_facility            => $nova_syslog_log_facility,
      }
    }

###  nova network neutron
    class { 'nova::network::neutron':
	neutron_admin_password		=> $::os_env::service_user_password,
	neutron_url			=> "${::os_env::neutron_protocol}://${::os_env::neutron_internal_address}:${::os_env::neutron_internal_port}/",
	neutron_admin_tenant_name	=> $::os_env::service_tenant,
	neutron_region_name		=> $::os_env::region,
	neutron_admin_auth_url		=> "${::os_env::keystone_protocol}://${::os_env::keystone_internal_address}:${::os_env::keystone_port}/${::os_env::keystone_version}",
	neutron_url_timeout		=> $::os_env::neutron_url_timeout,
    }	

  }
}	

 package { $controller_nodes_pkgs_to_install:
	ensure		=> installed,
    }


### Setting up nova services
##
  class { 'nova::api':
	admin_password		=> $service_user_password,
	enabled			=> $nova_api_enabled,
	auth_host		=> $keystone_internal_address,
	osapi_compute_listen_port	=> $nova_osapi_compute_listen_port,
	ec2_listen_port		=> $nova_ec2_listen_port,
	auth_protocol		=> $keystone_protocol,
	auth_strategy		=> 'keystone',
	auth_uri		=> "${::os_env::keystone_protocol}://${::os_env::keystone_internal_address}:${::os_env::keystone_port}/${::os_env::keystone_version}",
	workers			=> $nova_workers,
	port_to_apache		=> $nova_port_to_apache,
	neutron_metadata_proxy_shared_secret	=> $nova_neutron_metadata_proxy_shared_secret,
	keystone_ec2_url => "${::os_env::keystone_protocol}://${::os_env::keystone_internal_address}:${::os_env::keystone_port}/${::os_env::keystone_version}/ec2tokens",
  }

  class { 'nova::conductor':
	enabled			=> $nova_conductor_enabled,
	workers			=> $nova_conductor_workers,
  }
	
  class { 'nova::cert':
	enabled			=> $nova_cert_enabled,
  }	

  class { 'nova::consoleauth':
	enabled			=> $nova_consoleauth_enabled,
  }	

  class { 'nova::vncproxy':
	port			=> $nova_vncproxy_listen_port,
	enabled			=> $nova_vncproxy_enabled,
  }	
    