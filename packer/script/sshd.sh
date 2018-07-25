#!/bin/bash -x

echo '### Configuring sshd_config ###'
sudo sed -i /etc/ssh/sshd_config -e \
    "/#Author*/ c AuthorizedKeysFile %h/.ssh/authorized_keys"
echo 'UseDNS no' >> /etc/ssh/sshd_config
echo 'GSSAPIAuthentication no' >> /etc/ssh/sshd_config
