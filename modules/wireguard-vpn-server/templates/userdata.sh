#!/bin/bash

apt-get update
apt-get upgrade -y
apt-get install binutils -y

# reinitialize vpn
systemctl stop vpn-rest-server
systemctl stop vpn-configmanager
wg-quick down vpn
rm -rf /vpn/config
rm -rf /vpn/secrets

# efs helper
cd /root
git clone https://github.com/aws/efs-utils
cd efs-utils
git checkout v1.36.0
# patch depreciation warning
wget https://patch-diff.githubusercontent.com/raw/aws/efs-utils/pull/217.patch
patch -p1 < 217.patch
# end patch
./build-deb.sh
mv ./build/amazon-efs-utils*deb /
apt-get -y install /amazon-efs-utils*deb
rm /amazon-efs-utils*deb
echo -e "${efs_fs_id}\t/efs\tefs\t_netdev,noresvport,tls" >> /etc/fstab
echo -e "${efs_fs_id}:/config\t/vpn/config\tefs\t_netdev,noresvport,tls" >> /etc/fstab
echo -e "${efs_fs_id}:/secrets\t/vpn/secrets\tefs\t_netdev,noresvport,tls" >> /etc/fstab
systemctl daemon-reload

# create directories and mount
mkdir -p /efs
mount /efs
mkdir -p /efs/config
chown vpn:vpn /efs/config
chmod 700 /efs
chmod 700 /efs/config
mkdir -p /efs/secrets
chmod 700 /efs/secrets

mkdir /vpn/config
mount /vpn/config
mkdir /vpn/secrets
mount /vpn/secrets

# restart vpn
systemctl start vpn-rest-server
systemctl start vpn-configmanager
