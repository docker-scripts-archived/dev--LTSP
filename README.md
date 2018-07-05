# Virtual LTSP Server

## Description
Virtual LTSP server project automates installation and configuration of LTSP with vagrant and/or docker-scripts. 
[LTSP](http://www.ltsp.org/) allows computers of a LAN to boot through network from a single server. Same LTSP server can be setup on VirtualBox. So we have created a provisioner script to install and configure `LTSP` to a vagrant box. Also created other scripts to create LTSP clients and one to start a proxy dhcp server. 

## Prerequisites
For this project, there are two requirements. Also, it is recommended to use the latest version for these two -

- [Virtualbox](http://virtualbox.org) 
- [Vagrant](https://vagrantup.com)

## Modes of Operation

LTSP has 2 modes of operation of LTSP server. Standalone and Normal. These depend on whether we have a DHCP server on the LAN or not.

1. [**Standalone**](https://github.com/docker-scripts/dev--LTSP/wiki/LTSP-Modes-of-Operation#standalone) means that the LTSP server also provides DHCP service to the clients. The vagrant boxes have NAT configured Inside them. Same can be used clients can have access to internet through LTSP server, gateway for the internet.

1. [**Normal**](https://github.com/docker-scripts/dev--LTSP/wiki/LTSP-Modes-of-Operation#normal) means that the LTSP server does not provide IP addresses (DHCP service) to the clients, but there is another (existing) DHCP server on the LAN that does this. In this case the LTSP server usually is not the gateway to the Internet.

## Installation

- Clone the repository
	```
	git clone https://github.com/docker-scripts/dev--LTSP.git -b bionic
	cd dev--LTSP
	```
- Configure the `settings.sh` script. You can set the mode of operation with `STANDALONE`, IP address with `LAN_IP`, Interface with `LAN_IF`. Also add extra packages if you want.
- Settings will be loaded by `Vagrantfile`, `install.sh` and `client.sh`.
- You can do a `vagrant up` and LTSP will be installed and configured for you.
- Then start client with `./client.sh` and it will boot from the ltsp server.
- Then you can stop by `vagrant halt` and also destroy by `vagrant destroy`.

## Automated testing

Automated testing is mostly done with `test.sh` script.
    ```
    ./test.sh [start/stop]
    ```
You can do automated testing in following steps -
- Do a `./test.sh start`. It will create virtual network for testing, launch ltsp server and then starts ltsp client.​
- You should see a client booting up from the ltsp-server.
- After this you can do `./test.sh stop` to destroy dhcp-server, ltsp-server, virtual network interface and client.

## Using Virtual LTSP on real LAN

Virtual LTSP can be used on real LAN as well. In it the ltsp client and dhcp server are real ones. Steps to install ltsp are same. Set `LAN_IF` to network interface connected to the LAN. Then do a `vagrant up` to install and configure LTSP. 

### Client Installation
On the client side it is recommended to use run `client.sh` script to create LTSP client. Since it is much easier to do with script and in `setting.sh` set `LAN_IF` to network interface connected to the LAN. Then just run the script and ltsp client will be automatically created and started for you.

 If you wish you can create clients with the help of virtualbox

- Open virtualbox. Click `new`.
- Give your client a name.
- Click `next`.
- In Memory size set the RAM you want for your client and click `next`.
- Then in the hard disk selected **do not add a virtual hard disk.**
- Finally hit `create`.
- This will create a LTSP client.
- After that go to settings. Select system setting and in boot order selected `network` checkbox. This will allow a network boot.
- Then go to network and selected a bridged adapter and select network interface connected to LAN.
- Click advanced and set `promiscuous mode` to `allow all`.
- Click `OK`.
- Then click `start`. Now you can boot from virtual LTSP server.

Or you can have an actual ltsp client that works on network boot as it has no hard drive.

## Commands

- `vagrant up`

	This command will start the vagrant box and also install and configure LTSP if ran for the first time.
	
- `vagrant status`

	This will tell the current state of vagrant box. Whether it is running, powered off or not created.
	
- `vagrant halt`

	This is stop the ltsp server vagrant box.
	
- `vagrant destroy`

	This command will compeletly destroy the ltsp server.

You may refer to wiki page for more details - https://github.com/docker-scripts/dev--LTSP/wiki

## For developers and testers
If you are tester or developer or contributor to this project then you can install a plugin named `vagrant-cachier` that will reduce the time for installation of LTSP. For this plugin to work you need to make sure that firewall is turned off. Also packages like `nfscommon` and `nfs-kernel-server` are installed. If not you can install them by -
```
sudo apt install nfs-kernel-server nfs-common
```

Then You can install the plugin by - 
```
vagrant plugin install vagrant-cachier
```
The plugin will simply store all your packages installed in `~/.vagrant.d/cache`. So that they dont need to be downloaded again from the internet next time you do a `vagrant up`. You can read more about this plugin here - https://github.com/fgrehm/vagrant-cachier

