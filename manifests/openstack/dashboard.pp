## Class jiocloud::openstack::dashboard
class jiocloud::openstack::dashboard () {
  class { '::horizon':
    fqdn		=> $horizon_public_address,
    secret_key          => $horizon_secret_key,
    django_debug        => $debug,
    api_result_limit    => $horizon_api_result_limit,
    keystone_url	=> $keystone_public_url,
#"${::os_env::keystone_protocol}://${::os_env::keystone_internal_address}:${::os_env::keystone_port}/${::os_env::keystone_version}",
    listen_ssl		=> $horizon_ssl_enabled,
    horizon_key		=> $horizon_ssl_key,
    horizon_cert	=> $horizon_ssl_cert,
    horizon_ca		=> $horizon_ssl_cacert,
    regservice_url      => "https://${horizon_public_address}/horizonreg",
    package_ensure    	=> $horizon_package_ensure

  }

  class { '::jiocloud_registration':
    fqdn                => $horizon_public_address,
    keystone_add        => $keystone_public_address,
    listen_ssl          => $horizon_ssl_enabled,
    horizon_key         => $horizon_ssl_key,
    horizon_cert        => $horizon_ssl_cert,
    horizon_ca          => $horizon_ssl_cacert,
    keystone_public_port => $keystone_port,
    keystone_admin_token => $admin_token,
    package_ensure      => $jiocloud_registration_package_ensure,
  }

}
