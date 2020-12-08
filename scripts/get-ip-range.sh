#!/usr/bin/env bash

wget https://ip-ranges.amazonaws.com/ip-ranges.json
jq '(.prefixes[] | select((.region=="us-east-1") and (.service=="EC2_INSTANCE_CONNECT"))).ip_prefix' < ip-ranges.json
