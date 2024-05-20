## How to renew the openvpn server cert
To renew the cert for the VPN you should do the following steps:
**NOTE:** Replace everywhere ${domain} and ${env} with the correspondent ones.

### How to check if the certificate will expire:
```
openssl x509 -enddate -noout -in /etc/openvpn/pki/issued/${domain}.crt
```

First go to `/etc/openvpn/pki/issued` and create the `v3.ext` file to include in the cert the correct info.     

```
[v3]
authorityKeyIdentifier = keyid, issuer:always
keyUsage = digitalSignature, keyEncipherment
subjectAltName = DNS:${domain}
extendedKeyUsage = serverAuth
subjectKeyIdentifier = hash
basicConstraints = CA:FALSE
nsCertType                      = server
nsComment                       = "OpenSSL Generated Server Certificate"
```

and then:

```
openssl x509 -req -days 1825 -in ../reqs/${domain}.req -signkey /etc/openvpn/pki/private/${domain}.key -out ${domain}.crt.new -CA ../ca.crt -CAkey ../private/ca.key -CAcreateserial -extfile v3.ext -extensions v3 -clrext
```

Rename the .new cert to rewrite the old one and reboot the dockers on the EC2:

```
mv ${domain}.crt.new ${domain}.crt
systemctl restart docker-openvpn-1194-udp@${env}.service
systemctl restart docker-openvpn-443-tcp@${env}.service
```