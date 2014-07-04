### class: jiocloud::openstack
class jiocloud::openstack (
  $iam_os_controller_node = $jiocloud::params::iam_os_controller_node,
  $iam_os_compute_node = $jiocloud::params::iam_os_compute_node,
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

}
