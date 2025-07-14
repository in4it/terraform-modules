#!/bin/bash -x
apt-get update
apt-get upgrade -y
apt-get install binutils build-essential git pkg-config libssl-dev -y

## Install Rust / Cargo 
# /root/.cargo/env adding wrong path variable so I add it manually with export
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /root/rustup.sh && chmod +x /root/rustup.sh && /root/rustup.sh -y
export PATH="/root/.cargo/bin:$PATH"
rustc --version
cargo --version

# reinitialize vpn
systemctl stop vpn-rest-server
systemctl stop vpn-configmanager
wg-quick down vpn
rm -rf /vpn/config
rm -rf /vpn/secrets
rm -rf /vpn/tls-certs

# efs helper
cd /root
git clone https://github.com/aws/efs-utils
cd efs-utils
git switch v2.3.1 --detach
./build-deb.sh
chmod 755 ./build/amazon-efs-utils*deb
apt-get -y install ./build/amazon-efs-utils*deb

# Clean up packages after efs installation
rustup self uninstall -y
apt-get remove --purge -y binutils build-essential git pkg-config libssl-dev
apt-get autoremove -y
apt-get clean

# set mounts in fstab
echo -e "${efs_fs_id}\t/efs\tefs\t_netdev,noresvport,tls" >> /etc/fstab
echo -e "${efs_fs_id}:/config\t/vpn/config\tefs\t_netdev,noresvport,tls" >> /etc/fstab
echo -e "${efs_fs_id}:/secrets\t/vpn/secrets\tefs\t_netdev,noresvport,tls" >> /etc/fstab
echo -e "${efs_fs_id}:/tls-certs\t/vpn/tls-certs\tefs\t_netdev,noresvport,tls" >> /etc/fstab
echo -e "${efs_fs_id}:/stats\t/vpn/stats\tefs\t_netdev,noresvport,tls" >> /etc/fstab

# require mounts before starting the vpn server
sed -i 's#\[Unit\]#[Unit]\nRequires=vpn-config.mount vpn-secrets.mount\nAfter=vpn-config.mount vpn-secrets.mount#' /etc/systemd/system/vpn-configmanager.service
sed -i 's#\[Unit\]#[Unit]\nRequires=vpn-config.mount vpn-secrets.mount\nAfter=vpn-config.mount vpn-secrets.mount#' /etc/systemd/system/vpn-rest-server.service

# reload systemd
systemctl daemon-reload

# create directories and mount
mkdir -p /efs
mount /efs
mkdir -p /efs/config
mkdir -p /efs/secrets
mkdir -p /efs/tls-certs
mkdir -p /efs/stats
chown vpn:vpn /efs/config
chown vpn:vpn /efs/tls-certs
chown vpn:vpn /efs/stats
chmod 700 /efs
chmod 700 /efs/config
chmod 700 /efs/tls-certs
chmod 700 /efs/secrets
chmod 700 /efs/stats

mkdir /vpn/config
mount /vpn/config
mkdir /vpn/secrets
mount /vpn/secrets
mkdir /vpn/tls-certs
mount /vpn/tls-certs
mkdir /vpn/stats
mount /vpn/stats

# restart vpn
systemctl start vpn-rest-server
systemctl start vpn-configmanager
