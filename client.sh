#!/bin/bash
#################################################
#  Simple script that creates LTSP clients 	    #
#  These clients can only boot from network	    #
#  LTSP server is running before running script	#
#################################################

clientname=''
INTERFACE=$(ip route |grep default |cut -d' ' -f5)

usage(){
cat <<-END

DESCRIPTION:

		Script that creates LTSP client.

USAGE:
		
		Simply run the script and enter the name 
		of the client when prompted.
						
OPTIONS:

		-h, --help
		Display help

END
}

create_client(){
	
	echo -n "Enter any name for LTSP client : "
	read clientname
	echo "Using ${INTERFACE}.."	
	VBoxManage createvm --name "${clientname}" --register
	cd "$HOME/VirtualBox VMs/${clientname}"
	VBoxManage modifyvm "${clientname}" --memory 1024 --acpi on\
 --boot1 net --boot2 none --boot3 none --boot4 none --nic1 bridged\
 --bridgeadapter1 eno1 --nicpromisc1 allow-all
	VBoxManage createhd --filename "$HOME/VirtualBox VMs/${clientname}/${clientname}.vdi" --size 1
	VBoxManage storagectl "${clientname}" --name "IDE Controller" --add ide
	VBoxManage startvm "${clientname}"
}


if [ "$1" == "" ]; then
  create_client
fi

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  usage
fi
