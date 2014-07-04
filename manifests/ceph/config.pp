##Class jiocloud::ceph::config
class jiocloud::ceph::config (
  $ceph_mon_initial_members = $jiocloud::params::ceph_mon_initial_members,
  $ceph_mon_config = $jiocloud::params::ceph_mon_config,
  $ceph_admin_key = $jiocloud::params::ceph_admin_key,
  $ceph_keyring  = $jiocloud::params::ceph_keyring,
  $ceph_fsid  = $jiocloud::params::ceph_fsid,
  $ceph_auth_type  = $jiocloud::params::ceph_auth_type,
  $ceph_storage_cluster_network  = $jiocloud::params::ceph_storage_cluster_network,
  $ceph_public_network = $jiocloud::params::ceph_public_network,
  $ceph_osd_journal_type   = $jiocloud::params::ceph_osd_journal_type,
) {
    $ceph_mon_initial_members_str = join($ceph_mon_initial_members,',')
    class { '::ceph::conf':
      fsid            => $ceph_fsid,
      auth_type       => $ceph_auth_type,
      cluster_network => $ceph_storage_cluster_network,
      public_network  => $ceph_public_network,
      mon_init_members 	=> $ceph_mon_initial_members_str,
      osd_journal_type	=> $ceph_osd_journal_type,
    }
    if is_hash($ceph_mon_config) {
      create_resources(::ceph::conf::mon_config,$ceph_mon_config)
    }

    ::ceph::conf::clients {'cinder_volume':
      keyring	=> '/etc/ceph/keyring.ceph.client.cinder_volume',
    }

    ::ceph::conf::clients {'cinder_backup':
      keyring => '/etc/ceph/keyring.ceph.client.cinder_backup',
    }

    ::ceph::conf::clients {'glance':
      keyring => '/etc/ceph/keyring.ceph.client.glance',
    }

    ::ceph::conf::clients {'mgmt_vm':
      keyring => '/etc/ceph/keyring.ceph.client.mgmt_vm',
    }

    if !empty($ceph_admin_key) {
      ::ceph::key { 'admin':
        secret       => $ceph_admin_key,
        keyring_path => $ceph_keyring,
      }
    }
}
