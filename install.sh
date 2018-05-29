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

#setting correct dhcp-range
sed -i "s/dhcp-range=192.168.67.20,192.168.67.250,8h/dhcp-range=192.168.1.20,192.168.1.250,8h/g" /etc/dnsmasq.d/ltsp-server-dnsmasq.conf
service dnsmasq restart	

#Reading setting.sh file
cd /vagrant
read -a arr < settings.sh
echo ${arr[0]} 
var=${arr[0]}
response=($(echo "$var" | tr '=' '\n'))

#Setting mode of operation of ltsp server
if [ "${response[1]}" == "Yes" ] || [ "${response[1]}" == "yes" ]; then
	echo "LTSP server will be in standalone mode of operation"	
	echo "LTSP server will provide DHCP services.."
	sed -i "15 s/dhcp-range=10.0.2.0,proxy/#dhcp-range=10.0.2.0,proxy/g" /etc/dnsmasq.d/ltsp-server-dnsmasq.conf
	sed -i "16 s/dhcp-range=192.168.1.0,proxy/#dhcp-range=192.168.1.0,proxy/g" /etc/dnsmasq.d/ltsp-server-dnsmasq.conf
	service dnsmasq restart
elif [ "${response[1]}" == "No" ] || [ "${response[1]}" == "no" ]; then
	echo "LTSP server will be in Non-standalone mode of operation"	
	echo "There is an existing DHCP server running"
	echo "LTSP server won't provide DHCP services.."
	sed -i "15,16 s/#//g" /etc/dnsmasq.d/ltsp-server-dnsmasq.conf
	service dnsmasq restart
else
	echo "Invalid response provided in settings.sh"
fi
