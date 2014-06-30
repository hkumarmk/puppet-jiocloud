## Class: jiocloud::openstack::nova

class jiocloud::openstack::nova (
  $iam_compute_node = $jiocloud::params::iam_compute_node,
  $iam_os_controller_node = $jiocloud::params::iam_os_controller_node,
  $nova_vncproxy_nodes = $jiocloud::params::nova_vncproxy_nodes,
  $nova_api_nodes = $jiocloud::params::nova_api_nodes,
  $nova_scheduler_nodes = $jiocloud::params::nova_scheduler_nodes,
  $nova_consoleauth_nodes = $jiocloud::params::nova_consoleauth_nodes,
  $conductor_nodes = $jiocloud::params::conductor_nodes,
  $nova_cert_nodes = $jiocloud::params::nova_cert_nodes,
  $cinder_volume_nodes = $jiocloud::params::cinder_volume_nodes,
  $cinder_scheduler_nodes = $jiocloud::params::cinder_scheduler_nodes,
) {
  if $iam_compute_node {
    class { 'jiocloud::openstack::nova::compute': }
  } elsif $iam_os_controller_node {
      class { 'jiocloud::openstack::nova::controller':}
  }  
  if $iam_compute_node or $iam_os_controller_node {
    class { '::nova::zeromq': }
  }
}
