###Class: jiocloud::ceph
class jiocloud::ceph (
  $ceph_pools_to_add = $jiocloud::params::ceph_pools_to_add,
  $ceph_pool_number_of_pgs = $jiocloud::params::ceph_pool_number_of_pgs,
  $ceph_osds = $jiocloud::params::ceph_osds,
  $ceph_radosgw_nodes = $jiocloud::params::ceph_radosgw_nodes,
  $ceph_mon_nodes = $jiocloud::params::ceph_mon_nodes,
  $iam_compute_node = $jiocloud::params::iam_compute_node,
  $iam_os_controller_node = $jiocloud::params::iam_os_controller_node,
  $ceph_mon_initial_members = $jiocloud::params::ceph_mon_initial_members,
  $ceph_fsid = $jiocloud::params::ceph_fsid,
  $ceph_auth_type = $jiocloud::params::ceph_auth_type,
  $ceph_storage_cluster_network = $jiocloud::params::ceph_storage_cluster_network,
  $ceph_public_network = $jiocloud::params::ceph_public_network,
  $ceph_osd_journal_type = $jiocloud::params::ceph_osd_journal_type,
  $ceph_mon_key = $jiocloud::params::ceph_mon_key,
  $ceph_mon_port = $jiocloud::params::ceph_mon_port,
  $ceph_mon_ip = $jiocloud::params::ceph_mon_ip,
  $ceph_public_address = $jiocloud::params::ceph_public_address,
  $ceph_cluster_address = $jiocloud::params::ceph_cluster_address,
  $ceph_osd_journal_type = $jiocloud::params::ceph_osd_journal_type,
  $ceph_osd_journal_size = $jiocloud::params::ceph_osd_journal_size,
)
{ 
  ##
  $st_sysctl_settings = {
  "vm.dirty_background_ratio"          => { value => 5 },
  }


  ##### Conditional application of role based classes

  file {'/etc/ceph':
    ensure => directory,
  }

  class { 'jiocloud::ceph::config': }

  if $jiocloud::params::hostname_lc in downcase($ceph_mon_nodes) {
    ::ceph::mon { "$jiocloud::params::hostname_lc":
      monitor_secret => $ceph_mon_key,
      mon_port       => $ceph_mon_port,
      mon_addr       => $ceph_mon_ip,
    }
    jiocloud::ceph::auth::add_ceph_auth {'admin': }
    add_ceph_pools { $ceph_pools_to_add: num_pgs => $ceph_pool_number_of_pgs,  }
  }

  if $jiocloud::params::hostname_lc in downcase($ceph_radosgw_nodes) {
    class { 'jiocloud::ceph::radosgw': }
  }
  
  
  
  if $iam_storage_node {
    if is_hash($ceph_osds) {
      create_resources(add_ceph_osd,$ceph_osds)
    }
    create_resources(sysctl::value,$st_sysctl_settings)	
  }

  define add_ceph_pools (
    $num_pgs,
  ) {
    exec { "add_ceph_pool_${name}":
      command	=> "ceph osd pool create $name $num_pgs",
      unless	=> "ceph osd lspools | grep \"\\<[0-9][0-9]* *$name\\>\""
    }
  }

  define add_ceph_osd ($disks) {
    if $name == $hostname {
      class { '::ceph::osd' :
	public_address => $ceph_public_address,
	cluster_address => $ceph_cluster_address,
      }
      add_osds { $disks: }
    }
  }

  define add_osds {
    ::ceph::osd::device { $name: 
      osd_journal_type 	=> $ceph_osd_journal_type,
      osd_journal_size 	=> $ceph_osd_journal_size,
    }
  }

  ## End of ceph_setup
}


  
