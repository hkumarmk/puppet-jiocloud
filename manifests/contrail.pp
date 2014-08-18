### Setting up contrail
class jiocloud::contrail (
  $configure_contrail_node = false,
  $repo_type =  'apt-repo',
) inherits jiocloud::params {
  ## Setup contrail controller components on contrail_node
  if $iam_contrail_node and $configure_contrail_node {
    ## install contrail-install (repo) package and other base packages
    class {'::contrail::install':
      contrail_repo_type => $repo_type,
    }    
    ## Do basic system configuration, which is required for contrail controller to work
    class {'::contrail::system_config': }
    ## Setup zookeeper
    class {'::contrail::zookeeper': }
    ##Setup haproxy
    class {'::contrail::haproxy': }
    ## Setup rabbitmq
    class {'::contrail::rabbitmq': }
    ## Setup cassandra
    class {'::contrail::database': }
  } elsif  $iam_compute_node {
    ## Setup vrouter on compute node
    class {'jiocloud::contrail::vrouter': }
  }
}

  
