#!/bin/bash

apt-get update
apt-get install wireguard awscli -y

AWS_ENV_PATH=${aws_env_path} AWS_REGION=${aws_region} eval $(/bin/aws-env)
KMS_ID=${kms_id}

# wireguard setup
export AWS_PUBLIC_IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4 -s)
if [ -z "$KEY" ] ; then
  wg genkey | tee /etc/wireguard/site2site.key
  aws ssm put-parameter --name $AWS_ENV_PATH/KEY --value site2sitekey --key-id $KMS_ID --type SecureString
else
  echo $KEY > /etc/wireguard/site2site.key
fi

if [ -z "$PUBLIC_KEY" ] ; then
  cat /etc/wireguard/site2site.key | wg pubkey | tee /etc/wireguard/site2site.pub
  aws ssm put-parameter --name $AWS_ENV_PATH/PUBLIC_KEY --value site2sitepubkey --key-id $KMS_ID --type SecureString
else
  echo $PUBLIC_KEY > /etc/wireguard/site2site.pub
fi



echo "[Interface]
PostUp = wg set %i private-key /etc/wireguard/%i.key
Address = $VPN_INTERNAL_CIDR
ListenPort = 51820

[Peer]
PublicKey = $DESTINATION_PUBKEY
AllowedIPs = $DESTINATION_CIDR,$VPN_INTERNAL_CIDR
Endpoint = $AWS_PUBLIC_IP:51000" > /etc/wireguard/site2site.conf

systemctl enable --now wg-quick@site2site
systemctl start wg-quick@wg0.service