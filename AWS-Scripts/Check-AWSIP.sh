#!/bin/bash 


wget -q  https://ip-ranges.amazonaws.com/ip-ranges.json -O ip-ranges.json
jq -r '.prefixes | .[].ip_prefix' < ip-ranges.json > cidrs

IP=$1
CIDRs=$(cat cidrs)

echo "$IP" > IP

for cidr in $CIDRs
do
	grepcidr  $cidr IP

done


