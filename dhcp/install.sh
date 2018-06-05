#/bin/bash

source /vagrant/settings.sh

# installation
apt --yes update
apt --yes --install-recommends install dnsmasq
export DEBIAN_FRONTEND=noninteractive
apt -yq --yes install iptables-persistent

# fetching interface name
INTERNET=$(ifconfig | grep -m 1 RUNNING | cut -d':' -f1)
LOCAL=$(ifconfig | grep -m 2 RUNNING | cut -d':' -f1 | tail -n1)

# configuration
echo "dhcp-range=tftp,${NETWORK}.250,${NETWORK}.254" >> /etc/dnsmasq.conf 
echo "net.ipv4.ip_forward=1" > /etc/sysctl.conf

# deleting existing rules
iptables --flush
iptables --table nat --flush
iptables --delete-chain
iptables --table nat --delete-chain

# IP masquerading
iptables -t nat -A POSTROUTING -o $INTERNET -j MASQUERADE
iptables -A FORWARD -i $INTERNET -o $LOCAL -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i $LOCAL -o $INTERNET -j ACCEPT

# saving IP tables rules
iptables-save > /etc/iptables.rules

# restarting service	
service dnsmasq restart
