#!/bin/bash
#Updating system packages
apt --yes update
apt --yes upgrade

#Installing dnsmasq and ubuntu theme for LTSP display manager
apt --yes --install-recommends install dnsmasq ldm-ubuntu-theme

#Installing LTSP server and client
apt --yes --install-recommends install ltsp-server
export DEBIAN_FRONTEND=noninteractive
apt -yq --yes --install-recommends install ltsp-client

#Installing epoptes and adding user 'vagrant' to the group
apt --yes install epoptes epoptes-client
gpasswd -a ${SUDO_USER:-$USER} epoptes

#Updating kernel
echo 'IPAPPEND=3' >> /etc/ltsp/update-kernels.conf
/usr/share/ltsp/update-kernels

#configure dnsmasq
ltsp-config dnsmasq

#Creating lts.conf
ltsp-config lts.conf

#Installing Edubuntu programs
apt --yes install edubuntu-desktop
apt --yes install ubuntu-edu-preschool ubuntu-edu-primary ubuntu-edu-secondary ubuntu-edu-tertiary

#Installing ltsp-manager
add-apt-repository ppa:ts.sch.gr
apt --yes update
apt --yes install ltsp-manager

#Creating client image
ltsp-update-image --cleanup /