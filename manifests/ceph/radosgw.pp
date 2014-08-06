##Class: jiocloud::ceph::radosgw
class jiocloud::ceph::radosgw (
  $ceph_radosgw_serveradmin_email = $jiocloud::params::ceph_radosgw_serveradmin_email,
  $ceph_radosgw_fastcgi_ext_script = $jiocloud::params::ceph_radosgw_fastcgi_ext_script,
  $ceph_radosgw_socket = $jiocloud::params::ceph_radosgw_socket,
  $ceph_radosgw_fastcgi_ext_script_source = $jiocloud::params::ceph_radosgw_fastcgi_ext_script_source,
  $ceph_radosgw_log_file = $jiocloud::params::ceph_radosgw_log_file,
  $ceph_keyring = $jiocloud::params::ceph_keyring,
  $ceph_radosgw_keyring = $jiocloud::params::ceph_radosgw_keyring,
  $keystone_protocol = $jiocloud::params::keystone_protocol,
  $keystone_admin_address = $jiocloud::params::keystone_admin_address,
  $keystone_admin_port = $jiocloud::params::keystone_admin_port,
  $admin_token = $jiocloud::params::admin_token,
  $keystone_accepted_roles = $jiocloud::params::keystone_accepted_roles,
  $region = $jiocloud::params::region,
  $radosgw_public_address = $jiocloud::params::ceph_radosgw_public_address,
  $radosgw_listen_port = $jiocloud::params::ceph_radosgw_listen_port,
  $radosgw_admin_address = $jiocloud::params::ceph_radosgw_admin_address,
  $radosgw_internal_address = $jiocloud::params::ceph_radosgw_internal_address,
  $ceph_radosgw_listen_ssl = $jiocloud::params::ceph_radosgw_listen_ssl,
  $ssl_cert_file = $jiocloud::params::ssl_cert_file,
  $ssl_key_file = $jiocloud::params::ssl_key_file,
  $ssl_ca_file = $jiocloud::params::ssl_ca_file,
  $ceph_radosgw_apache_version = $jiocloud::params::ceph_radosgw_apache_version,
  $jiocloud_ssl_cert_package_version = $jiocloud::params::jiocloud_ssl_cert_package_version,
) {
  file {'/etc/apache2/certs/':
    ensure => directory,
  }
  class { '::ceph::radosgw':
    serveradmin_email	=> $ceph_radosgw_serveradmin_email,
    fastcgi_ext_script	=> $ceph_radosgw_fastcgi_ext_script,
    socket			=> $ceph_radosgw_socket,	
    fastcgi_ext_script_source	=> $ceph_radosgw_fastcgi_ext_script_source,
    logfile			=> $ceph_radosgw_log_file,
    keyring			=> $ceph_keyring,
    radosgw_keyring		=> $ceph_radosgw_keyring,
    keystone_url		=> "${keystone_protocol}://${keystone_admin_address}:${keystone_admin_port}",
    keystone_admin_token	=> $admin_token,
    keystone_accepted_roles	=> $keystone_accepted_roles,
    region        		=> $region,
    public_address		=> $radosgw_public_address,
    public_port		=> $radosgw_listen_port,
    admin_address		=> $radosgw_admin_address,
    internal_address	=> $radosgw_internal_address,
    listen_ssl		=> $ceph_radosgw_listen_ssl,
    radosgw_cert_file	=> $ssl_cert_file,
    radosgw_key_file	=> $ssl_key_file,
    radosgw_ca_file	=> $ssl_ca_file,
    require 		=> Package['jiocloud-ssl-certificate'],
  }
  package { 'jiocloud-ssl-certificate':
    ensure => $jiocloud_ssl_cert_package_version,
  }


}
