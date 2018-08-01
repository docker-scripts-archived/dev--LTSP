#!/bin/bash -x

option=$1
filename=$2

help() {
    cat <<EOF
    
$0
This script manage users accounts in bulk. It can be used to import, export, backup and restore. 

Usage:
$0 [option] [filename]
Options:
    import    This option will create users from the filename mentioned
    export    This option will export users from ltsp server to filename mentioned
    backup    This option will create a backup archive of username, encrypted password, and home directories 
    restore   This option will recreate the user accounts and their home directories from backup archive 
    
Examples:
   sudo $0 import user-accounts.txt
   sudo $0 export user-accounts.txt
   sudo $0 backup
   sudo $0 restore user-accounts.txt    
    
EOF

}

if [[ $UID != 0 ]]; then	
	echo "error: use sudo or run script as root user"	
	help
	exit 1	
fi

function create_user
{
    for line in $(cat $filename)
        do
            IFS=":"
            read -ra ARRAY <<<"$line"
            user=${ARRAY[0]}
            pass=${ARRAY[1]}
            echo adding user $user 
            useradd $user -d /home/$user -m -s /bin/bash
            echo "$user:$pass" | chpasswd
        done
}

case $1 in
    import )
        create_user
        ;;
   
    export )
       for user in $(cat /etc/shadow | grep -A 5000 vagrant | cut -f1-2 -d:)
       do
           echo "$user" >> /vagrant/$filename
       done
       ;;
    
    backup )
       cd /vagrant
       tar -pcvf 2018-user-home-dir.tar.gz /home /vagrant/user-accounts.txt
       cd -
       ;;
    
    restore )
       create_user
       cd /vagrant
       tar -xvf 2018-user-home-dir.tar.gz -C /
       cd -
       ;;
    * )
       echo "error: invalid arguments provided"
       help
       ;;
esac
