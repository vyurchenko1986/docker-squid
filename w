squid 4.13
Alpine 3.12.3
alpine:3.12.3

docker run -ti alpine:3.12.3

FROM alpine:3.12.3
LABEL maintainer="vyurchenko1986@gmail.com"
RUN apk add --no-cache \
    squid=3.5.27-r0 \
    openssl=1.0.2p-r0 \
    ca-certificates && \
    update-ca-certificates

docker run -ti alpine:3.12.3
apk update && \
apk add --no-cache squid=4.13-r0 openssl mc tree nano


https://wiki.yola.ru/squid/squid
https://veesp.com/ru/blog/squid-authentication/
https://veesp.com/ru/blog/how-to-setup-squid-on-ubuntu/


docker run -p 3128:3128 -p 4128:4128 -ti alpine:3.12.3
apk update && \
apk add --no-cache squid=4.13-r0 apache2-utils openssl mc tree nano

touch /etc/squid/squidusers
htpasswd -c /etc/squid/squidusers vyurchenko
chmod 440 /etc/squid/squidusers
chown squid:squid /etc/squid/squidusers

cp /etc/squid/squid.conf /etc/squid/squid.conf.old
nano /etc/squid/squid.conf

auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/squidusers
auth_param basic children 3
auth_param basic realm Corporate proxy server Squid
auth_param basic credentialsttl 2 hours
auth_param basic casesensitive off
auth_param basic blankpassword off
authenticate_cache_garbage_interval 1 hour
authenticate_ttl 1 hour
authenticate_ip_ttl 10 seconds

acl basic-auth proxy_auth REQUIRED
http_access allow basic-auth

SQUID=$(/usr/bin/which squid)
exec "$SQUID" -NYCd 1 -f /etc/squid/squid.conf

tech-net.pp.ua
/usr/libexec/squid/security_file_certgen -c -s /var/cache/squid/ssl_db -M 4MB


------
В том же конфигурационном файле к директиве http_port добавьте опцию tcpkeepalive:
http_port 3128 tcpkeepalive=60,30,3


ENV TZ=Europe/Kiev
RUN apk update
RUN apk upgrade
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apk add --update tzdata
RUN rm -rf /var/cache/apk/*

----
#!/usr/bin/env bash

docker exec -i -t 6ee6223a3ce3 bash

MAINTAINER Valery Yurchenko "vyurchenko1986@gmail.com"

----
TMPDIR="$(mktemp -d)"
cd $TMPDIR
...
rm -rf $TMPDIR

----
rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

---
SQUID_DATA="squid_data"
docker volume create --name $SQUID_DATA
docker build -t squid_test .
docker run -d -p 9012:9012 --name=squid --restart=always -v $SQUID_DATA:/etc/squid squid_test

---
mkdir -p /usr/share/squid/errors/
ls -la /usr/share/squid/errors/

---
sudo nano /etc/ssh/sshd_config
AddressFamily inet
sudo netstat -tlp

---
cd /home/vyurchenko/data && \
rm -rfv docker-squid/ && \
git clone https://github.com/vyurchenko1986/docker-squid.git && \
cd docker-squid/test/build/ && \
chmod +x build_in_container.sh && ./build_in_container.sh && \
sudo cat /var/lib/docker/volumes/squid_data/_data/squidusers.txt

---
find /var/log/ -type f -mtime -1 -exec tail -Fn0 {} +

---
https://aws.amazon.com/ru/blogs/security/how-to-add-dns-filtering-to-your-nat-instance-with-squid/

---
https://habr.com/ru/company/acribia/blog/448704/
https://dev-sec.io/baselines/docker/
https://question-it.com/questions/540282/kak-zapustit-cron-kak-root-v-alpine
https://github.com/gliderlabs/docker-alpine/issues/381#issuecomment-621946699

---
https://github.com/TelegramMessenger/MTProxy
https://hub.docker.com/r/telegrammessenger/proxy
docker run -d -p 8888:8888 --name=mtproto-proxy --restart=always -v proxy-config:/data telegrammessenger/proxy:latest
docker logs mtproto-proxy

docker run -d -p 8888:443 --name=mtproto-proxy --restart=always -v mtproto_proxy_data:/data -e SECRET=XXXX -e TAG=XXX telegrammessenger/proxy:latest

---
Private Subnet
Pulic Subnet
Guest Subnet

---
https://upcloud.com/community/tutorials/install-fail2ban-debian/
sudo apt install fail2ban
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo nano /etc/fail2ban/jail.local

[DEFAULT]
ignoreip = 127.0.0.1
bantime  = 3600
findtime = 600
maxretry = 3

[sshd]
enabled = true

sudo service fail2ban restart
sudo iptables -L

# sudo fail2ban-client set <jail> banip/unbanip <ip address>
# For example
sudo iptables -L f2b-sshd --line-numbers -v -n
sudo iptables -L f2b-sshd --line-numbers -v -n | grep 88.155.96.38
sudo fail2ban-client set sshd unbanip 83.136.253.43

---
https://wiki.yola.ru/grandstream/grandstream

---
sudo nano /usr/local/bin/up
#!/usr/bin/env bash
# Ubuntu upgrade script
echo "Lets Upgrade Begin!"
sudo dpkg --configure -a && \
sudo apt install -f -y && \
sudo apt update && \
sudo apt upgrade -y && \
sudo apt dist-upgrade -y && \
sudo purge-old-kernels -y && \
sudo apt autoremove -y && \
sudo apt autoclean
exit 0

sudo chmod +x /usr/local/bin/up
---
sudo nano /usr/local/bin/myip
#!/usr/bin/env bash

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

sudo chmod +x /usr/local/bin/myip
