### class: jiocloud::openstack
class jiocloud::openstack (
  $iam_os_controller_node = $jiocloud::params::iam_os_controller_node,
) {
  if $iam_os_controller_node {
    class {'jiocloud::openstack::nova':}
    class {'jiocloud::openstack::dashboard':}
    class {'jiocloud::openstack::apache':}
  }
}
