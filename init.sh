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
if [ $? -ne 0 ]
then
   echo 'failed'
   exit
else
   echo 'done'
fi

printf 'Updating /etc/hosts... '
sed -i "s/^127.0.1.1.*$/127.0.1.1 $hostname/" /etc/hosts
if [ $? -ne 0 ]
then
   echo 'failed'
   exit
else
   echo 'done'
fi

printf 'Updating active hostname... '
hostnamectl set-hostname $hostname
if [ $? -ne 0 ]
then
   echo 'failed'
   exit
else
   echo 'done'
fi

printf 'Deleting and regenerating SSH host keys... '
rm /etc/ssh/ssh_host_*
if [ $? -ne 0 ]
then
   echo 'failed deleting old SSH keys'
   exit
fi
dpkg-reconfigure openssh-server 1>/dev/null 2>/dev/nulli
if [ $? -ne 0 ]
then
   echo 'failed generating new SSH keys'
   exit
else
   echo 'done'
fi

