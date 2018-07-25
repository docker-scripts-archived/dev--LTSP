# mode of operation. yes for standalone mode. no for normal mode
# refer this - https://github.com/docker-scripts/dev--LTSP/wiki/LTSP-Modes-of-Operation 
STANDALONE="no"

# IP address of ltsp server
LAN_IP="192.168.111.16"

# Interface used by ltsp server, client and dhcp server. 
# Will be automatically set by test.sh.
LAN_IF=""

# List of extra packages to be installed on ltsp server.
# Example user can define ubuntu-edu-preschool ubuntu-edu-primary, etc
PACKAGES=""

# Vagrantbox configuration
VB_IMAGE="d78ui98/linuxmint-19-xfce-32bit"
VB_RAM="1024"

# Provide Login as Guest button to directly login from client
GUEST_ACCOUNT="yes"

# Automatically login from clients
AUTOMATIC_LOGIN="no"
