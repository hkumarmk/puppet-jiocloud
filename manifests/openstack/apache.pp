## Class: jiocloud::openstack::apache
class jiocloud::openstack::apache (
  $ssl_cert_file_source = $jiocloud::params::ssl_cert_file_source,
  $ssl_cert_file = $jiocloud::params::ssl_cert_file,
  $ssl_key_file_source = $jiocloud::params::ssl_key_file_source,
  $ssl_key_file = $jiocloud::params::ssl_key_file,
  $ssl_ca_file_source = $jiocloud::params::ssl_ca_file_source,
  $ssl_ca_file = $jiocloud::params::ssl_ca_file,
  $nova_port_to_apache = $jiocloud::params::nova_port_to_apache,
  $ssl_enabled = $jiocloud::params::ssl_enabled,
) {

  if $ssl_enabled {
    class {'::apache':
      server_signature => 'Off',
      default_ssl_chain => $ssl_ca_file,
      default_ssl_cert => $ssl_cert_file,
      default_ssl_key => $ssl_key_file,
      default_vhost => false,
      apache_version => '2.4',
    }
    include ::apache::mod::wsgi
    include apache::mod::rewrite
    include apache::mod::ssl
    include apache::mod::proxy
    include apache::mod::proxy_http
    ## this is required to proxy novncproxy
    ::apache::mod { 'proxy_wstunnel': }	
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

  file { '/etc/apache2/certs':
    ensure	=> directory,
    owner   => www-data,
    group   => www-data,
  }


  if  $ssl_cert_file_source != undef {
    file { $ssl_cert_file:
      ensure        => file,
      owner         => www-data,
      group         => www-data,
      mode          => 640,
      source        => $ssl_cert_file_source,
      notify  => Service['httpd'],
    }
  }

  if  $ssl_key_file_source != undef {
    file { $ssl_key_file:
      ensure        => file,
      owner         => www-data,
      group         => www-data,
      mode          => 640,
      source        => $ssl_key_file_source,
      notify  => Service['httpd'],
    }
  }

  
  if  $ssl_ca_file_source != undef {
    file { $ssl_ca_file:
      ensure          => file,
      owner           => www-data,
      group           => www-data,
      mode            => 640,
      source          => $ssl_ca_file_source,
      notify  => Service['httpd'],
    }
  }

}
