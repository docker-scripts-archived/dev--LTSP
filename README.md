# Virtual LTSP Server

## Description
Virtual LTSP server with vagrant and/or docker-scripts. [LTSP](http://www.ltsp.org/) allows computers of a LAN to boot through network from a single server. Same can be done with VirtualBox. So we have created a vagrant script to install `LTSP` to a vagrant box.

## Prerequisites
For this project, there are two requirements. Also, it is recommended to use the latest version for these two -

- [Virtualbox](http://virtualbox.org) 
- [Vagrant](https://vagrantup.com)

## Server Installation

```
git clone https://github.com/docker-scripts/dev--LTSP.git -b bionic
cd dev--LTSP
vagrant up
```
Then you to configure the `settings.sh` script. You can set mode of operation, Network Address, LAN ip, etc. LTSP server has two main modes of operation: standalone and non-standalone. These depend on whether we have a DHCP server on the LAN or not.

1. **Standalone** means that the LTSP server also provides DHCP service to the clients. The vagrant boxes have NAT configured Inside them. Same can be used clients can have access to internet through LTSP server, gateway for the internet.

1. **Non-standalone** means that the LTSP server does not provide IP addresses (DHCP service) to the clients, but there is another (existing) DHCP server on the LAN that does this. In this case the LTSP server usually is not the gateway to the Internet.

User can put yes or no depending upon the mode of operation. Also you can put network address and LAN IP. Settings will be loaded by `Vagrantfile` and `install.sh` Then you can do a `vagrant up` and Vagrant will automatically install LTSP with the help of provisioning script. 

*Note* - If you have 2 network interfaces then after doing `vagrant up` it will ask which interface you want the vagrant box to bridge with. Selected the one which has internet connection with it. 

## Client Installation
We can make a client with the help of virtualbox

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





