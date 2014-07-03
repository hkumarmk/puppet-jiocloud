default_route_row = Facter::Util::Resolution.exec('ip route list | grep default | awk "{print \$3,\$5}"').chomp
if default_route_row =~ /^(\d+\.\d+\.\d+\.\d+)\s*([\w\d]+)$/
  default_gw = $1
  default_gw_if = $2
  default_gw_ip = Facter.value("ipaddress_"+$2)
  Facter.add("default_gw") { setcode { default_gw } }
  Facter.add("default_gw_if") { setcode { default_gw_if } }
  Facter.add("default_gw_ip") { setcode { default_gw_ip } }
end
networks_production = Array["10.135.120.0/24","10.135.121.0/24","10.135.112.0/24","10.135.122.0/24","10.135.123.0/24"]
networks_staging = Array["10.135.123.0/24"]
#Get all interfaces
all_network = Facter::Util::Resolution.exec('ip route list | grep link | awk "{printf \$1\" \"}"').chomp
#convert string to array
all_network = all_network.split(" ")
#Check any of element is common in array ,if any common will be found then it will return false otherwise it will return true
production =(networks_production & all_network).empty?
staging =(networks_staging & all_network).empty?

if production == false
   Facter.add("environment") { setcode { "production" } }
elsif staging == false 
   Facter.add("environment") { setcode { "staging" } }
else 
   Facter.add("environment") { setcode { "virtual" } }
end



