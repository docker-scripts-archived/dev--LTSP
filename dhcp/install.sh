#/bin/bash

#installation
apt --yes update
apt --yes --install-recommends install dnsmasq

#configuration
echo "dhcp-range=tftp,192.168.1.250,192.168.1.254" >> /etc/dnsmasq.conf 
service dnsmasq restart
