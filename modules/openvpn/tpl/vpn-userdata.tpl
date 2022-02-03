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
   echo "reneg-sec 28800" >> /etc/openvpn/openvpn.conf
   %{ for listener in listeners ~}
       docker run --log-driver=awslogs --log-opt awslogs-region=${aws_region} --log-opt awslogs-group=${log_group} -v /etc/openvpn:/etc/openvpn --restart=always -d -p ${listener.port}:1194/${listener.protocol} --cap-add=NET_ADMIN --name openvpn-${listener.port}-${listener.protocol} ${openvpn_public_ecr}
   %{ endfor ~}
   aws s3 sync /etc/openvpn s3://${project_name}-configuration-${env}/openvpn --endpoint https://s3.${aws_region}.amazonaws.com --region ${aws_region}
else
   echo "Config files found, starting OpenVPN..."
   %{ for listener in listeners ~}
       docker run --log-driver=awslogs --log-opt awslogs-region=${aws_region} --log-opt awslogs-group=${log_group} -v /etc/openvpn:/etc/openvpn -d -p ${listener.port}:1194/${listener.protocol} --cap-add=NET_ADMIN --name openvpn-${listener.port}-${listener.protocol} ${openvpn_public_ecr}
   %{ endfor ~}
fi
