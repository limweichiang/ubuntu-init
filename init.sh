#!/bin/bash

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
