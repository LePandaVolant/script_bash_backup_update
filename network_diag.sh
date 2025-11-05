#!/bin/bash

NMAP_INSTALL=$(sudo apt install -y nmap 2>/tmp/nmap_install.log)
PING=$(ping 8.8.8.8 -c 4)
CODE=$(echo "$?")
if [ $CODE = 0 ]; then
	echo -e "REUSSITE de la connectivité Internet\n"
else
	echo -e "ECHEC de la connectivité Internet\n"
fi

IP=$(ip route | grep -oP "[\d]+[.\d]+/[\d]+")
echo -e "IP du réseau actuel : $IP\n"

SCAN=$(nmap "$IP")
echo -e "Scan nmap :\n$SCAN"

NET_INT=$(ip a)
