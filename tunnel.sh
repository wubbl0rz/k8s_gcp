#!/bin/bash

set -e

DEFAULT_IF=$(route -n | grep -i "^0.0.0.0" | awk '{print $8}')
PROJECT_ID=$(grep project_id terraform/terraform.tfvars | cut -d "\"" -f 2)

echo "INTERFACE: $DEFAULT_IF"
echo "PROJECT: $PROJECT_ID"
echo  "====================="

wget https://github.com/xjasonlyu/tun2socks/releases/download/v2.5.0/tun2socks-linux-amd64.zip
unzip -o tun2socks-linux-amd64.zip
rm tun2socks-linux-amd64.zip

gcloud compute ssh jump --tunnel-through-iap -- 'echo OK'

{
  sleep 5
  sudo ip tuntap add mode tun dev tun0
  sudo ip addr add 198.18.0.1/15 dev tun0
  sudo ip link set dev tun0 up
  sudo ip route add 10.0.0.0/24 via 198.18.0.1 dev tun0 metric 1
  sudo ip route add 172.16.0.0/28 via 198.18.0.1 dev tun0 metric 1
  
  echo tun2socks -device tun0 -proxy socks5://localhost:1337 -interface $DEFAULT_IF
  sudo ./tun2socks-linux-amd64 -device tun0 -proxy socks5://localhost:1337 -interface $DEFAULT_IF
  
  sudo ip tuntap del mode tun dev tun0
} &

gcloud compute ssh jump --tunnel-through-iap -- -D 1337 -q -C -N

wait
