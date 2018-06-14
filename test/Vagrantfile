# -*- mode: ruby -*-
# vi: set ft=ruby :
load "settings.sh"

Vagrant.configure("2") do |config|
  
  config.vm.box = "ubuntu/bionic64"
	
  config.vm.network "private_network", ip: LAN_IP

  config.vm.provider "virtualbox" do |virtualbox|
	  # Enable promiscuous mode
  	  virtualbox.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]

  end

  config.vm.provision "shell", path: "install.sh"

end




