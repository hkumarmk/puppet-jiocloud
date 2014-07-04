class jiocloud {
  class {'jiocloud::params':}
  Exec { path => $jiocloud::params::executable_path }
  class {'jiocloud::system':}
  class {'jiocloud::db':}
  class {'jiocloud::openstack':}

}
