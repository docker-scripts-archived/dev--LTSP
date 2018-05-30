# -*- mode: ruby -*-
# vi: set ft=ruby :

class Config
	def readfunction
		ne = IO.readlines('settings.sh')		
		nm = ne[1].split "="		
		na = nm[1].split "/"
		nip = na[0][0..-2]
		$ip = nip + 18.to_s
	end

obj = Config.new()
obj.readfunction

Vagrant.configure("2") do |config|
  
  config.vm.box = "ubuntu/bionic64"
	
  config.vm.network "public_network", ip: $ip, netmask: "255.255.255.0", virtualbox_intnet: "eno1"
  
  config.vm.provider "virtualbox" do |virtualbox|
	  # Enable promiscuous mode
  	  virtualbox.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]

  end

  config.vm.provision "shell", path: "install.sh"

end

end



