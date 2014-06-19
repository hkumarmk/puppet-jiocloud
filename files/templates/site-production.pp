##
  import '%_Environment_%' 

## Base system configurations
  import 'system.pp'

## setup different management vms
  import 'kvm_setup.pp'

## Setup openstack
  import 'openstack.pp'

## Setup ceph
  import 'ceph.pp'

### Setup contrail
  import 'contrail.pp'

## Defaults
  import 'defaults.pp'

## mysql
#  import 'mysql.pp'

########## Calling Main Classes
  class {'::global_env':} -> class {'::system_env':} -> class {'::os_env':} -> class {'::ceph_env':} -> class {'::contrail_env':}
#  class {'::mysql_env':}
  class {'::contrail_setup':}
  class {'::system':} ->
  class {'::kvm_setup':} 
  class {'::openstack_setup':}
  class {'::ceph_setup':}
#  class {'::mysql_setup':}
