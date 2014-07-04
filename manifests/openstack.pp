### class: jiocloud::openstack
class jiocloud::openstack (
  $iam_os_controller_node = $jiocloud::params::iam_os_controller_node,
  $iam_os_compute_node = $jiocloud::params::iam_os_compute_node,
  $memcached_nodes = $jiocloud::params::memcached_nodes,
  $memcached_listen = $jiocloud::params::memcached_listen,
  $memcached_port =  $jiocloud::params::memcached_port,
  $memcached_max_memory = $jiocloud::params::memcached_max_memory,
) {
  if $iam_os_controller_node {
    class {'jiocloud::openstack::keystone':}
    class {'jiocloud::openstack::dashboard':}
    class {'jiocloud::openstack::apache':}
    class {'jiocloud::openstack::cinder':}
    class {'jiocloud::openstack::glance':}
    class {'jiocloud::openstack::nova':}
  } elsif $iam_os_compute_node { 
  class {'jiocloud::openstack::nova':}
  }

  if downcase($hostname) in downcase($memcached_nodes) {
    class { 'memcached':
      listen_ip       => $memcached_listen,
      tcp_port        => $memcached_port,
      udp_port        => $memcached_port,
      max_memory      => $memcached_max_memory,
    }
  }
}
