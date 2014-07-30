class jiocloud {
### Define stages
  stage { 'init':
    before => Stage['main'],
  }
  stage { 'finish': }
  Stage['main'] -> Stage['finish']
  

## Load params
  class {'jiocloud::params':}
  Exec { path => $jiocloud::params::executable_path }
## system ops
  class {'jiocloud::system':}
## DB server and client setup
  class {'jiocloud::db':
    require => Class['jiocloud::system'],
  }
##Setup openstack on openstack nodes.
  if $jiocloud::params::iam_os_controller_node or $jiocloud::params::iam_compute_node {
    class {'jiocloud::openstack':
      require => Class['jiocloud::system::stage1'],
    }
  }

## Setup memcached on memcache server
  if $jiocloud::params::iam_memcached_node == 'true' {
    class {'jiocloud::memcached':
      require => Class['jiocloud::system'],
    }
  }
  
  if $jiocloud::params::iam_compute_node or $jiocloud::params::iam_contrail_node {
    class {'jiocloud::contrail':}
  }
## setup ceph 
  if $jiocloud::params::iam_compute_node or $jiocloud::params::iam_os_controller_node or $jiocloud::params::iam_storage_node {
    class {'jiocloud::ceph':
      require => Class['jiocloud::system'],
    }
  }
}
