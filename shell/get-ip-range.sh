#!/usr/bin/env bash
echo "Retrieving CIDR range for EC2 instance connect"
wget -O - https://ip-ranges.amazonaws.com/ip-ranges.json | jq '(.prefixes[] | select((.region=="eu-central-1") and (.service=="EC2_INSTANCE_CONNECT"))).ip_prefix'
