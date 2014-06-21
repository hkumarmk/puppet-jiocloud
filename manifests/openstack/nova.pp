## Class: jiocloud::openstack::nova

class jiocloud::openstack::nova (

) {
  if is_array($compute_nodes) and $hostname in $compute_nodes  or $compute_nodes and $compute_nodes == $host_prefix {
    package { 'ceph-common': ensure	=> 'installed', }
      jiocloud::ceph::keyring::add_ceph_auth_cinder_volume {'cinder_volume':
      file_owner => 'nova',	
    }
    add_ceph_auth_mgmt_vm {'mgmt_vm':}
  }
   
}
