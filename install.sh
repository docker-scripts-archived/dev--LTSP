#!/bin/bash -x

# Source setting.sh
source /vagrant/settings.sh

# Fetching LAN_IP and network address
if [[ ${STANDALONE,,} != yes ]]; then
   LAN_IP=$(ip addr show enp0s8 | grep -Po 'inet \K[\d.]+')
fi
NETWORK="$(echo $LAN_IP | cut -d'.' -f1-3)"

# Adding repository and Updating packages
add-apt-repository ppa:ts.sch.gr --yes
apt update --yes
apt upgrade --yes

# Installing packages
apt install --yes --install-recommends ltsp-server epoptes
# Setting type of user interface with a boot parameter - https://www.debian.org/releases/jessie/i386/ch05s03.html
DEBIAN_FRONTEND=noninteractive apt install --yes --install-recommends ltsp-client
apt install --yes python-twisted ltsp-manager 

# Adding vagrant user to group epoptes
gpasswd -a ${SUDO_USER:-$(logname)} epoptes

# Updating kernel
echo 'IPAPPEND=3' >> /etc/ltsp/update-kernels.conf
/usr/share/ltsp/update-kernels

# Configure dnsmasq
if [[ ${STANDALONE,,} == "yes" ]]; then
    ltsp-config dnsmasq --enable-dns
else
    ltsp-config dnsmasq
fi

# enabling password authentication 
sed -i /etc/ssh/sshd_config \
    -e "/PasswordAuthentication no\$/ c PasswordAuthentication yes"
service ssh restart

# Creating lts.conf
lts_path=$(ltsp-config -o lts.conf|cut -d' ' -f2)

# Client reboot issue fix (https://github.com/NetworkBlockDevice/nbd/issues/59)
echo 'INIT_COMMAND_MV_NBD_CHECKUPDATE="mv /usr/share/ldm/rc.d/I01-nbd-checkupdate /usr/share/ldm/rc.d/I01-nbd-checkupdate.orig"' \
    >> "$lts_path"

# Installing additional software
apt install --yes $PACKAGES

# Creating client image
ltsp-update-image --cleanup /

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

# Automatically login from clients 
if [[ ${AUTOMATIC_LOGIN,,} == "yes" ]]; then
    sed -i "$lts_path" \
        -e "/^#LDM_AUTOLOGIN/ a LDM_USERNAME=vagrant \nLDM_PASSWORD=vagrant" \
        -e "/^#LDM_AUTOLOGIN/ c LDM_AUTOLOGIN=True"
fi 

# Provide Login as Guest button to directly login from client
if [[ ${GUEST_ACCOUNT,,} == "yes" ]]; then
    sed -i "$lts_path" \
        -e "/^#LDM_GUESTLOGIN/ a LDM_USERNAME=vagrant \nLDM_PASSWORD=vagrant" \
        -e "/^#LDM_GUESTLOGIN/ c LDM_GUESTLOGIN=True"
fi
