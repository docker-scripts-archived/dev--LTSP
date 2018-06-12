# Virtual LTSP Server

## Description
Virtual LTSP server with vagrant and/or docker-scripts. [LTSP](http://www.ltsp.org/) allows computers of a LAN to boot through the network from a single server. Same can be done with VirtualBox. So we have created a vagrant script to install `LTSP` to a vagrant box.

## Prerequisites
For this project, there are two requirements. Also, it is recommended to use the latest version for these two -

- [Virtualbox](http://virtualbox.org) 
- [Vagrant](https://vagrantup.com)

## Server Installation

```
git clone https://github.com/docker-scripts/dev--LTSP.git -b bionic
cd dev--LTSP
vagrant plugin install vagrant-vbguest
vagrant up
```

Users need to install `vagrant-vbguest` to keep VirtualBox Guest Additions up to date.(refer [fujimakishouten/vagrant-boxes#1](https://github.com/fujimakishouten/vagrant-boxes/issues/1) for more details).

 LTSP server has two main modes of operation: standalone and non-standalone. These depend on whether we have a DHCP server on the LAN or not.

1. **Standalone** means that the LTSP server also provides DHCP service to the clients. The vagrant boxes have NAT configured Inside them. Same can be used clients can have access to internet through LTSP server, the gateway to the internet.

1. **Non-standalone** means that the LTSP server does not provide IP addresses (DHCP service) to the clients, but there is another (existing) DHCP server on the LAN that does this. In this case, the LTSP server usually is not the gateway to the Internet.

You can refer to wiki pages for more information on modes of operation - [dev--LTSP/wiki/Mode-of-operation-LTSP](https://github.com/docker-scripts/dev--LTSP/wiki/Mode-of-operation-LTSP)

You can set the mode of operation with the help of `settings.sh` change `STANDALONE` variables value. Also you can put network address and `LAN IP`. Settings will be loaded by `Vagrantfile` and `install.sh` Then you can do a `vagrant up` and Vagrant will automatically install LTSP with the help of provisioning script. 

## Client Installation
We can make a client with the help of virtualbox

- Open virtualbox. Click `new`.
- Give your client a name. 
- Click `next`.
- In Memory size set the RAM you want for your client(recommended 512mb) and click `next`.
- Then in the hard disk selected **do not add a virtual hard disk.**
- Finally hit `create`.
- This will create a LTSP client.
- After that go to settings. Select system setting and in boot order select `network` checkbox. This will allow a network boot.
- Then go to network and selected a bridged adapter and select interface same as that of ltsp.
- Click advanced and set `promiscuous mode` to `allow all`.
- Click `OK`.
- Then click `start`. Now you can boot from virtual LTSP server.

Same can be done with a `client.sh` script. It leverages `VBoxManage` to create ltsp clients. Run the script and put name of the client as first argument. If no argument is given then the script uses default name. 
