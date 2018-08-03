#!/bin/bash -x

option="$1"
filename="$2"

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
    sudo $0 backup 2018-user-home-dir.tar.gz
    sudo $0 restore 2018-user-home-dir.tar.gz  
    
EOF

}

if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]  ; then
   help
   exit 0
fi

if [[ "$UID" != 0 ]]; then	
    help
	echo "error: use sudo or run script as root user"	
	exit 1	
fi

case $option in
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
        for user in $(cat /etc/shadow | cut -d: -f1-2 | grep -v -e '*' -e '!' -e 'vagrant')
        do
            echo "$user" >> /vagrant/$filename
        done
        ;;
    
    backup )
        echo "" > /vagrant/*.txt
        for user in $(cat /etc/shadow | cut -d: -f1-2 | grep -v -e '*' -e '!' -e 'vagrant')
        do
            echo "$user" >> /vagrant/user-accounts.txt
        done
        cd /vagrant
        tar -pcvf "$filename" /home /vagrant/user-accounts.txt
        cd -
        ;;
    
    restore )
        cd /vagrant
        tar -xvf $filename -C /
        cd -
        for line in $(cat *.txt)
        do
            IFS=":"
            read -ra ARRAY <<<"$line"
            user=${ARRAY[0]}
            pass=${ARRAY[1]}
            echo adding user $user with password $pass 
            useradd $user -d /home/$user -m -s /bin/bash -p $pass
            cp -r /etc/skel/. /home/$user
        done
        ;;
        
    * )
        echo "error: invalid arguments provided"
        help
        ;;
esac
