### class: jiocloud::openstack
class jiocloud::openstack (
  $iam_os_controller_node = $jiocloud::params::iam_os_controller_node,
  $iam_compute_node = $jiocloud::params::iam_compute_node,
) {
  class { 'jiocloud::openstack::prereq':
    stage => 'init',
  } 
  if $iam_os_controller_node {
    class {'jiocloud::openstack::apache':}
    class {'jiocloud::openstack::keystone':}
    class {'jiocloud::openstack::dashboard':}
    class {'jiocloud::openstack::cinder':}
    class {'jiocloud::openstack::glance':}
    class {'jiocloud::openstack::nova':}
  } elsif $iam_compute_node { 
  class {'jiocloud::openstack::nova':}
  }

}
