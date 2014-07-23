###Class: jiocloud::ceph
class jiocloud::ceph (
  $ceph_pools_to_add = $jiocloud::params::ceph_pools_to_add,
  $ceph_pool_number_of_pgs = $jiocloud::params::ceph_pool_number_of_pgs,
  $ceph_osds = $jiocloud::params::ceph_osds,
  $ceph_radosgw_nodes = $jiocloud::params::ceph_radosgw_nodes,
  $ceph_mon_nodes = $jiocloud::params::ceph_mon_nodes,
  $iam_compute_node = $jiocloud::params::iam_compute_node,
  $iam_storage_node = $jiocloud::params::iam_storage_node,
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
      create_resources(add_ceph_osd,$ceph_osds,{osd_journal_type => $ceph_osd_journal_type, osd_journal_size => $ceph_osd_journal_size, public_address => $ceph_public_address, cluster_address => $ceph_cluster_address})
    }
    create_resources(sysctl::value,$st_sysctl_settings)	
    exec { "cleanup_caches":
        command => "awk 'BEGIN {s=0} /DMA32|Normal/ { if (\$9+\$10+\$11+\$12+\$13+\$14+\$15 < 100) {s=1} } END {if (s == 1) system (\"/bin/sync && /bin/echo 1 > /proc/sys/vm/drop_caches\")  }' /proc/buddyinfo",
    }
  }

  define add_ceph_pools (
    $num_pgs,
  ) {
    exec { "add_ceph_pool_${name}":
      command	=> "ceph osd pool create $name $num_pgs",
      unless	=> "ceph osd lspools | grep \"\\<[0-9][0-9]* *$name\\>\""
    }
  }

  define add_ceph_osd (
    $disks,
    $public_address = $ceph_public_address,
    $cluster_address = $ceph_cluster_address,
    $osd_journal_type = $ceph_osd_journal_type,
    $osd_journal_size  = $ceph_osd_journal_size,
) {
    if $name == $hostname {
      class { '::ceph::osd' :
	public_address => $public_address,
	cluster_address => $cluster_address,
      }
      add_osds { $disks: 
  	osd_journal_type => $osd_journal_type,
	osd_journal_size  => $osd_journal_size
      }
    }
  }
  define add_osds (
    $osd_journal_type,
    $osd_journal_size,
  ) {
    ::ceph::osd::device { $name: 
      osd_journal_type 	=> $osd_journal_type,
      osd_journal_size 	=> $osd_journal_size,
    }
  }

## Running ceph::key with fake secret with admin just to satisfy condition in ceph module
  ::ceph::key { 'admin':
          secret       => 'AQCNhbZTCKXiGhAAWsXesOdPlNnUSoJg7BZvsw==',
        }
  ## End of ceph_setup
}


  
