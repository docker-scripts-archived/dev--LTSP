#!/bin/bash

#Updating packages
apt-get --yes update
apt-get --yes upgrade

#Installing dependencies
apt-get --yes --install-recommends install dnsmasq ldm-ubuntu-theme
apt-get --yes --install-recommends install ltsp-server
export DEBIAN_FRONTEND=noninteractive
apt-get -yq --yes --install-recommends install ltsp-client
apt-get --yes install epoptes epoptes-client


#Adding vagrant user to group epoptes
gpasswd -a ${SUDO_USER:-$USER} epoptes

#Updating kernel
echo 'IPAPPEND=3' >> /etc/ltsp/update-kernels.conf
/usr/share/ltsp/update-kernels

#configure dnsmasq
ltsp-config dnsmasq

#Creating lts.conf
ltsp-config lts.conf

#Installing additional software
apt-get --yes install edubuntu-desktop
apt-get --yes install ubuntu-edu-preschool ubuntu-edu-primary ubuntu-edu-secondary ubuntu-edu-tertiary

#Installing ltsp-manager
add-apt-repository ppa:ts.sch.gr
apt-get --yes update
apt-get --yes install ltsp-manager

#Creating client image
ltsp-update-image --cleanup /

#source setting.sh
source /vagrant/settings.sh

#setting dhcp-range
sed -i /etc/dnsmasq.d/ltsp-server-dnsmasq.conf -e "/8h$/ c dhcp-range=${NETWORK}.20,${NETWORK}.250,8h"

#Setting mode of operation of ltsp server
if [[ ${STANDALONE,,} == "yes" ]]; then
	echo "LTSP server will be in standalone mode of operation"	
	echo "LTSP server will provide DHCP services.."	
	sed -i /etc/dnsmasq.d/ltsp-server-dnsmasq.conf -e "/192.168.1.0,proxy$/ c #dhcp-range=${NETWORK}.0,proxy"
	sed -i /etc/dnsmasq.d/ltsp-server-dnsmasq.conf -e "/10.0.2.0,proxy$/ c #dhcp-range=10.0.2.0,proxy"
elif [[ ${STANDALONE,,} == "no" ]]; then
	echo "LTSP server will be in Non-standalone mode of operation"	
	echo "There is an existing DHCP server running"
	echo "LTSP server won't provide DHCP services.."
	sed -i /etc/dnsmasq.d/ltsp-server-dnsmasq.conf -e "/192.168.1.0,proxy$/ c dhcp-range=${NETWORK}.0,proxy"
	sed -i /etc/dnsmasq.d/ltsp-server-dnsmasq.conf -e "/10.0.2.0,proxy$/ c dhcp-range=10.0.2.0,proxy"
else
	echo "Invalid response provided in settings.sh"
fi

service dnsmasq restart
