#!/bin/bash

apt-get update
apt-get install ca-certificates curl gnupg awscli git binutils -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# efs helper
cd /root
git clone https://github.com/aws/efs-utils
cd efs-utils
./build-deb.sh
mv ./build/amazon-efs-utils*deb /
apt-get -y install /amazon-efs-utils*deb
rm /amazon-efs-utils*deb
mkdir /efs
echo -e "${efs_fs_id}\t/efs\tefs\t_netdev,noresvport,tls" >> /etc/fstab
mount /efs

mkdir /efs/firezone
aws s3 cp s3://${s3_bucket}/firezone/docker-compose.yml /efs/firezone/

curl -L -o /bin/aws-env https://github.com/in4it/aws-env/releases/download/v0.7/aws-env-linux-amd64
chmod +x /bin/aws-env

cd /efs/firezone
AWS_ENV_PATH=${aws_env_path} AWS_REGION=${aws_region} /bin/aws-env --format=dotenv | sed 's#\$#\\$#g' > .env

echo "# The ability to change the IPv4 and IPv6 address pool will be removed
# in a future Firezone release in order to reduce the possible combinations
# of network configurations we need to handle.
#
# Due to the above, we recommend not changing these unless absolutely
# necessary.
WIREGUARD_IPV4_NETWORK=100.64.0.0/10
WIREGUARD_IPV4_ADDRESS=100.64.0.1
WIREGUARD_IPV6_NETWORK=fd00::/106
WIREGUARD_IPV6_ADDRESS=fd00::1" >> .env

if [ ! -e .setup-completed ] ; then 
    docker compose run --rm firezone bin/migrate
    docker compose run --rm firezone bin/create-or-reset-admin
fi


touch .setup-completed
docker compose up -d