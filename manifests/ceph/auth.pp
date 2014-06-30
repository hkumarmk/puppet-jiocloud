## Class: jiocloud::ceph::auth

class jiocloud::ceph::auth {
  
  define add_ceph_auth ( 
    $ceph_mon_key = $jiocloud::params::ceph_mon_key,
    $client = $name,
    $file_owner = "root",
    $keyring = "/etc/ceph/keyring.ceph.client.${name}",
  ) {
    if $client == "cinder_volume" {
      exec { "exec_add_ceph_auth_${client}":
	command => "ceph-authtool /tmp/.exec_add_ceph_auth_admin_${client}.tmp \
	  --create-keyring \
	  --name=mon. \
	  --add-key='${ceph_mon_key}' \
	  --cap mon 'allow *' && ceph-authtool $keyring \
	  --create-keyring \
	  --name=client.$client \
	  --add-key \
	  $(ceph --name mon. --keyring /tmp/.exec_add_ceph_auth_admin_${client}.tmp \
	  auth get-or-create-key client.${client}  \
	  mon 'allow r' \
	  osd 'allow class-read object_prefix rbd_children, allow rwx pool=volumes, allow rx pool=images' ) && rm -f /tmp/.exec_add_ceph_auth_admin_${client}.tmp ",
	unless  => "ceph -n client.$client --keyring $keyring osd stat",
      }
    } elsif $client == 'cinder_backup' {
      exec { "exec_add_ceph_auth_${client}":
	command => "ceph-authtool /tmp/.exec_add_ceph_auth_admin_${client}.tmp \
	  --create-keyring \
	  --name=mon. \
	  --add-key='${ceph_mon_key}' \
	  --cap mon 'allow *' && ceph-authtool $keyring \
	  --create-keyring \
	  --name=client.$client \
	  --add-key \
	  $(ceph --name mon. --keyring /tmp/.exec_add_ceph_auth_admin_${client}.tmp \
	  auth get-or-create-key client.${client}  \
	  mon 'allow r' \
	  osd 'allow class-read object_prefix rbd_children, allow rwx pool=backups' ) && rm -f /tmp/.exec_add_ceph_auth_admin_${client}.tmp ",
	unless  => "ceph -n client.$client --keyring $keyring osd stat",
      }
    } elsif $client == 'admin' {
      exec { "exec_add_ceph_auth_${client}":
	command => "ceph-authtool /tmp/.exec_add_ceph_auth_admin_${client}.tmp \
	  --create-keyring \
	  --name=mon. \
	  --add-key='${ceph_mon_key}' \
	  --cap mon 'allow *' && ceph-authtool $keyring \
	  --create-keyring \
	  --name=client.$client \
	  --add-key \
	  $(ceph --name mon. --keyring /tmp/.exec_add_ceph_auth_admin_${client}.tmp \
	  auth get-or-create-key client.${client}  \
	  mon 'allow *' \
	  osd 'allow *' \
	  mds allow ) && rm -f /tmp/.exec_add_ceph_auth_admin_${client}.tmp ",
	unless  => "ceph -n client.$client --keyring $keyring osd stat",
      }
    } elsif $client == 'glance' {
      exec { "exec_add_ceph_auth_${client}":
	command => "ceph-authtool /tmp/.exec_add_ceph_auth_admin_${client}.tmp \
	  --create-keyring \
	  --name=mon. \
	  --add-key='${ceph_mon_key}' \
	  --cap mon 'allow *' && ceph-authtool $keyring \
	  --create-keyring \
	  --name=client.$client \
	  --add-key \
	  $(ceph --name mon. --keyring /tmp/.exec_add_ceph_auth_admin_${client}.tmp \
	  auth get-or-create-key client.${client}  \
	  mon 'allow r' \
	  osd 'allow class-read object_prefix rbd_children, allow rwx pool=images' ) && rm -f /tmp/.exec_add_ceph_auth_admin_${client}.tmp ",
	unless  => "ceph -n client.$client --keyring $keyring osd stat",
      }
    } elsif  $client == 'mgmt_vm' {
      exec { "exec_add_ceph_auth_${client}":
	command => "ceph-authtool /tmp/.exec_add_ceph_auth_admin_${client}.tmp \
	  --create-keyring \
	  --name=mon. \
	  --add-key='${ceph_mon_key}' \
	  --cap mon 'allow *' && ceph-authtool $keyring \
	  --create-keyring \
	  --name=client.$client \
	  --add-key \
	  $(ceph --name mon. --keyring /tmp/.exec_add_ceph_auth_admin_${client}.tmp \
	  auth get-or-create-key client.${client}  \
	  mon 'allow r' \
	  osd 'allow class-read object_prefix rbd_children, allow rwx pool=mgmt_vm_images' ) && rm -f /tmp/.exec_add_ceph_auth_admin_${client}.tmp ",
	unless  => "ceph -n client.$client --keyring $keyring osd stat",
      }
    }
    file { $keyring:
      owner   => $file_owner,
      group   => $file_owner,
      mode    => '0660',
      require => Exec["exec_add_ceph_auth_${client}"],
    }
  } 
}

