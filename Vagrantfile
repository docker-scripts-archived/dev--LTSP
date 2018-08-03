# -*- mode: ruby -*-
# vi: set ft=ruby :
load "settings.sh"

Vagrant.configure("2") do |config|
  
  config.vm.box = VB_IMAGE
	
  if STANDALONE.downcase == "yes"		
    config.vm.network "public_network", ip: LAN_IP, netmask: "255.255.255.0", bridge: LAN_IF
  else
    config.vm.network "public_network", auto_config: true, bridge: LAN_IF
  end
  
  config.vm.provider "virtualbox" do |virtualbox|
	  # Enable promiscuous mode
  	  virtualbox.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
  	  virtualbox.memory = VB_RAM
   end
  
  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.memory = "1024"
   end

  config.vm.synced_folder ".", "/vagrant"
  config.vm.provision "shell", path: "install.sh"

end

