#!/bin/bash

apt-get update
apt-get install wireguard awscli -y

curl -L -o /bin/aws-env https://github.com/in4it/aws-env/releases/download/v0.7/aws-env-linux-amd64
chmod +x /bin/aws-env

export AWS_ENV_PATH=${aws_env_path}
export KMS_ID=${kms_id}
export AWS_REGION=${aws_region}
eval $(/bin/aws-env)


# wireguard setup
export AWS_PUBLIC_IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4 -s)
if [ -z "$KEY" ] ; then
  wg genkey | tee /etc/wireguard/site2site.key
  aws ssm put-parameter --region ${aws_region} --name ${aws_env_path}KEY --value site2sitekey --key-id $KMS_ID --type SecureString
else
  echo $KEY > /etc/wireguard/site2site.key
fi

if [ -z "$PUBLIC_KEY" ] ; then
  cat /etc/wireguard/site2site.key | wg pubkey | tee /etc/wireguard/site2site.pub
  aws ssm put-parameter --region ${aws_region} --name ${aws_env_path}PUBLIC_KEY --value site2sitepubkey --key-id $KMS_ID --type SecureString
else
  echo $PUBLIC_KEY > /etc/wireguard/site2site.pub
fi



echo "[Interface]
PostUp = wg set %i private-key /etc/wireguard/%i.key
Address = $VPN_INTERNAL_CIDR
ListenPort = 51820

[Peer]
PublicKey = ${vpn_destination_pubkey}
AllowedIPs = $VPN_DESTINATION_ALLOWED_IPS,$VPN_INTERNAL_CIDR
Endpoint = ${vpn_destination_public_ip}:51000" > /etc/wireguard/site2site.conf

systemctl enable --now wg-quick@site2site