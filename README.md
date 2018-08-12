# Virtual LTSP Server

## Description
Virtual LTSP server project automates installation and configuration of LTSP server with vagrant. It is the easiest way to set up LTSP yet. 
[LTSP](http://www.ltsp.org/) allows computers of a LAN to boot through the network from a single server. Same LTSP server can be set up on VirtualBox. So we have created a provisioner script to install and configure LTSP to a vagrant box. Also created other scripts to create LTSP clients, start a proxy DHCP server, etc.

LTSP server has two main modes of operation: standalone and normal. These depend on whether we have a DHCP server in the LAN or not.

1. **Standalone** means that the LTSP server provides DHCP services to the clients. Clients have access to the internet through LTSP server. Hence the LTSP server is the gateway to the internet. Note that in case of standalone mode the router should be configured to not provide DHCP services. Otherwise, the setup will not work since the client will not be able to get ip address.

1. **Normal** _(proxy DHCP)_ means that the LTSP server does not provide DHCP service to the clients. Instead there is an existing DHCP server in the LAN that does this. In this case, the LTSP server usually is not the gateway to the Internet. Here LTSP server just provides booting information.

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
   git clone https://github.com/docker-scripts/dev--LTSP.git -b bionic
   cd dev--LTSP
   ```

## Installation for normal mode
1. Open `settings.sh` 
1. Set the interface you want to use by changing `LAN_IF` and save it.
1. Do a `vagrant up` 
1. You will have ltsp-server setup in normal mode
1. Do a `./client.sh` to start the virtual client

## Installation for standalone mode  
1. Open `settings.sh`
1. Change the `STANDALONE` variable to `yes`
1. Set the interface you want to use by changing `LAN_IF`
1. Change the `LAN_IP` variable to whichever IP address you want for ltsp server and save it.
1. Do a `vagrant up` from the terminal
1. You will have ltsp-server setup in standalone mode.
1. Do a `./client.sh` to start the virtual client

## Automated testing
Virtual ltsp server project supports automated testing. It is meant to be done with a single computer. `test.sh` script is used for that. 
```
./test.sh [start/stop] 
```
- Change the `STANDALONE` to `yes` or `no` to set the mode of operation of ltsp server.
- do a `./test.sh start` to start testings. you should see client booting from the server at the end of it
- do a `./test.sh stop` to stop after the test is completed. It will destroy virtual interface, ltsp-server and client.

## Vagrant Commands

- `vagrant up`

	This command will start the vagrant box and also install and configure LTSP if ran for the first time.
	
- `vagrant status`

	This will tell the current state of the vagrant box. Whether it is running, powered off or not created.
	
- `vagrant provision`

   This will run the provisioner script defined.
	
- `vagrant halt`

	This stops the ltsp server vagrant box.
	
- `vagrant destroy`

	This command will completely destroy the ltsp server.
	
More information about vagrant can be found on their official documentation - https://www.vagrantup.com/docs/	

Please refer to the wiki page for more details regarding Virtual LTSP Server project - https://github.com/docker-scripts/dev--LTSP/wiki

## Credits
This project is developed and maintained by [Deepanshu Gajbhiye](https://github.com/d78ui98). It is one of the [Google Summer of code](https://summerofcode.withgoogle.com/projects/#5506177505427456) Project. Here is the final report for it: <br>
https://gist.github.com/d78ui98/138c986dffc4d7a094e3ec1c63b545ba

I would like to thank [Dashamir Hoxha](https://github.com/dashohoxha) and [Akash Shende](https://github.com/akash0x53) for guiding, helping and mentoring for this project.

