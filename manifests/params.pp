### This manifest file set whole cloud system defaults
## Global environments come here
class jiocloud::params {
  $neutron_address	= $public_address
  $executable_path	= [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin/","/usr/local/sbin/" ]
  $ssl_enabled          = true
  $multi_url		= true
  $ssl_cert_file_source = "$puppet_master_files/ssl/jiocloud.com.crt"
  $ssl_cert_file       	= '/etc/apache2/certs/jiocloud.com.crt'
  $ssl_key_file        	= '/etc/apache2/certs/jiocloud.com.key'
  $ssl_key_file_source 	= "$puppet_master_files/ssl/jiocloud.com.key"
  $ssl_ca_file         	= '/etc/apache2/certs/gd_bundle-g2-g1.crt'
  $ssl_ca_file_source  	= "$puppet_master_files/ssl/gd_bundle-g2-g1.crt"
  $interface_names 	= split($::interfaces, ',')
  $interface_addresses 	= inline_template('<%= @interface_names.reject{ |ifc| ifc == "lo" }.map{ |ifc| scope.lookupvar("ipaddress_#{ifc}") }.join(" ")
%>')
  $ip_array = split($interface_addresses, ' ')
  $compute_nodes           = 'cp'
  $storage_nodes           = "st"
  $contrail_nodes          = "ct"
  Exec { path => $executable_path }
  $host_prefix          = inline_template("<%= @hostname.sub(/^\s*([a-zA-Z\-\.]+)\d+$/,'\1') %>")
  $hgs_to_use_fe_for_connectivity = ['storage_node','database_node','contrail_node']

### base system environment
  $all_nodes_pkgs_to_install    = [ 'vim','htop','ethtool','zabbix-agent','zabbix-sender' ]
  $all_nodes_pkgs_to_remove     = [ 'resolvconf' ]
  $all_nodes_services_to_run    = [ 'sshd' ]
  $ntp_server_servers   = [ '10.204.105.101' ]
  $ntp_servers          = ['i1','i2']
  $dnsdomainname        = 'mu.jio'
  $dnssearch            = [ 'mu.jio' ]
  $dnsservers           = [ '10.135.121.138','10.135.121.107']
  $dns_master_server    = '10.135.121.138'
  $dnsupdate_key        = 'yCGS8t1sIM+FoG3xzYfQRQ=='
  $compute_fe_interface = 'eth2'
  $compute_be_interface = 'eth3'
  $network_device_mtu 	= 9000
  $interfaces_array = split($interfaces,',')

## Apt configs
  $local_repo_ip = '10.135.123.75'
  $apt_sources = {
        precise =>  { location => 'http://10.135.96.60/mirror1/mirror/archive.ubuntu.com/ubuntu', repos => 'main restricted universe multiverse', mirror_url => 'http://archive.ubuntu.com/ubuntu'},
        precise-updates => { location => 'http://10.135.96.60/mirror1/mirror/archive.ubuntu.com/ubuntu',release => 'precise-updates', repos => 'main restricted universe multiverse', mirror_url => 'http://archive.ubuntu.com/ubuntu'},
        puppetlabs => { location => 'http://10.135.96.60/mirror1/mirror/apt.puppetlabs.com', mirror_url => 'http://apt.puppetlabs.com'},
        precise-security => { location => 'http://10.135.96.60/mirror1/mirror/security.ubuntu.com/ubuntu', release => 'precise-security', repos => 'main restricted universe multiverse', mirror_url => 'http://security.ubuntu.com/ubuntu/'},
        zabbix  => { location => 'http://10.135.96.60/mirror1/mirror/repo.zabbix.com/zabbix/2.0/ubuntu', mirror_url => 'http://repo.zabbix.com/zabbix/2.0/ubuntu/' },
        mariadb => { location => 'http://10.135.96.60/mirror1/mirror/mirror.mephi.ru/mariadb/repo/5.5/ubuntu', mirror_url => 'http://mirror.mephi.ru/mariadb/repo/5.5/ubuntu'},
        jenkins => { location => 'http://10.135.96.60/mirror1/mirror/pkg.jenkins-ci.org/debian',repos => '',release => 'binary/', mirror_url => 'http://pkg.jenkins-ci.org/debian'},
        precise-updates-havana => { location => 'http://10.135.96.60/mirror1/mirror/ubuntu-cloud.archive.canonical.com/ubuntu', release => 'precise-updates/havana', mirror_url => 'http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/havana' },
        hp-support-pack => { location => 'http://10.135.96.60/mirror1/mirror/downloads.linux.hp.com/SDR/downloads/ProLiantSupportPack', release => 'lucid', repos => 'current/non-free', mirror_url =>'http://downloads.linux.hp.com/SDR/downloads/ProLiantSupportPack/' },
        hp-mcp  => { location => 'http://10.135.96.60/mirror1/mirror/downloads.linux.hp.com/SDR/downloads/mcp/Debian',repos => 'current/non-free',mirror_url => 'http://downloads.linux.hp.com/SDR/downloads/mcp/ubuntu' },
        fabric => { location => 'http://10.135.96.60/mirror1/mirror/ppa.launchpad.net/chris-lea/fabric/ubuntu', mirror_url => 'http://ppa.launchpad.net/chris-lea/fabric/ubuntu' },
        jiocloud-ppa => { location => 'http://10.135.96.60/mirror1/mirror/ppa.launchpad.net/jiocloud/ppa/ubuntu', mirror_url => 'http://ppa.launchpad.net/jiocloud/ppa/ubuntu' },
        rustedhalo => { location => 'http://10.135.96.60/mirror1/mirror/jiocloud.rustedhalo.com/ubuntu', mirror_url => 'http://jiocloud.rustedhalo.com/ubuntu', environment => ['staging'] },
        ceph-apache => { location => 'http://10.135.96.60/mirror1/mirror/gitbuilder.ceph.com/apache2-deb-precise-x86_64-basic/ref/master', mirror_url => 'http://gitbuilder.ceph.com/apache2-deb-precise-x86_64-basic/ref/master' },
        ceph-fastcgi => { location => 'http://10.135.96.60/mirror1/mirror/gitbuilder.ceph.com/libapache-mod-fastcgi-deb-precise-x86_64-basic/ref/master', mirror_url => 'http://gitbuilder.ceph.com/libapache-mod-fastcgi-deb-precise-x86_64-basic/ref/master' },
        ceph-extras => { location => 'http://10.135.96.60/mirror1/mirror/ceph.com/packages/ceph-extras/debian', mirror_url => 'http://ceph.com/packages/ceph-extras/debian' },
        ceph-emperor => { location => 'http://10.135.96.60/mirror1/mirror/ceph.com/debian-emperor', mirror_url => 'http://ceph.com/debian-emperor/' },
        contrail => { location => 'http://10.135.96.60/mirror1/contrail' },
    }

  $keystone_db_user             = 'keystone'
  $keystone_db_password         = 'keystone@1234'
  $keystone_db_name             = 'keystone'

  $glance_db_user               = 'glance'
  $glance_db_password           = 'glance@1234'
  $glance_db_name               = 'glance'

  $nova_db_user                 = 'nova'
  $nova_db_password             = 'nova@1234'
  $nova_db_name                 = 'nova'

  $cinder_db_user               = 'cinder'
  $cinder_db_password           = 'cinder@1234'
  $cinder_db_name               = 'cinder'

## Mysql environment defaults
  $os_dbs_hash  = {
    novadb   => { db => $nova_db_name, user => $nova_db_user, pass => $nova_db_password },
    keystonedb => { db => $keystone_db_name, user => $keystone_db_user, pass => $keystone_db_password },
    cinderdb => { db => $cinder_db_name, user => $cinder_db_user, pass => $cinder_db_password },
    glancedb => { db => $glance_db_name, user => $glance_db_user, pass => $glance_db_password },
    }

  $db_host_ip		     	= hiera('jiocloud::db_host_ip','0.0.0.0')
  $mysql_server_package_name 	= hiera('jiocloud::db::mysql_server_package_name','mariadb-server')     # Server package to use
  $mysql_client_package_name 	= hiera('jiocloud::db::mysql_client_package_name','mariadb-client')     # Client Package to use 
  $mysql_root_pass 		= hiera('jiocloud::db::mysql_root_pass','ril')                 #mysql root password to set
  $mysql_datadir 		= hiera('jiocloud::db::mysql_datadir','/data')               # mysql data directory
  $mysql_max_connections 	= hiera('jiocloud::db::mysql_max_connections',1024)                  # maximum connections
  $os_dbs			= hiera('jiocloud::db::os_dbs',$os_dbs_hash)
  $other_dbs			= hiera('jiocloud::db::other_dbs',undef) 
  $mysql_data_disk		= hiera('jiocloud::db::mysql_data_disk',undef)

## KVM Environment default 
  $mgmt_vm_virsh_secret_uuid = hiera('jiocloud::kvm::mgmt_vm_virsh_secret_uuid','d5a71695-e4de-45fd-b084-f0af0123fc7d')
  $mgmt_vm_virsh_secret_value = hiera('jiocloud::kvm::mgmt_vm_virsh_secret_uuid','AQCq/iNT2MrcLxAAWU33d+5eftjZA4Ogzmmw4w==')

### Openstack Environment
  $internal_address		= $public_address
  $admin_address		= $public_address
if $ssl_enabled {
  $http_protocol = 'https'
  $glance_registry_listen_port  = 19191
  $glance_api_listen_port       = 19292
  $keystone_public_listen_port  = 15000
  $keystone_admin_listen_port   = 35358
  $cinder_listen_port           = 18776
  $nova_vncproxy_listen_port    = 16080
  $nova_osapi_compute_listen_port       = 18774
  $nova_ec2_listen_port         = 18773

  if $multi_url {
    $keystone_port 	= 443
    $nova_port		= 443
    $glance_port	= 443
    $cinder_port	= 443
    $neutron_port	= 443
  } else {
    $keystone_public_address      = $public_address
    $nova_public_address       = $public_address
    $cinder_public_address       = $public_address
    $glance_public_address       = $public_address
    $keystone_port      = 5000
    $nova_port          = 8774
    $glance_port        = 9292
    $cinder_port        = 8776
    $neutron_port	= 9695
  }
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
  if $multi_url {
    $keystone_port      = 80
    $nova_port          = 80
    $glance_port        = 80
    $cinder_port        = 80
    $neutron_port       = 80
  } else {
    $keystone_public_address      = $public_address
    $nova_public_address       = $public_address
    $cinder_public_address       = $public_address
    $glance_public_address       = $public_address
    $keystone_port      = 5000
    $nova_port          = 8774
    $glance_port        = 9292
    $cinder_port        = 8776
    $neutron_port       = 9697
  }
}

## Package management
  $os_package_ensure	= 'present'
  $keystone_package_ensure = $os_package_ensure
  $nova_package_ensure = $os_package_ensure
  $cinder_package_ensure = $os_package_ensure
  $glance_package_ensure = $os_package_ensure
  $horizon_package_ensure = $os_package_ensure
  $jiocloud_registration_package_ensure = $os_package_ensure

## Database details for openstack	

  $controller_nodes_pkgs_to_install     = ['contrail-openstack-dashboard','qemu-utils','contrail-api-lib','contrail-api-venv','python-neutronclient']


## Global debug configuration
  $verbose                      = false	# Verbose for all openstack services
  $debug                        = false # Debug settings for all openstack services
## End Global debug

### Keystone configuration
## Keystone admin, tenant details
  $admin_password               = 'D0ntKn0w@4589'	# Keystone Admin user password
  $admin_token                  = 'fa791a32703dfda365103109a2fb3581'	# keystone admin token
  $admin_email                  = 'cloud.devops@ril.com' #Keystone Admin user password
  $service_user_password        = 's3cr3t@1234'	# Service user password, this is used by all service users like neutron, nova, glance etc.
  $service_tenant               = 'services'	# Service tenant
  $region                       = 'P1_mum'	# Keystone region
## End Keystone admin, tenant 

  ##Start: Keystone Cache 
  $keystone_cache_enabled       = true
  $keystone_cache_config_prefix = 'cache.keystone'
  $keystone_cache_expiration_time       = 600
  $keystone_cache_backend       = 'dogpile.cache.memcached'
#  $keystone_cache_backend_argument      = 'url:10.135.123.75:11211'
  ## End: Keystone Cache

  $keystone_accepted_roles      = 'Member, admin, swiftoperator,_member_'
  $keystone_token_cache_size    = 500
  $keystone_node                = 't2'
  $keystone_token_format        = 'uuid'

  $keystone_internal_address    = $keystone_public_address
  $keystone_admin_address       = $keystone_internal_address
  $keystone_public_port         = $keystone_port
  $keystone_admin_port          = 35357
  $keystone_protocol            = $http_protocol
  $keystone_version		= 'v2.0'
#  $keystone_url                 = "$keystone_protocol://${keystone_public_address}:${keystone_public_port}/${keystone_version}"
#  $keystone_public_url          = "$keystone_protocol://${keystone_public_address}:${keystone_public_port}/${keystone_version}"
#  $keystone_internal_url        = "$keystone_protocol://${keystone_internal_address}:${keystone_port}/${keystone_version}"
#  $keystone_admin_url           = "$keystone_protocol://${keystone_admin_address}:${keystone_admin_port}/${keystone_version}"

  $vncproxy_protocol		= $http_protocol

  $neutron_public_address       = $neutron_address
  $neutron_internal_address     = $neutron_public_address
  $neutron_admin_address        = $neutron_internal_address
  $neutron_public_port          = $neutron_port
  $neutron_internal_port        = $neutron_public_port
  $neutron_protocol		= $http_protocol
#  $neutron_internal_url         = "${neutron_protocol}://${neutron_internal_address}:${neutron_internal_port}/"

  $nova_internal_address     = $nova_public_address
  $nova_admin_address        =  $nova_internal_address
  $nova_public_port          = $nova_port
  $nova_protocol		= $http_protocol
  $nova_port_to_apache          = false

  $volume_tmp_dir	= '/var/tmp'
  $cinder_internal_address     = $cinder_public_address
  $cinder_admin_address        = $cinder_internal_address
  $cinder_protocol		= $http_protocol
  $cinder_public_port          = $cinder_port

  $glance_internal_address     = $glance_public_address
  $glance_admin_address        = $glance_internal_address
  $glance_public_port          = $glance_port
  $glance_protocol       = $http_protocol
  $glance_public_protocol       = $glance_protocol

  $keystone_ceph_enabled                = true


## nova.conf entries
  $nova_use_syslog           = false
  $nova_syslog_log_facility  = 'LOG_LOCAL0'
  $nova_neutron_metadata_proxy_shared_secret    = '0ef66574-5b70-4be5-ab98-384809024f9e'
  $nova_workers                 = '2'
  $neutron_libvirt_vif_driver   = 'contrail_vif.contrailvif.VRouterVIFDriver'
  $nova_rpc_backend             = 'nova.rpc.impl_zmq'
  $nova_glance_api_servers      = "$glance_public_protocol://$glance_public_address:$glance_public_port"
  $rpc_zmq_ipc_dir              = '/var/run/openstack'
  $matchmaker_ringfile          = '/etc/matchmaker/matchmaker.json'
  $os_controller_nodes          = $controller_nodes
#  $os_mgmt_nodes                = ['t2oc1']     ## Nodes on which puppet manifests for certain central openstack management
  $cinder_api_nodes             = $os_controller_nodes
  $cinder_rpc_backend           = 'cinder.openstack.common.rpc.impl_zmq'

  $glance_nodes                 = $os_controller_nodes
  $glance_backend               = 'rbd'
  $glance_rbd_store_user        = 'glance'
  $glance_rbd_store_pool        = 'images'

  $cinder_volume_rbd_pool       = 'volumes'
  $cinder_volume_rbd_user       = 'cinder_volume'
  $cinder_rbd_secret_uuid       = 'f754bfa3-97bd-4673-bf0d-531eeb57af4f'
#  $compute_nodes                = ['t2']
  $nova_api_nodes               = $os_controller_nodes
  $nova_cert_nodes              = $os_controller_nodes
  $nova_consoleauth_nodes       = $os_controller_nodes
  $nova_scheduler_nodes         = $os_controller_nodes
  $conductor_nodes              = $os_controller_nodes
  $cinder_volume_nodes          = $os_controller_nodes
  $cinder_backup_nodes          = $cinder_volume_nodes
  $cinder_scheduler_nodes       = $os_controller_nodes
  $nova_vncproxy_nodes          = $os_controller_nodes

  $nova_conductor_workers       = 3
  $nova_conductor_use_local     = false

  $quota_instances              = 45
  $quota_cores                  = 90
  $quota_ram                    = 409600
  $quota_volumes                = 20
  $quota_gigabytes              = 5120
  $quota_floating_ips           = 10
  $quota_max_injected_files     = 5
  $quota_security_groups        = 10
  $quota_security_group_rules   = 50
  $quota_key_pairs              = 50

  $vncserver_proxyclient_interfaces     = ['br0','eth3']
  $vncproxy_host                = $nova_public_address
  $virtio_nic                   = true
  $neutron_enabled              = true

### Starting with standalone memcached; multi node memcached cluster tobe setup for scaleout and reliability
#  $memcached_nodes              = ['t2']
  $memcached_listen             = '0.0.0.0'
  $memcached_port               = '11211'
  $memcached_max_memory         = 5120
#  $memcached_server_url         = ['10.135.123.75:11211']

  $horizon_secret_key           = $service_user_password
  $horizon_api_result_limit     = 2000
  $horizon_ssl_enabled          = $ssl_enabled ## Setting up false now, will enable ssl after initial implementation
  $horizon_allowed_fqdn         = [$public_address]
#  $nova_physical_volumes             = ['/dev/sdc','/dev/sdd','/dev/sde']
#,'/dev/sdf','/dev/sdg','/dev/sdh','/dev/sdi','/dev/sdj','/dev/sdk','/dev/sdl','/dev/sdm','/dev/sdn','/dev/sdo','/dev/sdp','/dev/sdq','/dev/sdr','/dev/sds','/dev/sdt','/dev/sdu','/dev/sdv','/dev/sdw']
  $nova_volume_group            = 'Nova_Volumes'
  $nova_logical_volume		= 'nova'
  $nova_libvirt_images_type     = 'raw'

  $nova_snapshot_image_format   = 'qcow2'

## Ceph params
  if $ssl_enabled {
    $ceph_radosgw_listen_ssl      = true
    $ceph_radosgw_protocol	= 'https'
    $ceph_radosgw_public_port     = 443
  } else {
    $ceph_radosgw_listen_ssl      = false
    $ceph_radosgw_protocol	= 'http'
    $ceph_radosgw_public_port     = 80
  } 
  $ceph_auth_type               = 'cephx'
  $ceph_mon_port                = '6789'
  $ceph_radosgw_admin_port      = $ceph_radosgw_public_port
  $ceph_radosgw_internal_port   = $ceph_radosgw_public_port
  $ceph_osd_journal_type        = 'first_partition'     ## first_partition -> first partition of the data disk, filesystem -> journal directory under individual disk filesystem, /dev/sdx (device name) - separate journal disk (not implemented)
  $ceph_osd_journal_size        = 10            ## Journal size in GiB, only numaric part, no unit, only applicable for 'first_partition'
  $ceph_keyring                 = '/etc/ceph/keyring'
  $ceph_radosgw_enabled         = true
  $ceph_radosgw_log_file                = '/var/log/ceph/radosgw.log'
  $ceph_radosgw_serveradmin_email       = 'cloud.devops@ril.com'
  $ceph_radosgw_fastcgi_ext_script      = '/var/www/s3gw.fcgi'
  $ceph_radosgw_socket          = '/var/run/ceph/radosgw.sock'
  $ceph_radosgw_fastcgi_ext_script_source       = "$puppet_master_files/ceph/_var_www_s3gw.fcgi"
  $ceph_radosgw_keyring         = '/etc/ceph/keyring.radosgw.gateway'
  $ceph_radosgw_apache_version  = '2.2.22-2precise.ceph'
  $ceph_radosgw_apache_deps     = ['apache2.2-common','apache2.2-bin']
  $ceph_glance_keyring          = '/etc/ceph/keyring.ceph.client.glance'
  $ceph_cinder_volume_keyring   = '/etc/ceph/keyring.ceph.client.cinder_volume'
  $ceph_cinder_backup_keyring   = '/etc/ceph/keyring.ceph.client.cinder_backup'
  $ceph_mgmt_vm_keyring         = '/etc/ceph/keyring.ceph.client.mgmt_vm'

  $ceph_pool_cinder_volume      = 'volumes'
  $ceph_pool_cinder_backup      = 'backups'
  $ceph_pool_glance_image       = 'images'

  $ceph_pools_to_add            = [ $ceph_pool_cinder_volume, $ceph_pool_cinder_backup, $ceph_pool_glance_image ]
  $ceph_pool_number_of_pgs      = 128
 
}


