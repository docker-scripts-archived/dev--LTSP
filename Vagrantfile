# -*- mode: ruby -*-
# vi: set ft=ruby :
load "settings.sh"

if TYPE == 'bridge'
    INTERFACE = (%x(  ip route | grep default | cut -d' ' -f5 )).strip
end

Vagrant.configure("2") do |config|
  
    config.vm.box = "ubuntu/bionic64"
   
    if TYPE == 'bridge'
        config.vm.network "public_network", ip: LAN_IP, netmask: "255.255.255.0",
            bridge: INTERFACE
    else 
        config.vm.network "private_network", ip: LAN_IP
    end
  
    config.vm.provider "virtualbox" do |virtualbox|
# Enable promiscuous mode
        virtualbox.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
    end

    config.vm.provision "shell", path: "install.sh"

end