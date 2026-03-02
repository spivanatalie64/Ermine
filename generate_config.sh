#!/usr/bin/env bash

if test -f "Ermin.toml"; then
    echo "Existing config found, running this script will overwrite your existing config and make your previously uploaded files innaccesible. Are you sure you'd like to reconfigure?"
    select yn in "Yes" "No"; do
        case $yn in
            No ) exit;;
            Yes ) mv Ermin.toml Ermin.toml.old && mv livekit.yml livekit.yml.old && break;;
        esac
    done
fi

turn_secret=$(openssl rand -hex 24)

# set hostname for Caddy and vite variables
echo "HOSTNAME=https://$1" > .env.web
echo "DOMAIN=$1" >> .env.web
echo "EXTERNAL_IP=$2" >> .env.web
echo "ERMINE_PUBLIC_URL=https://$1/api" >> .env.web
echo "VITE_API_URL=https://$1/api" >> .env.web
echo "VITE_WS_URL=wss://$1/ws" >> .env.web
echo "VITE_MEDIA_URL=https://$1/autumn" >> .env.web
echo "VITE_PROXY_URL=https://$1/january" >> .env.web
echo "TURN_SECRET=$turn_secret" >> .env.web

# hostnames
echo "[hosts]" > Ermin.toml
echo "app = \"https://$1\"" >> Ermin.toml
echo "api = \"https://$1/api\"" >> Ermin.toml
echo "events = \"wss://$1/ws\"" >> Ermin.toml
echo "autumn = \"https://$1/autumn\"" >> Ermin.toml
echo "january = \"https://$1/january\"" >> Ermin.toml

# livekit hostname
echo "" >> Ermin.toml
echo "[hosts.livekit]" >> Ermin.toml
echo "worldwide = \"wss://$1/livekit\"" >> Ermin.toml

# VAPID keys
echo "" >> Ermin.toml
echo "[pushd.vapid]" >> Ermin.toml
openssl ecparam -name prime256v1 -genkey -noout -out vapid_private.pem
echo "private_key = \"$(base64 -i vapid_private.pem | tr -d '\n' | tr -d '=')\"" >> Ermin.toml
echo "public_key = \"$(openssl ec -in vapid_private.pem -outform DER|tail --bytes 65|base64|tr '/+' '_-'|tr -d '\n'|tr -d '=')\"" >> Ermin.toml
rm vapid_private.pem

# encryption key for files
echo "" >> Ermin.toml
echo "[files]" >> Ermin.toml
echo "encryption_key = \"$(openssl rand -base64 32)\"" >> Ermin.toml

livekit_key=$(openssl rand -hex 6)
livekit_secret=$(openssl rand -hex 24)

# livekit yml
echo "rtc:" > livekit.yml
echo "  use_external_ip: true" >> livekit.yml
echo "  port_range_start: 50000" >> livekit.yml
echo "  port_range_end: 50100" >> livekit.yml
echo "  tcp_port: 7881" >> livekit.yml
echo "" >> livekit.yml
echo "redis:" >> livekit.yml
echo "  address: redis:6379" >> livekit.yml
echo "" >> livekit.yml
echo "turn:" >> livekit.yml
echo "  enabled: true" >> livekit.yml
echo "  domain: \"$1\"" >> livekit.yml
echo "  cert_file: \"\"" >> livekit.yml
echo "  key_file: \"\"" >> livekit.yml
echo "  tls_port: 0" >> livekit.yml
echo "  udp_port: 3478" >> livekit.yml
echo "  external_ip: \"$2\"" >> livekit.yml
echo "  secret: \"$turn_secret\"" >> livekit.yml
echo "" >> livekit.yml
echo "keys:" >> livekit.yml
echo "  $livekit_key: $livekit_secret" >> livekit.yml
echo "" >> livekit.yml
echo "webhook:" >> livekit.yml
echo "  api_key: $livekit_key" >> livekit.yml
echo "  urls:" >> livekit.yml
echo "  - \"http://voice-ingress:8500/worldwide\"" >> livekit.yml

# livekit config
echo "" >> Ermin.toml
echo "[api.livekit.nodes.worldwide]" >> Ermin.toml
echo "url = \"http://livekit:7880\"" >> Ermin.toml
echo "lat = 0.0" >> Ermin.toml
echo "lon = 0.0" >> Ermin.toml
echo "key = \"$livekit_key\"" >> Ermin.toml
echo "secret = \"$livekit_secret\"" >> Ermin.toml