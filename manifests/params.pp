### This manifest file set whole cloud system defaults
## Global environments come here
class jiocloud::params {
  $executable_path	= [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin/","/usr/local/sbin/" ]
  
  $ssl_enabled          = hiera('jiocloud::ssl_enabled',true)
  $multi_url		= hiera('jiocloud::multi_url',false)
  $ssl_cert_file       	= '/etc/apache2/certs/jiocloud.com.crt'
  $ssl_key_file        	= '/etc/apache2/certs/jiocloud.com.key'
  $ssl_ca_file         	= '/etc/apache2/certs/gd_bundle-g2-g1.crt'
  $jiocloud_ssl_cert_package_version = hiera('jiocloud::ssl::cert_package_version')
  $vrouter_file         	= "/lib/modules/$kernelrelease/extra/net/vrouter/vrouter.ko"
  $vrouter_file_source  	= "puppet:///modules/jiocloud/openstack/compute/_lib_modules_${kernelrelease}_extra_net_vrouter_vrouter.ko"
  $interfaces_array = split($interfaces,',')
  $interface_addresses 	= inline_template('<%= @interfaces_array.reject{ |ifc| ifc == "lo" }.map{ |ifc| scope.lookupvar("ipaddress_#{ifc}") }.join(" ")
%>')
  $ip_array = split($interface_addresses, ' ')
  $host_prefix          = inline_template("<%= @hostname.sub(/^\s*([a-zA-Z\-\.]+)\d+$/,'\1') %>")
  $hostname_lc	= downcase($hostname)

  
### base system environment

  ## Base system config 
  $all_nodes_pkgs_to_install = hiera('jiocloud::system::all_nodes_pkgs_to_install')
  $all_nodes_pkgs_to_remove = hiera('jiocloud::system::all_nodes_pkgs_to_remove',[ 'resolvconf' ])
  $all_nodes_services_to_run = hiera('jiocloud::system::all_nodes_services_to_run',[ 'ssh' ])
  ## END Base system config  

  $autoreboot = hiera('jiocloud::system::autoreboot',false)
  ## NTP server config
  $ntp_server_servers = hiera('jiocloud::system::ntp_server_servers') # NTP servers configured on local ntp servers
  $ntp_servers = hiera('jiocloud::system::ntp_servers') # local ntp servers configured on all servers
  ## END NTP server config


  ## network interface configuration
  $compute_fe_interface = hiera('jiocloud::system::compute_fe_interface')
  $compute_be_interface = hiera('jiocloud::system::compute_be_interface')
  $network_device_mtu = hiera('jiocloud::system::network_device_mtu',1500)
  ## END network interface configuration
  
  ## resolv.conf: setup resolv.conf 
  $dnsdomainname = hiera('jiocloud::system::dnsdomainname')
  $dnssearch = hiera('jiocloud::system::dnssearch',[ $dnsdomainname ])
  $dnsservers = hiera('jiocloud::system::dnsservers')
  ## END resolv.conf:

  ###dns cname: Required to setup function based cname in dns 
  $manage_hostname = hiera('jiocloud::system::manage_hostname',true)
  $update_dns	= hiera('jiocloud::system::update_dns',false)
  $dns_master_server = hiera('jiocloud::system::dns_master_server')
  $dnsupdate_key = hiera('jiocloud::system::dnsupdate_key')
  ### END dns cname:

  ### Hosts file entries
  $hosts_entries = hiera('jiocloud::system::hosts_entries',false)

  ### system user 
  $active_users = hiera('jiocloud::system::active_users',undef)
  $sudo_users = hiera('jiocloud::system::sudo_users',undef)
  $local_users = hiera('jiocloud::system::local_users')
  $root_password = hiera('jiocloud::system::root_password')
  ### END Sudo users

## Apt configs
  $local_repo_ip = hiera('jiocloud::system::local_repo_ip')
  $apt_sources = hiera('jiocloud::system::apt_sources',undef)
  $default_active_apt_sources = hiera('jiocloud::system::default_active_apt_sources')
  $extra_active_apt_sources = hiera('jiocloud::system::extra_active_apt_sources',undef)
  $active_apt_sources = split(inline_template("<%= (@default_active_apt_sources + @extra_active_apt_sources).join(',') %>"),',')


  $keystone_db_user = hiera('jiocloud::openstack::keystone_db_user')
  $keystone_db_password = hiera('jiocloud::openstack::keystone_db_password')
  $keystone_db_name = hiera('jiocloud::openstack::keystone_db_name')

  $glance_db_user = hiera('jiocloud::openstack::glance_db_user')
  $glance_db_password = hiera('jiocloud::openstack::glance_db_password')
  $glance_db_name = hiera('jiocloud::openstack::glance_db_name')

  $nova_db_user = hiera('jiocloud::openstack::nova_db_user')
  $nova_db_password = hiera('jiocloud::openstack::nova_db_password')
  $nova_db_name = hiera('jiocloud::openstack::nova_db_name')

  $cinder_db_user = hiera('jiocloud::openstack::cinder_db_user')
  $cinder_db_password = hiera('jiocloud::openstack::cinder_db_password')
  $cinder_db_name = hiera('jiocloud::openstack::cinder_db_name')
  
  ## Mysql environment defaults
  $os_dbs_hash  = {
    novadb   => { db => $nova_db_name, user => $nova_db_user, pass => $nova_db_password },
    keystonedb => { db => $keystone_db_name, user => $keystone_db_user, pass => $keystone_db_password },
    cinderdb => { db => $cinder_db_name, user => $cinder_db_user, pass => $cinder_db_password },
    glancedb => { db => $glance_db_name, user => $glance_db_user, pass => $glance_db_password },
  }

  $db_host_ip		     	= hiera('jiocloud::db::db_host_ip')
  $mysql_server_package_name 	= hiera('jiocloud::db::mysql_server_package_name','mariadb-server')     # Server package to use
  $mysql_client_package_name 	= hiera('jiocloud::db::mysql_client_package_name','mariadb-client')     # Client Package to use 
  $mysql_root_pass 		= hiera('jiocloud::db::mysql_root_pass')                 #mysql root password to set
  $mysql_datadir 		= hiera('jiocloud::db::mysql_datadir')               # mysql data directory
  $mysql_max_connections 	= hiera('jiocloud::db::mysql_max_connections')                  # maximum connections
  $os_dbs			= hiera('jiocloud::db::os_dbs',$os_dbs_hash)
  $other_dbs			= hiera('jiocloud::db::other_dbs',undef) 
  $mysql_data_disk		= hiera('jiocloud::db::mysql_data_disk',undef)

## KVM Environment default 
  $mgmt_vm_virsh_secret_uuid = hiera('jiocloud::kvm::mgmt_vm_virsh_secret_uuid','d5a71695-e4de-45fd-b084-f0af0123fc7d')
  $mgmt_vm_virsh_secret_value = hiera('jiocloud::kvm::mgmt_vm_virsh_secret_uuid','AQCq/iNT2MrcLxAAWU33d+5eftjZA4Ogzmmw4w==')
  $mgmt_vms  =  hiera('jiocloud::kvm::mgmt_vms',undef)

### Openstack Environment
    
  if $ssl_enabled {
    $http_protocol = 'https'
    $glance_registry_listen_port  = 19191
    $metadata_listen_port	= 18775
    $glance_api_listen_port       = 19292
    $keystone_public_listen_port  = 15000
    $keystone_admin_listen_port   = 35358
    $cinder_listen_port           = 18776
    $nova_vncproxy_listen_port    = 16080
    $nova_osapi_compute_listen_port   = 18774
    $nova_ec2_listen_port = 18773
    $ceph_radosgw_listen_port = 443
    $multi_url_port = 443
    $service_listen_address = '127.0.0.1'
  } else {
    $http_protocol = 'http'
    $glance_registry_listen_port  = 9191
    $glance_api_listen_port       = 9292
    $keystone_public_listen_port  = 5000
    $keystone_admin_listen_port   = 35357
    $cinder_listen_port           = 8776
    $nova_vncproxy_listen_port    = 6080
    $nova_osapi_compute_listen_port = 8774
    $nova_ec2_listen_port         = 8773
    $metadata_listen_port       = 8775
    $ceph_radosgw_listen_port = 80 
    $multi_url_port = 80
    $service_listen_address = '0.0.0.0'
  }
  
  if $multi_url {
    $keystone_port 	= $multi_url_port
    $nova_port		= $multi_url_port
    $nova_ec2_port	= 8773 
    $nova_vncproxy_port = 6080
    $glance_port	= $multi_url_port
    $glance_registry_port	= 9191
    $cinder_port	= $multi_url_port
    $neutron_port	= $multi_url_port
    $ceph_radosgw_port  = $multi_url_port
    $nova_public_address       = hiera('jiocloud::openstack::nova_public_address')
    $keystone_public_address	= hiera('jiocloud::openstack::keystone_public_address')
    $cinder_public_address       = hiera('jiocloud::openstack::cinder_public_address')
    $glance_public_address       = hiera('jiocloud::openstack::glance_public_address')
    $object_storage_public_address = hiera('jiocloud::ceph::radosgw_public_address')
    $neutron_public_address      = hiera('jiocloud::openstack::neutron_public_address')
    $horizon_public_address	= hiera('jiocloud::openstack::horizon_public_address')
    $ceph_radosgw_public_address = hiera('jiocloud::openstack::radosgw_public_address')
  } else {
    $public_address = hiera('jiocloud::public_address')
    $keystone_public_address      = $public_address
    $nova_public_address       = $public_address
    $cinder_public_address       = $public_address
    $glance_public_address       = $public_address
    $ceph_radosgw_public_address = $public_address 
    $neutron_public_address	= $public_address
    $horizon_public_address	= $public_address
    $keystone_port      = 5000
    $nova_port          = 8774
    $nova_ec2_port	= 8773 
    $nova_vncproxy_port = 6080
    $glance_port        = 9292
    $glance_registry_port	= 9191
    $cinder_port        = 8776
    $neutron_port	= 9695
    $ceph_radosgw_port  = 8143
  }
  
  $compute_nodes           = hiera('jiocloud::openstack::compute_nodes','cp')
  $storage_nodes           = hiera('jiocloud::openstack::storage_nodes','st')
  $contrail_nodes          = hiera('jiocloud::openstack::contrail_nodes','ct')
  $os_controller_nodes	   = hiera('jiocloud::openstack::controller_nodes')

  ## Apache configs for openstack controller application reverse proxy 
  ## FIXME: The controller applications to be migrated to apache as wsgi app, tried but got issues on operations for now.
  $os_apache_docroot = hiera('jiocloud::openstack::apache_docroot')
  $horizon_wsgi_daemon_user = hiera('jiocloud::openstack::horizon_wsgi_daemon_user')
  $horizon_wsgi_daemon_group = hiera('jiocloud::openstack::horizon_wsgi_daemon_group')
  $horizon_wsgi_num_procs = hiera('jiocloud::openstack::horizon_wsgi_num_procs')
  $horizon_wsgi_num_threads = hiera('jiocloud::openstack::horizon_wsgi_num_threads')
## Package management
## FIXME: ideally installing new packages should be managed by apt-get upgrade,   
  $os_package_ensure	= hiera('jiocloud::openstack::os_package_ensure','present')
  $keystone_package_ensure = hiera('jiocloud::openstack::keystone_package_ensure',$os_package_ensure)
  $nova_package_ensure = hiera('jiocloud::openstack::nova_package_ensure',$os_package_ensure)
  $cinder_package_ensure = hiera('jiocloud::openstack::cinder_package_ensure',$os_package_ensure)
  $glance_package_ensure = hiera('jiocloud::openstack::glance_package_ensure',$os_package_ensure)
  $horizon_package_ensure = hiera('jiocloud::openstack::horizon_package_ensure',$os_package_ensure)
  $jiocloud_registration_package_ensure = hiera('jiocloud::openstack::jiocloud_registration_package_ensure',$os_package_ensure)

## Database details for openstack	

  $os_controller_nodes_pkgs_to_install     = hiera('jiocloud::openstack::os_controller_nodes_pkgs_to_install',undef)


## Global debug configuration
  $verbose                      = hiera('jiocloud::openstack::verbose',false) # Verbose for all openstack services
  $debug                        = hiera('jiocloud::openstack::debug',false) # Debug settings for all openstack services
## End Global debug

### Keystone configuration
## Keystone admin, tenant details
  $admin_password = hiera('jiocloud::openstack::admin_password')	# Keystone Admin user password
  $admin_token = hiera('jiocloud::openstack::admin_token')	# keystone admin token
  $admin_email = hiera('jiocloud::openstack::admin_email') #Keystone Admin user password
  $service_user_password = hiera('jiocloud::openstack::service_user_password')	# Service user password, this is used by all service users like neutron, nova, glance etc.
  $service_tenant = hiera('jiocloud::openstack::service_tenant','services')	# Service tenant
  $region = hiera('jiocloud::openstack::region')	# Keystone region

## End Keystone admin, tenant 

  ##Start: Keystone Cache 
  $keystone_cache_enabled = hiera('jiocloud::openstack::keystone::cache_enabled',false)
  $keystone_cache_config_prefix = hiera('jiocloud::openstack::keystone::cache_config_prefix','cache.keystone')
  $keystone_cache_expiration_time = hiera('jiocloud::openstack::keystone::cache_expiration_time',600)
  $keystone_cache_backend = hiera('jiocloud::openstack::keystone::cache_backend','dogpile.cache.memcached')
  $keystone_cache_backend_argument = hiera('jiocloud::openstack::keystone::cache_backend_argument',undef)
  ## End: Keystone Cache


  $keystone_accepted_roles = hiera('jiocloud::openstack::keystone_accepted_roles')
  $keystone_token_cache_size = hiera('jiocloud::openstack::keystone_token_cache_size',500)
#  $keystone_node = hiera('jiocloud::openstack::keystone_node','t2')
  $keystone_token_format = hiera('jiocloud::openstack::keystone_token_format','uuid')

  $keystone_internal_address = hiera('jiocloud::openstack::keystone_internal_address',$keystone_public_address)
  $keystone_admin_address = hiera('jiocloud::openstack::keystone_admin_address',$keystone_internal_address)
  #$keystone_public_port = hiera('jiocloud::openstack::keystone_public_port',$keystone_port)
  $keystone_admin_port = hiera('jiocloud::openstack::keystone_admin_port')
  $keystone_protocol = $http_protocol
  $keystone_version  = hiera('jiocloud::openstack::keystone_version')

  
  $keystone_public_url          = "$keystone_protocol://${keystone_public_address}:${keystone_port}/${keystone_version}"
  $keystone_internal_url        = "$keystone_protocol://${keystone_internal_address}:${keystone_port}/${keystone_version}"
  $keystone_admin_url           = "$keystone_protocol://${keystone_admin_address}:${keystone_admin_port}/${keystone_version}"

  $vncproxy_protocol		= $http_protocol
  $neutron_internal_address     = hiera('jiocloud::openstack::neutron_internal_address',$neutron_public_address)
  $neutron_admin_address        = hiera('jiocloud::openstack::neutron_admin_address',$neutron_internal_address)
  $neutron_protocol		= $http_protocol
  $neutron_internal_url         = "${neutron_protocol}://${neutron_internal_address}:${neutron_port}/"
  $neutron_public_url 		= "${neutron_protocol}://${neutron_public_address}:${neutron_port}/"
  

  $nova_internal_address     = hiera('jiocloud::openstack::nova_internal_address',$nova_public_address)
  $nova_admin_address        =  hiera('jiocloud::openstack::nova_admin_address',$nova_internal_address)
#  $nova_public_port          = $nova_port
  $nova_protocol		= $http_protocol
  $nova_port_to_apache          = false

  $volume_tmp_dir		= hiera('jiocloud::openstack::volume_tmp_dir','/var/tmp')
  $cinder_internal_address     = hiera('jiocloud::openstack::cinder_internal_address',$cinder_public_address)
  $cinder_admin_address        = hiera('jiocloud::openstack::cinder_admin_address',$cinder_internal_address)
  $cinder_protocol		= $http_protocol
#  $cinder_public_port          = $cinder_port

  $glance_internal_address     = hiera('jiocloud::openstack::glance_internal_address',$glance_public_address)
  $glance_admin_address        = hiera('jiocloud::openstack::glance_admin_address',$glance_internal_address)
#  $glance_public_port          = $glance_port
  $glance_protocol       = $http_protocol

#  $keystone_ceph_enabled                = true ## is it using anywhere?

  $nova_use_syslog = hiera('jiocloud::openstack::nova_use_syslog',false)
  $nova_syslog_log_facility = hiera('jiocloud::openstack::nova_syslog_log_facility','LOG_LOCAL0')
  $glance_use_syslog = hiera('jiocloud::openstack::glance_use_syslog',false)
  $glance_syslog_log_facility = hiera('jiocloud::openstack::glance_syslog_log_facility','LOG_LOCAL1')
  $cinder_use_syslog = hiera('jiocloud::openstack::cinder_use_syslog',false)
  $cinder_log_facility = hiera('jiocloud::openstack::cinder_log_facility','LOG_LOCAL2')
  $keystone_use_syslog = hiera('jiocloud::openstack::keystone_use_syslog',false)
  $keystone_syslog_log_facility = hiera('jiocloud::openstack::keystone_syslog_log_facility','LOG_LOCAL3')

## nova.conf entries
  
  $nova_neutron_metadata_proxy_shared_secret    = hiera('jiocloud::openstack::nova_neutron_metadata_proxy_shared_secret')
  $nova_workers = hiera('jiocloud::openstack::nova_workers',2)
  $neutron_libvirt_vif_driver = hiera('jiocloud::openstack::neutron_libvirt_vif_driver')
  $nova_rpc_backend = hiera('jiocloud::openstack::nova_rpc_backend')

  $nova_glance_api_servers      = "$glance_protocol://$glance_public_address:$glance_port"
  $rpc_zmq_ipc_dir              = hiera('jiocloud::openstack::rpc_zmq_ipc_dir','/var/run/openstack')
  $matchmaker_ringfile          = hiera('jiocloud::openstack::matchmaker_ringfile','/etc/matchmaker/matchmaker.json')
#  $os_mgmt_nodes                = ['t2oc1']     ## Nodes on which puppet manifests for certain central openstack management
  $cinder_api_nodes             = hiera('jiocloud::openstack::cinder_api_nodes',$os_controller_nodes)
  $cinder_rpc_backend           = hiera('jiocloud::openstack::cinder_rpc_backend','cinder.openstack.common.rpc.impl_zmq')

  $glance_nodes = hiera('jiocloud::openstack::glance_nodes',$os_controller_nodes)
  $glance_backend = hiera('jiocloud::openstack::glance_backend','rbd')
  $glance_rbd_store_user = hiera('jiocloud::openstack::glance_rbd_store_user','glance')
  $glance_rbd_store_pool = hiera('jiocloud::openstack::glance_rbd_store_pool','images')

  $cinder_volume_rbd_pool = hiera('jiocloud::openstack::cinder_volume_rbd_pool','volumes')
  $cinder_volume_rbd_user = hiera('jiocloud::openstack::cinder_volume_rbd_user','cinder_volume')
  $cinder_rbd_secret_uuid = hiera('jiocloud::openstack::cinder_rbd_secret_uuid')

  $nova_api_nodes = hiera('jiocloud::openstack::nova_api_nodes',$os_controller_nodes)
  $nova_cert_nodes = hiera('jiocloud::openstack::nova_cert_nodes',$os_controller_nodes)
  $nova_consoleauth_nodes = hiera('jiocloud::openstack::nova_consoleauth_nodes',$os_controller_nodes)
  $nova_scheduler_nodes = hiera('jiocloud::openstack::nova_scheduler_nodes',$os_controller_nodes)
  $conductor_nodes = hiera('jiocloud::openstack::conductor_nodes',$os_controller_nodes)
  $cinder_volume_nodes = hiera('jiocloud::openstack::cinder_volume_nodes',$os_controller_nodes)
  $cinder_backup_nodes = hiera('jiocloud::openstack::cinder_backup_nodes',$cinder_volume_nodes)
  $cinder_scheduler_nodes = hiera('jiocloud::openstack::cinder_scheduler_nodes',$os_controller_nodes)
  $nova_vncproxy_nodes = hiera('jiocloud::openstack::nova_vncproxy_nodes',$os_controller_nodes)

  $nova_conductor_workers = hiera('jiocloud::openstack::nova_conductor_workers',3)
  $nova_conductor_use_local = hiera('jiocloud::openstack::nova_conductor_use_local',false)
  
  $quota_instances = hiera('jiocloud::openstack::quota_instances',45)
  $quota_cores = hiera('jiocloud::openstack::quota_cores',90)
  $quota_ram = hiera('jiocloud::openstack::quota_ram',409600)
  $quota_volumes = hiera('jiocloud::openstack::quota_volumes',20)
  $quota_gigabytes = hiera('jiocloud::openstack::quota_gigabytes',5120)
  $quota_floating_ips = hiera('jiocloud::openstack::quota_floating_ips',10)
  $quota_max_injected_files = hiera('jiocloud::openstack::quota_max_injected_files',5)
  $quota_security_groups = hiera('jiocloud::openstack::quota_security_groups',10)
  $quota_security_group_rules = hiera('jiocloud::openstack::quota_security_group_rules',50)
  $quota_key_pairs = hiera('jiocloud::openstack::quota_key_pairs',50)

  $vncserver_proxyclient_address     = $default_gw_ip	## IP set on default gw interface
  $vncproxy_host                = $nova_public_address

  $virtio_nic = hiera('jiocloud::openstack::virtio_nic',true)
  $neutron_enabled = hiera('jiocloud::openstack::neutron_enabled',true)
  
  $default_floating_pool        = hiera(jiocloud::openstack::default_floating_pool)

  ### Starting with standalone memcached; multi node memcached cluster tobe setup for scaleout and reliability


  $memcached_nodes_address		= hiera('jiocloud::memcached::nodes_address')
  $memcached_listen = hiera('jiocloud::memcached::listen_address','0.0.0.0')
  $memcached_port = hiera('jiocloud::memcached::listen_port','11211')
  $memcached_max_memory = hiera('jiocloud::memcached::max_memory',5120)
  $memcached_server_url = [inline_template('<% @memcached_nodes_address.each do | mc | @mc_url = "#@mc_url #{mc}:#@memcached_port," %> <% end %> <%= @mc_url.gsub(/^ */,"").gsub(/, *$/,"") %> ')]

  $horizon_secret_key           = $service_user_password
  $horizon_api_result_limit     = hiera('jiocloud::openstack::horizon::api_result_limit',2000)
  $horizon_allowed_hosts         = hiera('jiocloud::openstack::horizon::allowed_hosts',$horizon_public_address)
  $horizon_recaptcha_public_key	= hiera('jiocloud::openstack::horizon::recaptcha::public_key')
  $horizon_recaptcha_private_key = hiera('jiocloud::openstack::horizon::recaptcha::private_key')
  $horizon_recaptcha_proxy = hiera('jiocloud::proxy_server')
  
  $horizon_sms_system_hostname = hiera('jiocloud::openstack::horizon::sms::hostname')
  $horizon_sms_system_id = hiera('jiocloud::openstack::horizon::sms::system_id')
  $horizon_sms_system_password = hiera('jiocloud::openstack::horizon::sms::system_password')
  $horizon_sms_source_addr = hiera('jiocloud::openstack::horizon::sms::source_addr')
  $horizon_theme_app	= hiera('jiocloud::openstack::horizon::theme_app',undef)
  $horizon_compress_enabled = hiera('jiocloud::openstack::horizon::compress_enabled','False')
  $horizon_compress_offline = hiera('jiocloud::openstack::horizon::offline_compression','False')
  $jiocloud_registration_enabled = hiera('jiocloud::openstack::jiocloud_registration::enabled', false)
  
  $nova_physical_volumes        = hiera('jiocloud::openstack::nova_physical_volumes')
  $nova_volume_group = hiera('jiocloud::openstack::nova_volume_group','Nova_Volumes')
  $nova_logical_volume	= hiera('jiocloud::openstack::nova_volume_group','nova')
  $nova_libvirt_images_type = hiera('jiocloud::openstack::nova_libvirt_images_type','raw')
  $nova_libvirt_type = hiera('jiocloud::openstack::nova_libvirt_type')
  $nova_snapshot_image_format = hiera('jiocloud::openstack::nova_snapshot_image_format','qcow2')

## Ceph params
  $ceph_auth_type               = hiera('jiocloud::ceph::auth_type','cephx')
  $ceph_mon_port                = hiera('jiocloud::ceph::mon_port','6789')

  $ceph_fsid                    = hiera('jiocloud::ceph::fsid')
  $ceph_mon_key                 = hiera('jiocloud::ceph::mon_key')
  $ceph_storage_cluster_interface	= hiera('jiocloud::ceph::storage_cluster_interface',undef)
  $ceph_public_interface	= hiera('jiocloud::ceph::ceph_public_interface',undef)
#  $ceph_storage_cluster_nw_input = hiera('jiocloud::ceph::storage_cluster_network',undef)
#  $ceph_public_nw_input          = hiera('jiocloud::ceph::ceph_public_network',undef)
  $ceph_radosgw_nodes           = hiera('jiocloud::ceph::radosgw_nodes')
  $ceph_osds 	= hiera('jiocloud::ceph::osds') 
  $ceph_mon_nodes = hiera('jiocloud::ceph::mon_nodes')
  $ceph_admin_key = hiera('jiocloud::ceph::admin_key',undef)
  $ceph_mon_initial_members = hiera('jiocloud::ceph::ceph_mon_initial_members',$ceph_mon_nodes)
  $ceph_mon_config = hiera('jiocloud::ceph::mon_config')
  $ceph_radosgw_internal_address = hiera('jiocloud::ceph::radosgw_internal_address',$ceph_radosgw_public_address)
  $ceph_radosgw_admin_address = hiera('jiocloud::ceph::radosgw_admin_address',$ceph_radosgw_internal_address)

  ### first_partition -> first partition of the data disk, filesystem -> journal directory under individual disk filesystem, /dev/sdx (device name) - separate journal disk (not implemented)
  $ceph_osd_journal_type        = hiera('jiocloud::ceph::osd_journal_type','first_partition')
  $ceph_osd_journal_size        = hiera('jiocloud::ceph::osd_journal_size',10)            ## Journal size in GiB, only numaric part, no unit, only applicable for 'first_partition'
  $ceph_keyring                 = hiera('jiocloud::ceph::ceph_keyring','/etc/ceph/keyring')
  $ceph_radosgw_enabled         = hiera('jiocloud::ceph::radosgw_enabled',true)
  $ceph_radosgw_log_file                = hiera('jiocloud::ceph::radosgw_log_file','/var/log/ceph/radosgw.log')
  $ceph_radosgw_serveradmin_email       = $admin_email 
  $ceph_radosgw_fastcgi_ext_script      = hiera('jiocloud::ceph::fastcgi_ext_script','/var/www/s3gw.fcgi')
  $ceph_radosgw_socket          = hiera('jiocloud::ceph::radosgw_socket','/var/run/ceph/radosgw.sock')
  $ceph_radosgw_keyring         = '/etc/ceph/keyring.radosgw.gateway'
  $ceph_radosgw_apache_version  = '2.2'

  $ceph_pool_cinder_volume      = hiera('jiocloud::ceph::cinder_volume_pool','volumes')
  $ceph_pool_cinder_backup      = hiera('jiocloud::ceph::cinder_backup_pool','backups')
  $ceph_pool_glance_image       = hiera('jiocloud::ceph::glance_image_pool','images')

  $ceph_pools_to_add            = [ $ceph_pool_cinder_volume, $ceph_pool_cinder_backup, $ceph_pool_glance_image ]
  $ceph_pool_number_of_pgs      = hiera('jiocloud::ceph::number_of_pgs',128)

  if (is_array($compute_nodes) and $hostname in $compute_nodes)  or ($compute_nodes and $compute_nodes == $host_prefix) {
    $iam_compute_node = true
  }

  if (is_array($contrail_nodes) and $hostname in $contrail_nodes)  or ($contrail_nodes and $contrail_nodes == $host_prefix) {
    $iam_contrail_node = true
  }

  if (is_array($os_controller_nodes) and $hostname in $os_controller_nodes)  or ($os_controller_nodes and $os_controller_nodes == $host_prefix) {
    $iam_os_controller_node = true
  }
  if (is_array($storage_nodes) and $hostname in $storage_nodes)  or ($storage_nodes and $storage_nodes == $host_prefix) {
    $iam_storage_node = true
  }
  $iam_memcached_node = inline_template("<%= !(@ip_array & @memcached_nodes_address).empty? %>")
  $iam_ntpserver_node = inline_template("<%= !(@ip_array & @ntp_servers).empty? %>")

 
  ##FIXME: Currently only ceph_storage_cluster_interface and ceph_public_interface is supported, 
  if $iam_storage_node {
  if $ceph_storage_cluster_interface {
    $ceph_storage_cluster_nw = inline_template("<%= scope.lookupvar('network_' + @ceph_storage_cluster_interface) %>")
    $ceph_storage_cluster_cidr = inline_template("<%= scope.lookupvar('netmask_' + @ceph_storage_cluster_interface).sub(/(\d+)\.(\d+)\.(\d+)\.(\d+)/,'\1') .to_i.to_s(2).scan(/1/).size + scope.lookupvar('netmask_' + @ceph_storage_cluster_interface).sub(/(\d+)\.(\d+)\.(\d+)\.(\d+)/,'\2') .to_i.to_s(2).scan(/1/).size + scope.lookupvar('netmask_' + @ceph_storage_cluster_interface).sub(/(\d+)\.(\d+)\.(\d+)\.(\d+)/,'\3') .to_i.to_s(2).scan(/1/).size + scope.lookupvar('netmask_' + @ceph_storage_cluster_interface).sub(/(\d+)\.(\d+)\.(\d+)\.(\d+)/,'\4') .to_i.to_s(2).scan(/1/).size  %>")
   $ceph_storage_cluster_network = "${ceph_storage_cluster_nw}/${ceph_storage_cluster_cidr}"
  } elsif $ceph_storage_cluster_nw_input {
    $ceph_storage_cluster_network = $ceph_storage_cluster_nw_input
  } else {
    fail ('Errr: either of jiocloud::ceph::storage_cluster_interface or jiocloud::ceph::storage_cluster_network must be set')
  }
  if $ceph_public_interface {
    $ceph_public_nw = inline_template("<%= scope.lookupvar('network_' + @ceph_public_interface) %>")
    $ceph_public_cidr = inline_template("<%= scope.lookupvar('netmask_' + @ceph_public_interface).sub(/(\d+)\.(\d+)\.(\d+)\.(\d+)/,'\1') .to_i.to_s(2).scan(/1/).size + scope.lookupvar('netmask_' + @ceph_public_interface).sub(/(\d+)\.(\d+)\.(\d+)\.(\d+)/,'\2') .to_i.to_s(2).scan(/1/).size + scope.lookupvar('netmask_' + @ceph_public_interface).sub(/(\d+)\.(\d+)\.(\d+)\.(\d+)/,'\3') .to_i.to_s(2).scan(/1/).size + scope.lookupvar('netmask_' + @ceph_public_interface).sub(/(\d+)\.(\d+)\.(\d+)\.(\d+)/,'\4') .to_i.to_s(2).scan(/1/).size  %>")
   $ceph_public_network = "${ceph_public_nw}/${ceph_public_cidr}"
  } elsif $ceph_public_nw_input {
    $ceph_storage_cluster_network = $ceph_storage_cluster_nw_input
  } else {
    fail ('Errr: either of jiocloud::ceph::ceph_public_interface or jiocloud::ceph::ceph_public_network must be set')
  } 

  $ceph_public_address          = inline_template("<%= scope.lookupvar('ipaddress_' + @ceph_public_interface) %>")
  $ceph_mon_ip			= $ceph_public_address
  $ceph_cluster_address		= inline_template("<%= scope.lookupvar('ipaddress_' + @ceph_storage_cluster_interface) %>")
  }
  $nova_db_url = "mysql://${nova_db_user}:${nova_db_password}@${db_host_ip}/${nova_db_name}?charset=utf8"
  $keystone_db_url = "mysql://${keystone_db_user}:${keystone_db_password}@${db_host_ip}/${keystone_db_name}?charset=utf8"
  $cinder_db_url = "mysql://${cinder_db_user}:${cinder_db_password}@${db_host_ip}/${cinder_db_name}?charset=utf8"
  $glance_db_url = "mysql://${glance_db_user}:${glance_db_password}@${db_host_ip}/${glance_db_name}?charset=utf8"
if $iam_compute_node {
  $ceph_public_address          = inline_template("<%= scope.lookupvar('ipaddress_' + @ceph_public_interface) %>")
  $ceph_mon_ip                  = $ceph_public_address
  $ceph_cluster_address         = inline_template("<%= scope.lookupvar('ipaddress_' + @ceph_storage_cluster_interface) %>")

  $vrouter_physical_interface = $compute_fe_interface
  $configure_contrail_node = hiera('jiocloud::contrail::configure_contrail_node',false)
  if 'vhost0' in $interfaces_array {
        $vrouter_interface = vhost0
        $contrail_vrouter_ip          = $ipaddress_vhost0
        $contrail_vrouter_netmask     = $netmask_vhost0
        $contrail_vrouter_nw_first_three        = inline_template("<%= scope.lookupvar('network_' + @vrouter_interface).sub(/(\d+)\.(\d+)\.(\d+)\.(\d+)/,'\1.\2.\3') %>")
        $contrail_vrouter_nw_last_oct   = inline_template("<%= scope.lookupvar('network_' + @vrouter_interface).sub(/(\d+)\.(\d+)\.(\d+)\.(\d+)/,'\4').to_i %>")
        $contrail_vrouter_nw_first_ip   = $contrail_vrouter_nw_last_oct + 1
        $contrail_vrouter_gw = "${contrail_vrouter_nw_first_three}.${contrail_vrouter_nw_first_ip}"
        $contrail_vrouter_cidr = inline_template("<%= scope.lookupvar('netmask_' + @vrouter_interface).sub(/(\d+)\.(\d+)\.(\d+)\.(\d+)/,'\1') .to_i.to_s(2).scan(/1/).size + scope.lookupvar('netmask_' + @vrouter_interface).sub(/(\d+)\.(\d+)\.(\d+)\.(\d+)/,'\2') .to_i.to_s(2).scan(/1/).size + scope.lookupvar('netmask_' + @vrouter_interface).sub(/(\d+)\.(\d+)\.(\d+)\.(\d+)/,'\3') .to_i.to_s(2).scan(/1/).size + scope.lookupvar('netmask_' + @vrouter_interface).sub(/(\d+)\.(\d+)\.(\d+)\.(\d+)/,'\4') .to_i.to_s(2).scan(/1/).size  %>")
         $contrail_discovery_server    = hiera('jiocloud::contrail::discovery::server')
         $contrail_vrouter_num_controllers = hiera('jiocloud::contrail::vrouter_num_controller',2)         # Number of controllers the vrouter can connect - 1 or 2
         $contrail_vrouter_mac         = inline_template("<%= scope.lookupvar('macaddress_' + @vrouter_interface) %>")
#FIXME: This array to be implemented
         $contrail_static_route_vhost0 = hiera('jiocloud::contrail::static_route_vhost0')
         $contrail_edge_router_address          = hiera('jiocloud::contrail::edge_router_addr')
     } else {
        $contrail_vrouter_interface = $compute_fe_interface
        $contrail_vrouter_ip          = inline_template("<%= scope.lookupvar('ipaddress_' + @contrail_vrouter_interface) %>")
        if $contrail_vrouter_ip {
          $contrail_vrouter_netmask     = inline_template("<%= scope.lookupvar('netmask_' + @contrail_vrouter_interface) %>")
#       $contrail_vrouter_gw     = inline_template("<%= scope.lookupvar('network_' + @contrail_vrouter_interface).sub(/(\d+)\.(\d+)\.(\d+)\.(\d+)/,'\1.\2.\3.'+\4+1) %>")
          $contrail_vrouter_nw_first_three        = inline_template("<%= scope.lookupvar('network_' + @contrail_vrouter_interface).sub(/(\d+)\.(\d+)\.(\d+)\.(\d+)/,'\1.\2.\3') %>")
          $contrail_vrouter_nw_last_oct   = inline_template("<%= scope.lookupvar('network_' + @contrail_vrouter_interface).sub(/(\d+)\.(\d+)\.(\d+)\.(\d+)/,'\4').to_i %>")
          $contrail_vrouter_nw_first_ip   = $contrail_vrouter_nw_last_oct + 1
          $contrail_vrouter_gw = "${contrail_vrouter_nw_first_three}.${contrail_vrouter_nw_first_ip}"
          $contrail_vrouter_cidr = inline_template("<%= scope.lookupvar('netmask_' + @contrail_vrouter_interface).sub(/(\d+)\.(\d+)\.(\d+)\.(\d+)/,'\1') .to_i.to_s(2).scan(/1/).size + scope.lookupvar('netmask_' + @contrail_vrouter_interface).sub(/(\d+)\.(\d+)\.(\d+)\.(\d+)/,'\2') .to_i.to_s(2).scan(/1/).size + scope.lookupvar('netmask_' + @contrail_vrouter_interface).sub(/(\d+)\.(\d+)\.(\d+)\.(\d+)/,'\3') .to_i.to_s(2).scan(/1/).size + scope.lookupvar('netmask_' + @contrail_vrouter_interface).sub(/(\d+)\.(\d+)\.(\d+)\.(\d+)/,'\4') .to_i.to_s(2).scan(/1/).size  %>")
          $contrail_vrouter_mac         = inline_template("<%= scope.lookupvar('macaddress_' + @contrail_vrouter_interface) %>")
         }
         $contrail_discovery_server    = hiera('jiocloud::contrail::discovery::server')
         $contrail_vrouter_num_controllers = hiera('jiocloud::contrail::vrouter_num_controller',2)         # Number of controllers the vrouter can connect - 1 or 2

#FIXME: This array to be implemented
         $contrail_static_route_vhost0 = hiera('jiocloud::contrail::static_route_vhost0')
         $contrail_edge_router_address          = hiera('jiocloud::contrail::edge_router_addr')
    }



}
}
