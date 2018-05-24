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
