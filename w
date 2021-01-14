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
