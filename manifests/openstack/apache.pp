## Class: jiocloud::openstack::apache
class jiocloud::openstack::apache (
  $ssl_cert_file_source = $jiocloud::params::ssl_cert_file_source,
  $ssl_cert_file = $jiocloud::params::ssl_cert_file,
  $ssl_key_file_source = $jiocloud::params::ssl_key_file_source,
  $ssl_key_file = $jiocloud::params::ssl_key_file,
  $ssl_ca_file_source = $jiocloud::params::ssl_ca_file_source,
  $ssl_ca_file = $jiocloud::params::ssl_ca_file,
  $nova_port_to_apache = $jiocloud::params::nova_port_to_apache,
) {

  #FIXME: WORKAROUND TO ENABLE SSL

  if $ssl_enabled  {
    $apache_config_ensure = file
  } else {
    $apache_config_ensure = absent
  }




  include ::apache
  include ::apache::mod::wsgi
  include apache::mod::rewrite
  include apache::mod::ssl
  include apache::mod::proxy
  include apache::mod::proxy_http
  ## this is required to proxy novncproxy
  ::apache::mod { 'proxy_wstunnel': }	

  file { '/etc/apache2/conf.d/glance.conf':
    ensure  => $apache_config_ensure,
    owner   => www-data,
    group   => www-data,
    source => "puppet:///modules/jiocloud/apache2/glance.conf",
    mode    => '0644',
    notify  => Service['httpd'],
  }



  file { '/etc/apache2/conf.d/glance-registry.conf':
    ensure  => $apache_config_ensure,
    owner   => www-data,
    group   => www-data,
    source => "puppet:///modules/jiocloud/apache2/glance-registry.conf",
    mode    => '0644',
    notify  => Service['httpd'],
  }

  file { '/etc/apache2/conf.d/horizon.conf':
    ensure  => file,
    owner   => www-data,
    group   => www-data,
    content => template("puppet:///modules/jiocloud/apache2/horizon.conf.erb"),
    mode    => '0644',
    notify  => Service['httpd'],
  }

  file { '/etc/apache2/conf.d/jiocloud-registration-service.conf':
    ensure  => file,
    owner   => www-data,
    group   => www-data,
    content => template("puppet:///modules/jiocloud/apache2/jiocloud-registration-service.conf"),
    mode    => '0644',
    notify  => Service['httpd'],
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

  file {'/var/log/horizon':
    ensure 	=> directory,
    owner 	=> horizon,
    group	=> horizon,
    mode	=> '0755',
    notify  => Service['httpd'],
  }


  if ($nova_port_to_apache) {
    file { '/etc/apache2/conf.d/compute.conf':
      ensure  => $apache_config_ensure,
      owner   => www-data,
      group   => www-data,
      source => "puppet:///modules/jiocloud/apache2/compute.conf.wsgi",
      mode    => '0644',
      notify  => Service['httpd'],
    }
  } else {
    file { '/etc/apache2/conf.d/compute.conf':
      ensure  => $apache_config_ensure,
      owner   => www-data,
      group   => www-data,
      source => "puppet:///modules/jiocloud/apache2/compute.conf.proxy",
      mode    => '0644',
      notify  => Service['httpd'],
    }
  }

  file { '/etc/apache2/conf.d/ec2.conf':
    ensure  => $apache_config_ensure,
    owner   => www-data,
    group   => www-data,
    source => "puppet:///modules/jiocloud/apache2/ec2.conf",
    mode    => '0644',
    notify  => Service['httpd'],
  }

  file { '/etc/apache2/conf.d/cinder.conf':
    ensure  => $apache_config_ensure,
    owner   => www-data,
    group   => www-data,
    source => "puppet:///modules/jiocloud/apache2/cinder.conf",
    mode    => '0644',
    notify  => Service['httpd'],
  }

  file { '/etc/apache2/conf.d/keystone.conf':
    ensure  => $apache_config_ensure,
    owner   => www-data,
    group   => www-data,
    source => "puppet:///modules/jiocloud/apache2/keystone.conf",
    mode    => '0644',
    notify  => Service['httpd'],
  }
 
}