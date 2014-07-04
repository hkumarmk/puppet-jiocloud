### Setting up contrail
class jiocloud::contrail ( 
### Define variables Here
  $iam_os_compute_node     =   $jiocloud::params::iam_os_compute_node,
  $vrouter_interface       =   $jiocloud::params::vrouter_interface,
  $vrouter_ip              =   $jiocloud::params::contrail_vrouter_ip,
  $discovery_server        =   $jiocloud::params::contrail_discovery_server,
  $vrouter_mac             =   $jiocloud::params::contrail_vrouter_mac,
  $vrouter_gw              =   $jiocloud::params::contrail_vrouter_gw,
  $vrouter_cidr            =   $jiocloud::params::contrail_vrouter_cidr,
  $metadata_proxy_shared_secret    = $jiocloud::params::nova_neutron_metadata_proxy_shared_secret
){
##### Conditional application of role based classes
  
# if iam_os_compute_node {  
#	class {'::role_contrail_vrouter':}
#  }
 class {'::contrail':
        vrouter_interface       => $contrail_vrouter_interface,
        vrouter_ip              => $contrail_vrouter_ip,
        discovery_server        => $contrail_discovery_server,
        vrouter_mac             => $contrail_vrouter_mac,
        vrouter_gw              => $contrail_vrouter_gw,
        vrouter_cidr            => $contrail_vrouter_cidr,
        metadata_proxy_shared_secret    => $metadata_proxy_shared_secret,

   }

  file { ['/lib/modules',"/lib/modules/$kernelrelease","/lib/modules/${kernelrelease}/extra","/lib/modules/$kernelrelease/extra/net","/lib/modules/$kernelrelease/extra/net/vrouter"]:
        ensure  => directory,
        before  => File ["/lib/modules/${kernelrelease}/extra/net/vrouter/vrouter.ko"],
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
