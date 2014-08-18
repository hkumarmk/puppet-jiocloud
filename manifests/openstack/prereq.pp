##Class jiocloud::openstack::prereq
## This class runs all prerequisites for openstack packages
class jiocloud::openstack::prereq {
  ### Workaround to hold to contrail provided package for python-neutronclient (2.3.0-0ubuntu1)
  ### FIXME: This will be gone once we use the packages build in rustedhalo.
  ::apt::pin { "hold_python-neutronclient":
     packages => 'python-neutronclient',
     version => '1:2.3.0-0ubuntu1',
     priority => 1001,
  }
}
