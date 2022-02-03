client
nobind
dev tun
remote-cert-tls server

route-nopull
route ${first_ip} ${mask}

remote ${domain} ${vpn_port} ${vpn_protocol}

auth-user-pass
reneg-sec 0

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

