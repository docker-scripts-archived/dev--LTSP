# Virtual LTSP Server

## Description
Virtual LTSP server project automates installation and configuration of LTSP server with vagrant. It is the easiest way to setup LTSP yet. 
LTSP allows computers of a LAN to boot through network from a single server. Same LTSP server can be setup on VirtualBox. So we have created a provisioner script to install and configure LTSP to a vagrant box. Also created other scripts to create LTSP clients, start a proxy dhcp server, etc.

LTSP server has two main modes of operation: standalone and normal. These depend on whether we have a DHCP server on the LAN or not.

1. **Standalone** means that the LTSP server also provides DHCP service to the clients. The vagrant boxes have NAT configured Inside them. Same can be used clients can have access to internet through LTSP server, the gateway to the internet.

1. **Normal** means that the LTSP server does not provide IP addresses (DHCP service) to the clients, but there is another (existing) DHCP server on the LAN that does this. In this case, the LTSP server usually is not the gateway to the Internet.

You can refer to wiki pages for more information on modes of operation - [dev--LTSP/wiki/Mode-of-operation-LTSP](https://github.com/docker-scripts/dev--LTSP/wiki/LTSP-Modes-of-Operation)

## Prerequisites
For this project, there are two requirements. Also, it is recommended to use the latest version for these two -

- **[Virtualbox](https://www.virtualbox.org/)** - Installation is different in different distributions. Best option is to visit - https://www.virtualbox.org/wiki/Downloads
- **[Vagrant](https://www.vagrantup.com/)** - you may install latest version of vagrant by -
   
   ```
   VAGRANT_VERSION=2.1.2
   wget https://releases.hashicorp.com/vagrant/${VAGRANT_VERSION}/vagrant_${VAGRANT_VERSION}_x86_64.deb
   sudo dpkg -i vagrant_${VAGRANT_VERSION}_x86_64.deb
   ```
## Clone the repository
   
   ```
   git clone https://github.com/docker-scripts/dev--LTSP.git -b buster
   cd dev--LTSP
   ```

## Installation for normal mode
1. Open `settings.sh` 
1. Set the interface you want to use by changing `LAN_IF` and save it.
1. Do a `vagrant up` 
1. You will have ltsp-server setup in normal mode

## Installation for standalone mode  
1. Open `settings.sh`
1. Change the `STANDALONE` variable to `yes`
1. Change the `LAN_IP` variable to whichever IP address you want for ltsp server and save it.
1. Do a `vagrant up` from the terminal
1. You will have ltsp-server setup in standalone mode.

## Automated testing
Virtual ltsp server project supports automated testing. It is meant to be done with single computer. `test.sh` script is used for that. 
```
./test.sh [start/stop] 
```
- Change the `STANDALONE` to `yes` or `no` to set the mode of operation of ltsp server.
- do a `./test.sh start` to start testings. you should see client booting from server at the end of it
- do a `./test.sh stop` to stop after test is compeleted. It will destroy virtual interface, ltsp-server and client.

## Vagrant Commands

- `vagrant up`

	This command will start the vagrant box and also install and configure LTSP if ran for the first time.
	
- `vagrant status`

	This will tell the current state of vagrant box. Whether it is running, powered off or not created.
	
- `vagrant provision`

   This will run the provisioner script defined.
	
- `vagrant halt`

	This is stop the ltsp server vagrant box.
	
- `vagrant destroy`

	This command will compeletly destroy the ltsp server.
	
More information about vagrant can be found on their official documentation - https://www.vagrantup.com/docs/	

Please refer to wiki page for more details regarding Virtual LTSP Server project - https://github.com/docker-scripts/dev--LTSP/wiki

