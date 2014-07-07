### Setting up network 
#### Baremetals which runs management vms, need bridge to be up for the management vm. Others doesnt need them.
#### mtu to be setup with dhcp
### Known issue: removing bridge doesnt actually remove bridge, need to support pre=up and pre-down entries in network/interfaces. - fixed
### 28/1/14: Harish - module was not confirming the package bridge-utls installed, fixed.
## Known issue: if hostname changed manually on vm_hosted_nodes, network config will be changed on first puppet run, on second run it will get fixed.
## add host entries for management vm hosted nodes in $vm_hosted_nodes is required - fixed

class jiocloud::system::network_config (
  $mgmt_vms = $jiocloud::params::mgmt_vms,
  $compute_nodes = $jiocloud::params::compute_nodes,
  $host_prefix = $jiocloud::params::host_prefix,
  $compute_be_interface = $jiocloud::params::compute_be_interface,
  $compute_fe_interface = $jiocloud::params::compute_fe_interface,
  $network_device_mtu = $jiocloud::params::network_device_mtu,
  $contrail_vrouter_mac = $jiocloud::params::contrail_vrouter_mac,
  $contrail_vrouter_netmask = $jiocloud::params::contrail_vrouter_netmask,
  $contrail_vrouter_ip = $jiocloud::params::contrail_vrouter_ip,
  $contrail_vrouter_gw = $jiocloud::params::contrail_vrouter_gw,

)  {
  $vm_hosted_node = inline_template('<% @mgmt_vms.each do | key, val | val.each do | k,v | if v == @hostname %> <%= "vm_hosted" %> <% end %> <% end %> <% end %>')
    if is_array($compute_nodes) and $hostname in $compute_nodes  or $compute_nodes and $compute_nodes == $host_prefix {
      if $vm_hosted_node =~ /vm_hosted/ {
	class { "network::interfaces":
	  bridged_if => $compute_be_interface,
	  interfaces => {
	    "$compute_fe_interface" => {
	      "method" => "manual",
	      "pre-up" =>  "ifconfig $compute_fe_interface mtu $network_device_mtu up",
	      "pre-down" => "ifconfig $compute_fe_interface down",
	    },
	    "vhost0" => {
	      "method" => "static",
	      "pre-up" => ["vif --create vhost0 --mac $contrail_vrouter_mac","vif --add vhost0 --mac $contrail_vrouter_mac --vrf 0 --mode x --type vhost"],
	      "pre-down" => ["/etc/contrail/vif-helper delete vhost0","ip link del vhost0"],
	      "netmask"  => "$contrail_vrouter_netmask",
	      "address"  => "$contrail_vrouter_ip",
	      "gateway"  => "$contrail_vrouter_gw",
	      "mtu"	=> "$network_device_mtu",
	    },
	    "$compute_be_interface" => {
	      "method" => "manual",
	      "pre-up" =>  "ifconfig $compute_be_interface mtu $network_device_mtu up",
	      "pre-down" => "ifconfig $compute_be_interface down",
	    },
	    "br0" => {
	      "method" => "dhcp",
	      "bridge_ports" => $compute_be_interface,
	      "bridge_stp" => "on",
	      "bridge_fd"  => "0",
	      "bridge_maxwait" => "0",
	    }
	  },
	  auto => [$compute_fe_interface,$compute_be_interface,"br0","vhost0"],
	}
      } else {
	class { "network::interfaces":
	  interfaces => {
	    "$compute_be_interface" => {
	      "method" => "dhcp",
	    },
	    "$compute_fe_interface" => {
	      "method" => "manual",
	      "pre-up" =>  "ifconfig $compute_fe_interface mtu $network_device_mtu up",
	      "pre-down" => "ifconfig $compute_fe_interface down",
	    },
	    "vhost0" => {
	      "method" => "static",
	      "pre-up" => ["vif --create vhost0 --mac $contrail_vrouter_mac","vif --add vhost0 --mac $contrail_vrouter_mac --vrf 0 --mode x --type vhost"],
	      "pre-down" => ["/etc/contrail/vif-helper delete vhost0","ip link del vhost0"],
	      "netmask"  => "$contrail_vrouter_netmask",
	      "address"  => "$contrail_vrouter_ip",
	      "gateway"  => "$contrail_vrouter_gw",
	      "mtu"	=> "$network_device_mtu",
	    },
	  },
	  auto => [$compute_fe_interface,$compute_be_interface,"vhost0"],
	}
      }
    } else {
      if $vm_hosted_node =~ /vm_hosted/ {
	class { "network::interfaces":
	  bridged_if => $compute_be_interface,
	  interfaces => {
	    "$compute_fe_interface" => {
	      "method" => "dhcp",
	    },
	    "$compute_be_interface" => {
	      "method" => "manual",
	      "pre-up" =>  "ifconfig $compute_be_interface mtu $network_device_mtu",
	    },
	    "br0" => {
	      "method" => "dhcp",
	      "bridge_ports" => $compute_be_interface,
	      "bridge_stp" => "on",
	      "bridge_fd"  => "0",
	      "bridge_maxwait" => "0",
	    }
	  },
	  auto => [$compute_fe_interface,$compute_be_interface,"br0"],
	}
      } elsif $iam_virtual == '1' {
	class { "network::interfaces":
	  interfaces => {
	    "eth0" => {
	      "method" => "dhcp",
	    },
	  },
	  auto => ["eth0"],
	}
      } else {		    
	class { "network::interfaces":
	  interfaces => {
	    "$compute_be_interface" => {
	      "method" => "dhcp",
	    },
	    "$compute_fe_interface" => {
	      "method" => "dhcp",
	    },
	  },
	  auto => [$compute_be_interface,$compute_fe_interface],
	}
      }

    }
}
