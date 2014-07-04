### Setting up contrail
class jiocloud::contrail_setup{ 
### Define variables Here
  $iam_os_compute_node     =   $jiocloud::params::iam_os_compute_node,
  $vrouter_interface       =   $jiocloud::params::vrouter_interface,
  $vrouter_ip              =   $jiocloud::params::contrail_vrouter_ip,
  $discovery_server        =   $jiocloud::params::contrail_discovery_server,
  $vrouter_mac             =   $jiocloud::params::contrail_vrouter_mac,
  $vrouter_gw              =   $jiocloud::params::contrail_vrouter_gw,
  $vrouter_cidr            =   $jiocloud::params::contrail_vrouter_cidr,
  $metadata_proxy_shared_secret    = $jiocloud::params::nova_neutron_metadata_proxy_shared_secret,

##### Conditional application of role based classes
  
 if iam_os_compute_node {  
	class {'::role_contrail_vrouter':}
  }

## End of contrail_setup
}

  
##### Setting up role based classes

class role_contrail_vrouter  {
 #FIXME: NEED TO BE FIXED AND ENABLED. 
 #  add_static_route { "$::contrail_env::contrail_static_route_vhost0": }
  
   class {'contrail':
	vrouter_interface	=> $contrail_vrouter_interface,
	vrouter_ip		=> $contrail_vrouter_ip,
	discovery_server	=> $contrail_discovery_server,
        vrouter_mac		=> $contrail_vrouter_mac,
	vrouter_gw		=> $contrail_vrouter_gw,
	vrouter_cidr		=> $contrail_vrouter_cidr,
        metadata_proxy_shared_secret	=> $metadata_proxy_shared_secret,

   }

  file { ['/lib/modules',"/lib/modules/$kernelrelease","/lib/modules/${kernelrelease}/extra","/lib/modules/$kernelrelease/extra/net","/lib/modules/$kernelrelease/extra/net/vrouter"]:
	ensure	=> directory,
	before  => File ["/lib/modules/${kernelrelease}/extra/net/vrouter/vrouter.ko"], 
  }
  file { "$vrouter_file":
    ensure        => file,
    owner         => root,
    group         => root,
    mode          => 644,
    source        => "$vrouter_file_source",
  }

   if $jiocloud::param::my_environment != "virtualcloud" {
   if 'vhost0' in $::system_env::interfaces_array {
      exec {"add_static_route_104":
	command => "route add -net 10.135.104.0/25 gateway $::contrail_setup::contrail_vrouter_gw  dev vhost0",
	unless => "ip r l | grep \"10.135.104.0/25.*vhost0\"",
      }
#      file_line { 'comment_exit':
#	line => "#exit 0",
#	match => "exit *0$",
#	path => "/etc/rc.local",
#      }
#      file_line { 'route_104':
#	line => "route add -net 10.135.104.0/25 gateway $::contrail_setup::contrail_vrouter_gw  dev vhost0",
#	path => "/etc/rc.local",
#      }
      exec {"add_static_route_105":
	command => "route add -net 10.135.105.0/25 gateway $::contrail_setup::contrail_vrouter_gw dev vhost0",
	unless => "ip r l | grep \"10.135.105.0/25.*vhost0\"",
      }
#      file_line { 'route_105':
#	line => "route add -net 10.135.105.0/25 gateway $::contrail_setup::contrail_vrouter_gw dev vhost0",
#	path => "/etc/rc.local",
#      }
      exec {"add_static_route_106":
	command => "route add -net 10.135.106.0/25 gateway $::contrail_setup::contrail_vrouter_gw dev vhost0",
	unless => "ip r l | grep \"10.135.106.0/25.*vhost0\"",
      }
#      file_line { 'route_106':
#	line => "route add -net 10.135.106.0/25 gateway $::contrail_setup::contrail_vrouter_gw  dev vhost0",
#	path => "/etc/rc.local",
#      }
#      exec {"add_static_route_96":
#	command => "route add -net 10.135.96.0/25 gateway $::contrail_setup::contrail_vrouter_gw dev vhost0",
#	unless => "ip r l | grep \"10.135.96.0/25.*vhost0\"",
#      }
#      file_line { 'route_96':
#	line => "route add -net 10.135.96.0/24 gateway $::contrail_setup::contrail_vrouter_gw dev vhost0",
#	path => "/etc/rc.local",
#      }
  }

 
  if 'vhost0' in $::system_env::interfaces_array {
    exec {"addroute_mx":
	command => "route add -host $::contrail_env::contrail_mx_address gateway $::contrail_setup::contrail_vrouter_gw dev vhost0",
	unless => "ip r l | grep \"$::contrail_env::contrail_mx_address.*vhost0\"",
    }
  }
}
}
