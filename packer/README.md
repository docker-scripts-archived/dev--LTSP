## Introduction
Packer is an open source tool for creating identical machine images from a single source configuration.
you can read more about it here - https://www.packer.io

## Installation
```
PACKER_VERSION=1.2.5
wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip
unzip -d ~/bin packer_${PACKER_VERSION}_linux_amd64.zip
```
## Validate packer template
```
packer validate linuxmint-19-xfce-32bit.json
```

## Build linux mint vagrant box
```
packer build linuxmint-19-xfce-32bit.json
```

## Initializing vagrant box
```
vagrant box add linuxmint-19-xfce-32bit box/virtualbox/linuxmint-19-xfce-32bit-1.0.3.box 
```

## Creating  Vagrant environment
You can create any directory and create the vagrant enviroment with -
```
vagrant init linuxmint-19-xfce-32bit
vagrant up
``` 
 
## Connecting with vagrant box
```
vagrant ssh
```
