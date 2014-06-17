## Setup kvm and boot a vm
## install and configure kvm, and boot a vm
## source = pxe - make an empty qcow2 image with size disk_size and do a pxeboot
## source = image - download image from image_url and boot the vm
## Dependancy: The hostname need to specified in $vm_hosted_nodes variable in system.pp

class jiocloud::kvm ( 
  $mgmt_vms,
  $mgmt_vm_virsh_secret_value 	= $jiocloud::params::mgmt_vm_virsh_secret_value,
  $mgmt_vm_virsh_secret_uuid 	= $jiocloud::params::mgmt_vm_virsh_secret_uuid,
   
) inherits jiocloud::params {

  if 'virbr0' in $jiocloud::params::interfaces_array {
    class  { 'kvm::rm_nated_network': }
  }
 
#  if is_array($compute_nodes) and $hostname in $compute_nodes  or $compute_nodes and $compute_nodes == $jiocloud::params::host_prefix {
      class { '::kvm': 
  	mgmt_vm_virsh_secret_value => $mgmt_vm_virsh_secret_value,
  	mgmt_vm_virsh_secret_uuid  => $mgmt_vm_virsh_secret_uuid,
      }
      create_resources(kvm_boot,$mgmt_vms)
  #}

}

  define kvm_boot (
    $mac_addr,	
    $host,
    $vm_name = $name,
    $mem_mb  = '1024',
    $vcpu    = '1',
    $bridge  = 'br0',
    $source  = 'image',
    $image_url = 'http://vmimages/vm_images/ubuntu-12.04_with_puppet.qcow2',
    $vmimage_path       = '/var/lib/libvirt/images',
    $vm_uuid    = '5fe11193-d3fa-4cec-a9d5-2c211323024e',
    $vm_serial  = "mu.jio-${host}-${name}",
    $disk_size  = '20G',
    $rbd_disk_image = undef,
  ) {
    if $host == $hostname {
      if $source == 'rbd' and $rbd_disk_image == undef  {
        fail('Valid rbd disk image to be provided')
      }
      kvm::vm_boot { $vm_name: 
        vm_name => $vm_name,
        mem_mb  => $mem_mb,
        vcpu    => $vcpu,
        bridge  => $bridge,
        mac_addr => $mac_addr,
	source	=> $source,
	vmimage_path => $vmimage_path,
	rbd_disk_image	=> $rbd_disk_image,
        image_url        => $image_url,
	vm_uuid => $vm_uuid,
	vm_serial => $vm_serial,
	disk_size => $disk_size,
      }
    }
  }    

