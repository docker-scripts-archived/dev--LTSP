# Virtual LTSP Server

## Description
Virtual LTSP server with vagrant and/or docker-scripts. [LTSP](http://www.ltsp.org/) allows computers of a LAN to boot through network from a single server. Same can be done with VirtualBox. So we have created a vagrant script to install `LTSP` to a vagrant box. Also created other scripts to create LTSP clients and also created one to start a proxy dhcp server.

## Prerequisites
For this project, there are two requirements. Also, it is recommended to use the latest version for these two -

- [Virtualbox](http://virtualbox.org) 
- [Vagrant](https://vagrantup.com)

## Server Installation

Before installation you should know that there are 2 modes of operation of LTSP server. Standalone and Normal. These depend on whether we have a DHCP server on the LAN or not.

1. [**Standalone**](https://github.com/docker-scripts/dev--LTSP/wiki/LTSP-Modes-of-Operation#standalone) means that the LTSP server also provides DHCP service to the clients. The vagrant boxes have NAT configured Inside them. Same can be used clients can have access to internet through LTSP server, gateway for the internet.

1. [**Normal**](https://github.com/docker-scripts/dev--LTSP/wiki/LTSP-Modes-of-Operation#normal) means that the LTSP server does not provide IP addresses (DHCP service) to the clients, but there is another (existing) DHCP server on the LAN that does this. In this case the LTSP server usually is not the gateway to the Internet.
First you need to clone the repository. You can easily do it by.
```
git clone https://github.com/docker-scripts/dev--LTSP.git -b bionic
cd dev--LTSP
```
Then you to configure the `settings.sh` script. You can set mode of operation, Network Address, LAN ip, etc.These settings will be loaded by `Vagrantfile`,`install.sh` and `client.sh`. Then you need to run `test.sh`. you can refer its help menu on how to use it. It will create a virtual adapter for communication of ltsp server and client also for dhcp server. You can create it by `test.sh start`. Then you can do a `vagrant up`. Vagrant will automatically install LTSP with the help of provisioning script. 

## Client Installation
It is recommended to use run `client.sh` to create LTSP client. Since it is much easier to do with script and all settings required preloaded. Just run the script and ltsp client will be automatically created and started for you.

 If you wish you can create clients with the help of virtualbox

- Open virtualbox. Click `new`.
- Give your client a name. I will name mine as ubuntultspclient.
- Click `next`.
- In Memory size set the RAM you want for your client and click `next`.
- Then in the hard disk selected **do not add a virtual hard disk.**
- Finally hit `create`.
- This will create a LTSP client.
- After that go to settings. Select system setting and in boot order selected `network` checkbox. This will allow a network boot.
- Then go to network and selected a bridged adapter and select ethernet interface.
- Click advanced and set `promiscuous mode` to `allow all`.
- Click `OK`.
- Then click `start`. Now you can boot from virtual LTSP server.

