client
nobind
dev tun
remote-cert-tls server

route-nopull
route ${first_ip} ${mask}

remote ${domain} 443 udp

auth-user-pass

<key>
[KEY]
</key>
<cert>
[CERT]
</cert>
<ca>
[CA]
</ca>
key-direction 1
<tls-auth>
[TLS-AUTH]
</tls-auth>

