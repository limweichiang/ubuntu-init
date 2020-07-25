#!/bin/bash

# Check for root; If not root, nothing can be done.
if [ $(id -u) -ne 0 ]
    then echo "Please run this as root or with root priviledges"
    exit
fi

# Install 'yq', needed for editing network configuration.
if ! snap list yq 2>/dev/null | grep -q yq; then
    echo "Packege 'yq' not found. Installing..."
    snap install yq
fi

echo '######################################################################'
echo '# Provide provisioning parameters for this system. Enter <Ctrl-C> to #'
echo '# restart the process.                                               #'
echo '######################################################################'
echo ''
read -p 'Enter hostname: ' hostname
read -p 'Enter IP address: ' ipaddress
read -p 'Enter subnet maks: ' subnetmask
read -p 'Enter default gateway: ' defaultgateway

printf 'Updating /etc/hostname... '
echo $hostname > /etc/hostname
echo 'done'

printf 'Updating /etc/hosts... '
sed -i "s/^127.0.1.1.*$/127.0.1.1 $hostname/" /etc/hosts
echo 'done'

printf 'Updating active hostname... '
hostnamectl set-hostname $hostname
echo 'done'

printf 'Deleting and regenerating SSH host keys... '
rm /etc/ssh/ssh_host_*
dpkg-reconfigure openssh-server 1>/dev/null 2>/dev/null
echo 'done'
