#!/bin/bash

apt-get update
apt-get upgrade -y
apt-get install binutils -y

# reinitialize vpn
systemctl stop vpn-rest-server
systemctl stop vpn-configmanager
wg-quick down vpn
rm -rf /vpn/config/*
rm -rf /vpn/secrets

# efs helper
cd /root
git clone https://github.com/aws/efs-utils
cd efs-utils
git checkout v1.36.0
./build-deb.sh
mv ./build/amazon-efs-utils*deb /
apt-get -y install /amazon-efs-utils*deb
rm /amazon-efs-utils*deb
echo -e "${efs_fs_id}\t/vpn/config\tefs\t_netdev,noresvport,tls" >> /etc/fstab
systemctl daemon-reload
mount /vpn/config

# set permissions
chown vpn:vpn /vpn/config
chmod 700 /vpn/config

# restart vpn
systemctl start vpn-rest-server
systemctl start vpn-configmanager