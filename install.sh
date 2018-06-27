#!/bin/bash

# Updating packages
apt --yes update
apt --yes upgrade

# Installing dependencies
apt --yes --install-recommends install dnsmasq ldm-ubuntu-theme
apt --yes --install-recommends install ltsp-server
DEBIAN_FRONTEND=noninteractive apt --yes --install-recommends install ltsp-client
apt --yes install epoptes epoptes-client

# Adding vagrant user to group epoptes
gpasswd -a ${SUDO_USER:-$USER} epoptes

# Updating kernel
echo 'IPAPPEND=3' >> /etc/ltsp/update-kernels.conf
/usr/share/ltsp/update-kernels

# Configure dnsmasq
ltsp-config dnsmasq

# enabling password authentication 
sed -i /etc/ssh/sshd_config \
    -e "/Authentication no\$/ c PasswordAuthentication yes"
service ssh restart

# Creating lts.conf
ltsp-config lts.conf

# Installing additional software
apt --yes install ubuntu-edu-preschool ubuntu-edu-primary ubuntu-edu-secondary ubuntu-edu-tertiary

# Installing ltsp-manager
echo | add-apt-repository ppa:ts.sch.gr
apt --yes update
apt --yes install ltsp-manager

# Creating client image
ltsp-update-image --cleanup /

# Source setting.sh
source /vagrant/settings.sh

# Setting dhcp-range
sed -i /etc/dnsmasq.d/ltsp-server-dnsmasq.conf \
    -e "/^dhcp-range=.*,8h\$/ c dhcp-range=${NETWORK}.20,${NETWORK}.250,8h"

# Setting mode of operation of ltsp server
if [[ ${STANDALONE,,} == "yes" ]]; then
    echo "LTSP server will be in standalone mode of operation"	
    echo "LTSP server will provide DHCP services.."	
    sed -i /etc/dnsmasq.d/ltsp-server-dnsmasq.conf \
        -e "/.*,proxy\$/ c \ " 
else
    echo "LTSP server will be in Non-standalone mode of operation"	
    echo "There is an existing DHCP server running"
    echo "LTSP server won't provide DHCP services.."
    sed -i /etc/dnsmasq.d/ltsp-server-dnsmasq.conf \
        -e "/192.168.1.0,proxy\$/ c dhcp-range=${NETWORK}.0,proxy"
fi

# Restarting service
service dnsmasq restart

# installing and enabling gui
apt --yes install xfce4 gtk2-engines-pixbuf
startxfce4&
