
class jiocloud::db (
  $db_host_ip			= $jiocloud::params::db_host_ip,
  $mysql_data_disk		= $jiocloud::params::mysql_data_disk,
  $mysql_server_package_name 	= $jiocloud::params::mysql_server_package_name,
  $mysql_client_package_name 	= $jiocloud::params::mysql_client_package_name,
  $mysql_root_pass	     	= $jiocloud::params::mysql_root_pass,
  $mysql_datadir	     	= $jiocloud::params::mysql_datadir,
  $mysql_max_connections     	= $jiocloud::params::mysql_max_connections,
  $os_dbs		     	= $jiocloud::params::os_dbs,
  $other_dbs			= $jiocloud::params::other_dbs,
) inherits jiocloud::params  {
  
  if is_hash($other_dbs) {
    $dbs = merge($os_dbs,$other_dbs)
  } else {
    $dbs = $os_dbs
  }

  if $db_host_ip in $jiocloud::params::ip_array {
    create_resources(db_def,$dbs)
    class { '::mysql::client':
	package_name	=> $mysql_client_package_name,
    }

    class { '::mysql::server':
        root_password   => $mysql_root_pass,
        package_name    => $mysql_server_package_name,
        override_options => { 'mysqld' => {
                  'max_connections'     => $mysql_max_connections,
                  'datadir'             => $mysql_datadir,
		  'bind-address'	=> '0.0.0.0',
                  }
                },
	databases => $databases,
	users	=> $users, 
	grants => $grants, 
    }

    if $mysql_data_disk {
     ensure_resource('package','xfsprogs',{'ensure' => 'present'})

      exec { "mkfs_${mysql_data_disk}":
        command => "mkfs.xfs -f -d agcount=${::processorcount} -l \
size=1024m -n size=64k ${mysql_data_disk}",
        unless  => "xfs_admin -l ${mysql_data_disk}",
        require => Package['xfsprogs'],
      }
      
      file_line { "fstab_${mysql_data_disk}":
	line => "${mysql_data_disk} ${mysql_datadir} xfs rw,noatime,inode64 0 2",
	path => "/etc/fstab",
	require => Exec["mkfs_${mysql_data_disk}"],
      }

      exec { "mount_${mysql_data_disk}":
        command => "mount ${mysql_data_disk}",
	unless  => "df ${mysql_datadir} | grep ${mysql_data_disk}",
	require => File_line["fstab_${mysql_data_disk}"],
     }

    exec { "install_db_${mysql_data_disk}":
	command => "mysql_install_db --user=mysql",
	unless  => "ls ${mysql_datadir}/mysql",
	require => Exec["mount_${mysql_data_disk}"],
    }
  }
    
    exec { "install_db":
	command => "mysql_install_db --user=mysql; rm -f /root/.my.cnf",
	unless  => "ls ${mysql_datadir}/mysql",
    }
  }  else {
    fail('db_host_ip must be provided')
  }  
}

 define db_def (
    $db,
    $pass = $db,
    $user = $db,
    $grant = ['ALL'],
    $ensure = 'present',
    $charset = 'utf8',
    $table = "${db}.*",
  ) {
    mysql_database { $db:
    ensure   => $ensure,
    charset  => $charset,
    provider => 'mysql',
    require  => [ Class['mysql::server'], Class['mysql::client'] ],
    before   => Mysql_user["${user}@%"],
    }

    $user_resource = {
      ensure        => $ensure,
      password_hash => mysql_password($pass),
      provider      => 'mysql',
      require       => Class['mysql::server'],
    }
    ensure_resource('mysql_user', "${user}@%", $user_resource)

    if $ensure == 'present' {
      mysql_grant { "${user}@%/${table}":
          privileges => $grant,
          provider   => 'mysql',
          user       => "${user}@%",
          table      => $table,
          require    => [ Mysql_user["${user}@%"], Class['mysql::server'] ],
      }
    }

  }

