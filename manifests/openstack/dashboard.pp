## Class jiocloud::openstack::dashboard
class jiocloud::openstack::dashboard () inherits jiocloud::params {
  class { '::horizon':
    fqdn		=> $horizon_public_address,
    secret_key          => $horizon_secret_key,
    django_debug        => $debug,
    api_result_limit    => $horizon_api_result_limit,
    keystone_url	=> $keystone_public_url,
#"${::os_env::keystone_protocol}://${::os_env::keystone_internal_address}:${::os_env::keystone_port}/${::os_env::keystone_version}",
    listen_ssl		=> $ssl_enabled,
    horizon_key		=> $ssl_key_file,
    horizon_cert	=> $ssl_cert_file,
    horizon_ca		=> $ssl_ca_file,
    regservice_url      => "https://${horizon_public_address}/horizonreg",
    package_ensure    	=> $horizon_package_ensure,
    horizon_allowed_hosts => $horizon_allowed_hosts,
    recaptcha_public_key => $horizon_recaptcha_public_key,
    recaptcha_private_key => $horizon_recaptcha_private_key,
    recaptcha_proxy => $horizon_recaptcha_proxy,
    sms_system_hostname => $horizon_sms_system_hostname,
    sms_system_id => $horizon_sms_system_id,
    sms_system_password => $horizon_sms_system_password,
    sms_source_addr => $horizon_sms_source_addr,
    theme_app => $horizon_theme_app,
    compress_enabled => $horizon_compress_enabled,
    compress_offline => $horizon_compress_offline,
  }

if $jiocloud_registration_enabled {
  class { '::jiocloud_registration':
    fqdn                => $horizon_public_address,
    keystone_add        => $keystone_public_address,
    listen_ssl          => $ssl_enabled,
    horizon_key         => $ssl_key_file,
    horizon_cert        => $ssl_cert_file,
    horizon_ca          => $ssl_ca_file,
    keystone_public_port => $keystone_port,
    keystone_admin_token => $admin_token,
    package_ensure      => $jiocloud_registration_package_ensure,
  }
}
}
