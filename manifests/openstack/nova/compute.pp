## Class: jiocloud::openstack::nova::compute

class jiocloud::openstack::nova::compute (
  $vncserver_proxyclient_address   = $jiocloud::params::vncserver_proxyclient_address,
  $vncproxy_host           = $jiocloud::params::vncproxy_host,
  $vncproxy_protocol       = $jiocloud::params::vncproxy_protocol,
  $virtio_nic              = $jiocloud::params::virtio_nic,
  $neutron_enabled         = $jiocloud::params::neutron_enabled,
  $network_device_mtu      = $jiocloud::params::network_device_mtu,
  $enable_migration	  = $jiocloud::params::nova_enable_migration,
  $nova_libvirt_images_type = $jiocloud::params::nova_libvirt_images_type,
  $nova_snapshot_image_format = $jiocloud::params::nova_snapshot_image_format,
  $neutron_libvirt_vif_driver = $jiocloud::params::neutron_libvirt_vif_driver,
  $nova_volume_group  = $jiocloud::params::nova_volume_group,
  $nova_physical_volumes = $jiocloud::params::nova_physical_volumes,
  $nova_logical_volume = $jiocloud::params::nova_logical_volume,
  $cinder_rbd_secret_uuid = $jiocloud::params::cinder_rbd_secret_uuid,
  $nova_db_url = $jiocloud::params::nova_db_url,
  $ceph_mon_key = $jiocloud::params::ceph_mon_key,
) {
  package { 'ceph-common':
    ensure  => 'installed',
  }

  jiocloud::ceph::auth::add_ceph_auth {'cinder_volume':
    file_owner => 'nova',
  }
  jiocloud::ceph::auth::add_ceph_auth {'mgmt_vm':}

  package {'python-six': ensure => 'latest', }
  class { 'nova::client': }
  class { 'nova::scheduler': enabled	=> false, }	
  
  class { '::nova':
    database_connection     => "mysql://${nova_db_user}:${nova_db_password}@${nova_db_url}/${nova_db_name}?charset=utf8",
    rpc_backend             => $nova_rpc_backend,
    glance_api_servers      => $nova_glance_api_servers,
    glance_protocol         => $glance_protocol,
    rpc_zmq_ipc_dir         => $rpc_zmq_ipc_dir,
    matchmaker_ringfile     => $matchmaker_ringfile,
    verbose                 => $verbose,
    debug                   => $debug,
    use_syslog              => $nova_use_syslog,
    log_facility            => $nova_syslog_log_facility,
  }
    
  class { '::nova::compute':
    enabled                 => true,
    vncserver_proxyclient_address   => $vncserver_proxyclient_address,
    vncproxy_host           => $vncproxy_host,
    vncproxy_protocol       => $vncproxy_protocol,
    virtio_nic              => $virtio_nic,
    neutron_enabled         => $neutron_enabled,
    network_device_mtu      => $network_device_mtu,
  }

  ### Enabling vm migration support
  class { '::nova::compute::libvirt':
    migration_support => $enable_migration,
    vncserver_listen => '0.0.0.0',
    libvirt_images_type => $nova_libvirt_images_type,
    snapshot_image_format => $nova_snapshot_image_format,
  }

  class { '::nova::compute::neutron':
    libvirt_vif_driver      => $neutron_libvirt_vif_driver
  }
  
  class { '::nova::network::neutron':
    neutron_admin_password		=> $service_user_password,
    neutron_url			=> $neutron_internal_url,
    neutron_admin_tenant_name	=> $service_tenant,
    neutron_region_name		=> $region,
    neutron_admin_auth_url	=> $keystone_internal_url,
    neutron_url_timeout		=> $neutron_url_timeout,
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
    command => "mkdir -p /var/lib/nova/instances; mount /dev/${nova_volume_group}/${nova_logical_volume}",
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
    command => "echo \"<secret ephemeral='no' private='no'><uuid>$cinder_rbd_secret_uuid</uuid><usage type='ceph'><name>client.cinder_volume</name></usage></secret>\" > /tmp/secret.xml_${cinder_rbd_secret_uuid} && virsh secret-define --file /tmp/secret.xml_${cinder_rbd_secret_uuid} && rm -f /tmp/secret.xml_${cinder_rbd_secret_uuid}",
    unless => "virsh secret-list | egrep $cinder_rbd_secret_uuid",
  }

  exec { "secret_set_value_cinder_volume":
    command => "ceph-authtool /tmp/.exec_add_ceph_auth_admin_${cinder_rbd_secret_uuid}.tmp \
      --create-keyring \
      --name=mon. \
      --add-key='${ceph_mon_key}' \
      --cap mon 'allow *' && virsh secret-set-value --secret $cinder_rbd_secret_uuid --base64 $(ceph --name mon. --keyring /tmp/.exec_add_ceph_auth_admin_${cinder_rbd_secret_uuid}.tmp \
      auth get-or-create-key client.cinder_volume) && rm -f /tmp/.exec_add_ceph_auth_admin_${cinder_rbd_secret_uuid}.tmp",
    unless => "ceph-authtool /tmp/.exec_add_ceph_auth_test_${cinder_rbd_secret_uuid}.tmp \
      --create-keyring \
      --name=mon. \
      --add-key='${ceph_mon_key}' \
      --cap mon 'allow *' && ceph --name mon. --keyring /tmp/.exec_add_ceph_auth_test_${cinder_rbd_secret_uuid}.tmp \
      auth get-or-create-key client.cinder_volume |grep '$(virsh -q secret-get-value $cinder_rbd_secret_uuid)'",
    require => Exec["secret_define_cinder_volume"],
    notify => Service ['libvirt'],
  }

}
