#!/bin/bash
#### This is a simple script that creates LTSP clients 
#### These clients are diskless and only boot from network
#### So make sure LTSP server is running before executing script

cmd=$1
clientname=''

create_client(){
	
	echo -n "Enter any name for LTSP client : "
	read clientname
	VBoxManage createvm --name "$clientname" --register
	cd $HOME/VirtualBox\ VMs/$clientname
	VBoxManage modifyvm "$clientname" --memory 1024 --acpi on --boot1 net --boot2 none --boot3 none --boot4 none --nic1 bridged --bridgeadapter1 eno1 --nicpromisc1 allow-all
	VBoxManage createhd --filename "$clientname.vdi" --size 1
	VBoxManage storagectl "$clientname" --name "IDE Controller" --add ide
	VBoxManage startvm "$clientname"
}

control_client(){
	
  echo -n "choose an option(poweroff/reset/) : "
	read cmd  
	case $cmd in
  	off|poweroff)
			echo "powering off $clientname"
			VBoxManage controlvm "$clientname" poweroff			
			;;
		pause)
			echo "pausing off $clientname"
			VBoxManage controlvm "$clientname" pause			
			;;
		reset)
			echo "reseting off $clientname"
			VBoxManage controlvm "$clientname" reset			
			;;
		*)
			echo "Unknown option"
	esac
}

if [ "$1" == "" ]; then
  create_client
	control_client
fi

