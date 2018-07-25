#!/bin/bash -x

echo '### Updating repositories ###'
apt update -y

echo '### Performing dist-upgrade  ###'
apt dist-upgrade -y
