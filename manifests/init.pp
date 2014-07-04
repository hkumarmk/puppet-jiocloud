class jiocloud {
## Load params
  class {'jiocloud::params':}
  Exec { path => $jiocloud::params::executable_path }
## system ops
  class {'jiocloud::system':}
## DB server and client setup
  class {'jiocloud::db':}
##Setup openstack on openstack nodes.
  if $jiocloud::params::iam_os_controller_node or $jiocloud::params::iam_os_compute_node {
    class {'jiocloud::openstack':}
  }

  if $jiocloud::params::iam_memcached_node == 'true' {
    class {'jiocloud::memcached':}
  }
notify {"memcache - $jiocloud::params::iam_memcached_node":}
}
