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
    -h, --help  Display this help message
    import      This option will create users from the filename mentioned
    export      This option will export users from ltsp server to filename mentioned
    backup      This option will create a backup archive of username, encrypted password, and home directories 
    restore     This option will recreate the user accounts and their home directories from backup archive 
    
Examples:
   sudo $0 import user-accounts.txt
   sudo $0 export user-accounts.txt
   sudo $0 backup
   sudo $0 restore user-accounts.txt    
    
EOF

}

if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]  ; then
   help
   exit 1
fi

if [[ $UID != 0 ]]; then	
	echo "error: use sudo or run script as root user"	
	help
	exit 1	
fi

case $1 in
    import )
        for line in $(cat $filename)
        do
            IFS=":"
            read -ra ARRAY <<<"$line"
            user=${ARRAY[0]}
            pass=${ARRAY[1]}
            echo adding user $user with password $pass 
            useradd $user -d /home/$user -m -s /bin/bash
            echo "$user:$pass" | chpasswd
        done
        ;;
   
    export )
        echo "" > /vagrant/$filename
        normal_user=$(awk -F: '($3>=1001)&&($1!="nobody"){print $1; exit}' /etc/passwd)
        for user in $(cat /etc/shadow | grep -A 5000 $normal_user | cut -f1-2 -d:)
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
