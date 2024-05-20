## How to renew the openvpn server cert
To renew the cert for the VPN you should do the following steps:

First go to `/etc/openvpn/pki/issued` and create the `v3.ext` file to include in the cert the correct info.     
**NOTE:** Replace everywhere ${domain} with the correspondent one.

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
openssl x509 -req -days 1825 -in ../reqs/${domain}.req -signkey /etc/openvpn/pki/private/${domain}.key -out ${domain}.com.crt.new -CA ../ca.crt -CAkey ../private/ca.key -CAcreateserial -extfile v3.ext -extensions v3 -clrext
```

Rename the .new cert to rewrite the old one and reboot the dockers on en ec2 machine:

```
cp -p ${domain}.crt.new ${domain}.crt
systemctl restart docker-openvpn-1194-udp@staging.service
systemctl restart docker-openvpn-443-tcp@staging.service
```