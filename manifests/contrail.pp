### Setting up contrail
class jiocloud::contrail ( 
### Define variables Here
  $iam_os_compute_node     =   $jiocloud::params::iam_compute_node,
  $vrouter_interface       =   $jiocloud::params::vrouter_interface,
  $vrouter_physical_interface = $jiocloud::params::vrouter_physical_interface,
  $vrouter_ip              =   $jiocloud::params::contrail_vrouter_ip,
  $vrouter_num_controllers = $jiocloud::params::contrail_vrouter_num_controllers,
  $edge_router_address		   = $jiocloud::params::contrail_edge_router_address
  $discovery_server        =   $jiocloud::params::contrail_discovery_server,
  $vrouter_mac             =   $jiocloud::params::contrail_vrouter_mac,
  $vrouter_gw              =   $jiocloud::params::contrail_vrouter_gw,
  $vrouter_cidr            =   $jiocloud::params::contrail_vrouter_cidr,
  $metadata_proxy_shared_secret    = $jiocloud::params::nova_neutron_metadata_proxy_shared_secret,
  $vrouter_file_source = $jiocloud::params::vrouter_file_source,
  $vrouter_file = $jiocloud::params::vrouter_file,
){
##### Conditional application of role based classes
  
# if iam_os_compute_node {  
#	class {'::role_contrail_vrouter':}
#  }
 class {'::contrail':
        vrouter_interface       => $vrouter_interface,
        vrouter_ip              => $vrouter_ip,
        discovery_server        => $discovery_server,
        vrouter_mac             => $vrouter_mac,
        vrouter_gw              => $vrouter_gw,
        vrouter_cidr            => $vrouter_cidr,
        vrouter_physical_interface => $vrouter_physical_interface,
        metadata_proxy_shared_secret    => $metadata_proxy_shared_secret,
	vrouter_num_controllers => $vrouter_num_controllers,
 	edge_router_address    => $edge_router_address
   }

  file { ['/lib/modules',"/lib/modules/3.2.0-59-virtual","/lib/modules/3.2.0-59-virtual/extra","/lib/modules/3.2.0-59-virtual/extra/net","/lib/modules/3.2.0-59-virtual/extra/net/vrouter"]:
        ensure  => directory,
        before  => File ["$vrouter_file"],
  }
  file { "$vrouter_file":
    ensure        => file,
    owner         => root,
    group         => root,
    mode          => 644,
    source        => "$vrouter_file_source",
  }

## End of contrail_setup
}

  
##### Setting up role based classes
