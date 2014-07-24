## Class: jiocloud::system::files
## Purpose: distribute common config files
## Parameters:
##
## ChangeLog:
## 2014-06-18: hkumar: Initial Migration of appropriate file type actions from system class

class jiocloud::system::files {

  file { '/etc/ssh/sshd_config':
    ensure        => file,
    owner         => root,
    group         => root,
    mode          => 644,
    source        => "puppet:///modules/jiocloud/common/sshdconfig",
  }

  file { '/etc/dhcp/dhclient.conf':
    ensure        => file,
    owner         => root,
    group         => root,
    mode          => 644,
    source        => "puppet:///modules/jiocloud/common/_etc_dhcp_dhclient.conf",
  }

  $issue = [ '/etc/issue.net','/etc/issue' ]

  file { $issue:
    ensure        => file,
    owner         => root,
    group         => root,
    mode          => 644,
    source        => "puppet:///modules/jiocloud/common/_etc_issue",
    notify        => Service['ssh'],
  }

  file { '/etc/cron.d/puppet_task':
    ensure        => file,
    owner         => root,
    group         => root,
    mode          => 644,
    content  =>  "*/15 * * * *  root /var/puppet/bin/papply >> /var/log/puppet_run.log 2>&1\n",
  }

  file { '/usr/local/bin/':
    ensure        => directory,
    owner         => root,
    group         => root,
    mode          => 755,
    recurse       => true,
    ignore        => '.svn',
    source        => "puppet:///modules/jiocloud/common/_usr_local_bin/",
  }

  file { '/etc/motd':
    ensure        => symlink,
    target        => '/var/run/motd'
  }

  file { '/etc/update-motd.d':
    ensure        => directory,
    owner         => root,
    group         => root,
    purge         => true,
    force         => true,
    ignore        => '.svn',
    mode          => 755,
    recurse       => true,
    source        => "puppet:///modules/jiocloud/common/_etc_update-motd.d",
  }

}
