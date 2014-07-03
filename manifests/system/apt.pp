class jiocloud::system::apt (
  $ip_array = $jiocloud::params::ip_array,
  $local_repo_ip = $jiocloud::params::local_repo_ip,
  $apt_sources = $jiocloud::params::apt_sources,
  $my_environment = $jiocloud::params::my_environment,

) {
  class { '::apt':
  always_apt_update    => false,
  disable_keys         => undef,
  purge_sources_list   => true,
  purge_sources_list_d => true,
  purge_preferences_d  => false,
  }

#  class { '::apt::release':
#      release_id => 'precise',
#  } 
 
  if $local_repo_ip in $ip_array {
    class { '::apt::mirror':}
  }

  create_resources(apt_source,$apt_sources, {local_repo_ip => $local_repo_ip, ip_array => $ip_array, my_environment => $my_environment} )

  define apt_source (
    $location,
    $repos = 'main',
    $local_repo_ip = undef,
    $ip_array = undef,
    $include_src = false,
    $architecture = 'amd64',
    $release	= 'precise',
    $mirror_url  = 'UNDEF',
    $my_environment = undef,
    $environment = ['production','staging','virtualcloud'],
  ) {
    if downcase($my_environment) in downcase($environment) {
      ::apt::source { $name:
	location   => $location,
	repos      => $repos,
	include_src => $include_src,
	architecture => $architecture,
	release	    => $release,
      }
    }

    if $local_repo_ip in $ip_array {
      ::apt::mirror::source { $name:
	mirror_url	=> $mirror_url,
	repos      => $repos,
        include_src => $include_src,
        architecture => $architecture,
        release     => $release,
      }  

    }
  }

}

