### class: jiocloud::memcache
class jiocloud::memcached (
  $memcached_listen = $jiocloud::params::memcached_listen,
  $memcached_port =  $jiocloud::params::memcached_port,
  $memcached_max_memory = $jiocloud::params::memcached_max_memory,
) {
    class { '::memcached':
      listen_ip       => $memcached_listen,
      tcp_port        => $memcached_port,
      udp_port        => $memcached_port,
      max_memory      => $memcached_max_memory,
    }
}
