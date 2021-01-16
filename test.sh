#!/usr/bin/env sh

IP="$(curl -s -4 "https://digitalresistance.dog/myIp")"
INTERNAL_IP="$(ip -4 route get 8.8.8.8 | grep '^8\.8\.8\.8\s' | grep -Po 'src\s+\d+\.\d+\.\d+\.\d+' | awk '{print $2}')"

if [[ -z "$IP" ]]; then
  echo "[F] Cannot determine external IP address."
  exit 3
fi

if [[ -z "$INTERNAL_IP" ]]; then
  echo "[F] Cannot determine internal IP address."
  exit 4
fi

echo "[*]   External IP: $IP"
echo "[*]   Internal IP: $INTERNAL_IP"
echo '[+] Starting proxy...'
