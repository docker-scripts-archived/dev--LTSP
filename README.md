# Virtual LTSP Server

## Description
Virtual LTSP server with vagrant and/or docker-scripts. [LTSP](http://www.ltsp.org/) allows  computers of a LAN to boot through network from a single server. Same can be done with virtualbox. So we have created vagrant script to install `LTSP` to a vagrant boxes.

## Prerequisites
For this project there are two requirments. Also it is recommended to use the latest version for these two -

- [Virtualbox](http://virtualbox.org) 
- [Vagrant](https://vagrantup.com)

## Installation

```
git clone https://github.com/docker-scripts/dev--LTSP.git -b bionic
cd dev--LTSP
vagrant up
```

If you have 2 network interfaces then after doing `vagrant up` it will ask which interface you want the vagrant box to bridge with. Selected the one which has internet connection with it. 
Vagrant will automatically install LTSP with the help of provisioning script.

## Testing
Testing of LTSP server created with vagrant can be done with the help of a an LTSP client. We can make client with the help of virtualbox

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
- Then click `start`. Now you can boor from virtual LTSP server.





