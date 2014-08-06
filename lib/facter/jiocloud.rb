default_route_row = Facter::Util::Resolution.exec('ip route list | grep default | awk "{print \$3,\$5}"').chomp
if default_route_row =~ /^(\d+\.\d+\.\d+\.\d+)\s*([\w\d]+)$/
  default_gw = $1
  default_gw_if = $2
  default_gw_ip = Facter.value("ipaddress_"+$2)
  Facter.add("default_gw") { setcode { default_gw } }
  Facter.add("default_gw_if") { setcode { default_gw_if } }
  Facter.add("default_gw_ip") { setcode { default_gw_ip } }
end
jiocloud_release = Facter::Util::Resolution.exec('cat /etc/jiocloud-release')
Facter.add("jiocloud_release") { setcode { jiocloud_release.chomp } }
Facter.add("iam_virtual") do
    setcode do
        Facter::Util::Resolution.exec("/usr/sbin/dmidecode | grep -ic Reliance.Jio").chomp
    end
end
