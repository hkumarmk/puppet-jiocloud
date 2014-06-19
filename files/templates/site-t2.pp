##
#  import '%_Environment_%' 

#  import 'defaults.pp'

## Base system configurations
#  import 'system.pp'

#  import 'apt.pp'

## setup different management vms
#  import 'kvm_setup.pp'

## Setup openstack
#  import 'openstack.pp'

## Setup ceph
#  import 'ceph.pp'

### Setup contrail
# import 'contrail.pp'

#import 'mysql.pp'

########## Calling Main Classes
#  class {'::global_env':} -> class {'::system_env':} -> class {'::os_env':} -> class {'::ceph_env':} -> class {'::contrail_env':}
#  class {'::apt_env':} -> class {'::apt_setup':}
#  class {'::mysql_env':}
#  class {'::contrail_setup':}
#  class {'::system':} ->
#  class {'::mysql_setup':}
#  class {'::kvm_setup':} 
#  class {'::openstack_setup':}
#  class {'::ceph_setup':}

