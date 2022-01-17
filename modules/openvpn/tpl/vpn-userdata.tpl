#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

#login to enter in aws cli
curl http://169.254.169.254/latest/meta-data/iam/info

apt-get update
mkdir -p /etc/openvpn
apt-get -y install docker.io awscli 

aws s3 sync s3://${project_name}-configuration-${env}/openvpn /etc/openvpn --endpoint https://s3.${aws_region}.amazonaws.com --region ${aws_region} --exclude "*issued/client*" --exclude "*private/client*"
aws s3 cp s3://${project_name}-configuration-${env}/openvpnconfig/openvpn-client.conf /etc/openvpn/openvpn-client.conf --endpoint https://s3.${aws_region}.amazonaws.com --region ${aws_region}

# Get onelogin auth
aws s3 cp s3://${project_name}-configuration-${env}/openvpnconfig/onelogin.conf /etc/openvpn/onelogin.conf --endpoint https://s3.${aws_region}.amazonaws.com --region ${aws_region}
chown nobody:nogroup /etc/openvpn/onelogin.conf
chmod 600 /etc/openvpn/onelogin.conf

#Add systemd special script for docker
echo `#
# Docker + OpenVPN systemd service
#
# Author: Kyle Manna <kyle@kylemanna.com>
# Source: https://github.com/kylemanna/docker-openvpn
#
# This service aims to make the update and invocation of the docker-openvpn
# container seamless.  It automatically downloads the latest docker-openvpn
# image and instantiates a Docker container with that image.  At shutdown it
# cleans-up the old container.
#
# In the event the service dies (crashes, or is killed) systemd will attempt
# to restart the service every 10 seconds until the service is stopped with
# `systemctl stop docker-openvpn@NAME`.
#
# A number of IPv6 hacks are incorporated to workaround Docker shortcomings and
# are harmless for those not using IPv6.
#
# To use:
# 1. Create a Docker volume container named `ovpn-data-NAME` where NAME is the
#    user's choice to describe the use of the container.
# 2. Initialize the data container according to the docker-openvpn README, but
#    don't start the container. Stop the docker container if started.
# 3. Download this service file to /etc/systemd/service/docker-openvpn@.service
# 4. Enable and start the service template with:
#    `systemctl enable --now docker-openvpn@NAME.service`
# 5. Verify service start-up with:
#    `systemctl status docker-openvpn@NAME.service`
#    `journalctl --unit docker-openvpn@NAME.service`
#
# For more information, see the systemd manual pages.
#
[Unit]
Description=OpenVPN Docker Container
Documentation=https://github.com/kylemanna/docker-openvpn
After=network.target docker.service
Requires=docker.service
[Service]
RestartSec=10
Restart=always
# Modify IP6_PREFIX to match network config
Environment="NAME=openvpn"
Environment="DATA_VOL=/etc/openvpn"
Environment="IMG=${openvpn_public_ecr}"
Environment="PORT=${vpn_port}:1194/${vpn_protocol}"
# To override environment variables, use local configuration directory:
# /etc/systemd/system/docker-openvpn@foo.d/local.conf
# http://www.freedesktop.org/software/systemd/man/systemd.unit.html
# Clean-up bad state if still hanging around
ExecStartPre=-/usr/bin/docker rm -f $$NAME
# Main process
ExecStart=/usr/bin/docker run --rm -v $${DATA_VOL}:$${DATA_VOL} -p $${PORT} --cap-add=NET_ADMIN --name $${NAME} $${IMG}
[Install]
WantedBy=multi-user.target` > /etc/systemd/system/docker-openvpn@.service

# Run container
systemctl start docker
systemctl enable docker
sleep 3
$(aws ecr get-login --no-include-email --region ${aws_region} --endpoint https://api.ecr.${aws_region}.amazonaws.com)
if [ ! -e /etc/openvpn/openvpn.conf ]; then
   echo "No config files found, generating...."
   aws s3 cp s3://${project_name}-configuration-${env}/openvpnconfig/vars /etc/openvpn/vars --endpoint https://s3.${aws_region}.amazonaws.com --region ${aws_region}
   docker run -v /etc/openvpn:/etc/openvpn --log-driver=none ${openvpn_public_ecr} ovpn_genconfig -u udp://${domain}
   docker run -v /etc/openvpn:/etc/openvpn --rm --log-driver=none -e EASYRSA_VARS_FILE=/etc/openvpn/vars ${openvpn_public_ecr} ovpn_initpki nopass
   echo "#Auth Plugin" >> /etc/openvpn/openvpn.conf
   echo "auth-user-pass-verify /bin/openvpn-onelogin-auth via-env" >> /etc/openvpn/openvpn.conf
   echo "script-security 3" >> /etc/openvpn/openvpn.conf
   docker run --log-driver=awslogs --log-opt awslogs-region=${aws_region} --log-opt awslogs-group=${log_group} -v /etc/openvpn:/etc/openvpn --restart=always -d -p ${vpn_port}:1194/${vpn_protocol} --cap-add=NET_ADMIN --name openvpn ${openvpn_public_ecr}
   aws s3 sync /etc/openvpn s3://${project_name}-configuration-${env}/openvpn --endpoint https://s3.${aws_region}.amazonaws.com --region ${aws_region}
else
   echo "Config files found, starting OpenVPN..."
   docker run --log-driver=awslogs --log-opt awslogs-region=${aws_region} --log-opt awslogs-group=${log_group} -v /etc/openvpn:/etc/openvpn -d -p ${vpn_port}:1194/${vpn_protocol} --cap-add=NET_ADMIN --name openvpn ${openvpn_public_ecr}
fi
