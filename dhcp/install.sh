#/bin/bash -x

source /vagrant/settings.sh
NETWORK="$(echo $LAN_IP | cut -d'.' -f1-3)"

# installation
apt --yes update
apt --yes --install-recommends install dnsmasq
DEBIAN_FRONTEND=noninteractive apt --yes install iptables-persistent

# fetching interface name
INTERNET=$(ip route | grep default | cut -d' ' -f5)
LOCAL=$(ip route | grep -v default | cut -d' ' -f3 | grep -v $INTERNET | head -1)

# configuration
echo "dhcp-range=${NETWORK}.20,${NETWORK}.250,8h" >> /etc/dnsmasq.conf

# restarting service	
service dnsmasq restart

# Enable ip forwarding
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
