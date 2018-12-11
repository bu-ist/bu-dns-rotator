#!/bin/sh

echo "address=/$1/`dig +short $2`" > /etc/dnsmasq.d/app.conf
supervisorctl restart dnsmasq
