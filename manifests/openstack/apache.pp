## Class: jiocloud::openstack::apache
class jiocloud::openstack::apache (
  $ssl_cert_file = $jiocloud::params::ssl_cert_file,
  $ssl_key_file = $jiocloud::params::ssl_key_file,
  $ssl_ca_file = $jiocloud::params::ssl_ca_file,
  $nova_port_to_apache = $jiocloud::params::nova_port_to_apache,
  $ssl_enabled = $jiocloud::params::ssl_enabled,
  $jiocloud_ssl_cert_package_version = $jiocloud::params::jiocloud_ssl_cert_package_version,
) {

  if $ssl_enabled {
    class {'::apache':
      server_signature => 'Off',
      default_ssl_chain => $ssl_ca_file,
      default_ssl_cert => $ssl_cert_file,
      default_ssl_key => $ssl_key_file,
      default_vhost => false,
      apache_version => '2.4',
      require => Package['jiocloud-ssl-certificate'],
    }
    include ::apache::mod::wsgi
    include apache::mod::rewrite
    include apache::mod::ssl
    include apache::mod::proxy
    include apache::mod::proxy_http
    ## this is required to proxy novncproxy
    ::apache::mod { 'proxy_wstunnel': }	
    package { 'jiocloud-ssl-certificate':
      ensure => $jiocloud_ssl_cert_package_version,
    }
  } else {
    class {'::apache':
      server_signature => 'Off',
      default_vhost => false,
    }
    include ::apache::mod::wsgi
    include apache::mod::rewrite
    include apache::mod::proxy
    include apache::mod::proxy_http
  } 


}
