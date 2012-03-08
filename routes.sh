#!/bin/bash
# setting routes
# script for /etc/ppp/ip-up.d/

net=0.0.0.0/32
route add -net ${net} dev ${PPP_IFACE}

# associative array subnets[GATEWAY] = {IPs list}
declare -A subnets

group=(10.10.10.10)
subnets[255.252.0.0]=${group[@]}

group=(
10.10.10.11
10.10.10.12
)
subnets[255.254.0.0]=${group[@]}

iface=eth0
gw=10.10.0.1
for mask in "${!subnets[@]}"; do
	for address in ${subnets[$mask]}; do
		route add -net ${address} netmask ${mask} dev ${iface} gw ${gw}
	done
done
