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

echo $hostname > /etc/hostname
sed -i "s/^127.0.1.1.*$/127.0.1.1 $hostname/" /etc/hosts
