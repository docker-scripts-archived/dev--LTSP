#/bin/bash

source /vagrant/settings.sh

#installation
apt --yes update
apt --yes --install-recommends install dnsmasq

#configuration
echo "dhcp-range=tftp,${NETWORK}.250,${NETWORK}.254" >> /etc/dnsmasq.conf 
service dnsmasq restart
	

