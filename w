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
https://serveradmin.ru/nastroyka-servera-telefonii-asterisk-s-nulya/#Zasita_asterisk_s_pomosu_fail2ban
http://wiki.pro-voip.ru/fail2ban/asterisk-fail2ban.html
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

sudo systemctl enable fail2ban
sudo service fail2ban restart
sudo iptables -L

# sudo fail2ban-client set <jail> banip/unbanip <ip address>
# For example
sudo iptables -L f2b-sshd --line-numbers -v -n
sudo iptables -L f2b-sshd --line-numbers -v -n | grep 138.201.90.212
sudo fail2ban-client set sshd unbanip 138.201.90.212

--
nano /etc/asterisk/logger_logfiles_custom.conf
messages => notice,warning,error
asterisk -rx "logger reload"
sudo service fail2ban restart
sudo iptables -L f2b-asterisk-tcp --line-numbers -v -n
sudo iptables -L f2b-asterisk-udp --line-numbers -v -n
sudo iptables -L f2b-asterisk-tcp --line-numbers -v -n | grep 138.201.90.212
sudo iptables -L f2b-asterisk-udp --line-numbers -v -n | grep 138.201.90.212
sudo fail2ban-client set asterisk unbanip 138.201.90.212

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

---
Mikrotik и Hairpin Nat
https://wiki.rtzra.ru/software/mikrotik/mikrotik-hairpin-nat

Hairpin nat - это когда требуется попасть из локальной сети на локальный же ресурс, но на маршрутизаторе трафик обрубается.
В данном примере пробрасываем порты 80 и 443
192.168.88.0/24 - наша подсеть
XXX.XXX.XXX.XXX - внешний IP-адрес
192.168.88.5 - сервер, куда делать проброс

/ip firewall nat
add chain=dstnat action=dst-nat to-addresses=192.168.88.5 protocol=tcp dst-address=XXX.XXX.XXX.XXX in-interface-list=WAN dst-port=80 comment="Hairpin NAT for HTTP"
add chain=dstnat action=dst-nat to-addresses=192.168.88.5 protocol=tcp dst-address=XXX.XXX.XXX.XXX in-interface-list=WAN dst-port=443 comment="Hairpin NAT for HTTPS"
add chain=dstnat action=dst-nat to-addresses=192.168.88.5 protocol=tcp src-address=192.168.88.0/24 dst-address=XXX.XXX.XXX.XXX dst-port=80 comment="Hairpin NAT for HTTP"
add chain=dstnat action=dst-nat to-addresses=192.168.88.5 protocol=tcp src-address=192.168.88.0/24 dst-address=XXX.XXX.XXX.XXX dst-port=443 comment="Hairpin NAT for HTTPS"

---
sudo lsof -i

---
https://wiki.yola.ru/grandstream/grandstream
http://www.grandstream.com/support/tools
http://firmware.grandstream.com/Release_Note_GXP16xx_1.0.7.6.pdf
http://www.grandstream.com/sites/default/files/Faq/gs_provisioning_guide_public.pdf
http://www.grandstream.com/sites/default/files/Resources/config-template.zip
http://www.grandstream.com/sites/default/files/Resources/xml_configuration_file_generator_v1.8.zip
https://help.mobilon.ru/equipment/ip/grandstream-gxp16xx/


cfg000b82f81d21.xml:

<!--  Configuration Template For GXP1610/1620/1625/1628/1630 -->
<?xml version="1.0" encoding="UTF-8" ?>
<gs_provision version="1">
    <mac>000b82f81d21</mac>
    <config version="1">
        <!-- ############################################################### -->
        <!-- ### Account 1/General Settings ### -->
        <!-- ############################################################### -->
        <P271>1</P271> <!--Account Active. 0 - No, 1 - Yes.-->
        <P270>323 Юрченко Валерий</P270> <!-- Account Name -->
        <P47>ats.primary.study.com</P47> <!-- SIP Server -->
        <P2312>ats.secondary.study.com</P2312> <!-- Secondary SIP Server -->
        <P35>323</P35> <!-- SIP User ID -->
        <P36>323</P36> <!-- Authenticate ID -->
        <P34>Password</P34> <!-- Authenticate Password -->
        <P3>Юрченко Валерий</P3> <!-- Name -->
        <!-- ###  Account 1/Network Settings ### -->
        <P52>2</P52> <!-- NAT Traversal. 0 - No, 1 - STUN, 2 - keep alive, 3 - UPnP, 4 - Auto, 5 - VPN. Default is 0. -->
        <!-- ### Account 1/SIP Settings/Basic Settings ### -->
        <P32>5</P32> <!-- Register Expiration (in minutes). Default is 60. Max about 45 days -->
        <P2397>1</P2397> <!-- Enable OPTIONS Keep Alive -->
        <!-- ### Account 1/Call Settings ### -->
        <P129>1</P129> <!-- Anonymous Call Rejection. 0 - No, 1 - Yes. Default is 0 -->
        <!-- ### Account 1/SIP Settings/Security Settings ### -->
        <P2347>1</P2347> <!-- Accept Incoming SIP from Proxy Only. 0 - No, 1 - Yes. Default is 0 -->

        <!-- ############################################################### -->
        <!-- ### Account 2/General Settings ### -->
        <!-- ############################################################### -->
        <P401>1</P401> <!--Account Active. 0 - No, 1 - Yes.-->
        <P417>3230 Юрченко Валерий</P417> <!-- Account Name -->
        <P402>ats.primary.study.com</P402> <!-- SIP Server -->
        <P2412>ats.secondary.study.com</P2412> <!-- Secondary SIP Server -->
        <P404>3230</P404> <!-- SIP User ID -->
        <P405>3230</P405> <!-- Authenticate ID -->
        <P406>Password</P406> <!-- Authenticate Password -->
        <P407>Юрченко Валерий</P407> <!-- Name -->
        <!-- ###  Account 1/Network Settings ### -->
        <P414>2</P414> <!-- NAT Traversal. 0 - No, 1 - STUN, 2 - keep alive, 3 - UPnP, 4 - Auto, 5 - VPN. Default is 0. -->
        <!-- ### Account 1/SIP Settings/Basic Settings ### -->
        <P412>5</P412> <!-- Register Expiration (in minutes). Default is 60. Max about 45 days -->
        <P2497>1</P2497> <!-- Enable OPTIONS Keep Alive -->
        <!-- ### Account 1/Call Settings ### -->
        <P446>1</P446> <!-- Anonymous Call Rejection. 0 - No, 1 - Yes. Default is 0 -->
        <!-- ### Account 1/SIP Settings/Security Settings ### -->
        <P2447>1</P2447> <!-- Accept Incoming SIP from Proxy Only. 0 - No, 1 - Yes. Default is 0 -->
        <!-- ############################################################### -->

        <!-- ###  Settings/General Settings ### -->
        <P78>1</P78> <!-- Use Random Port. 0 - No, 1 - Yes. Default is 0 -->

        <!-- ### Settings/Call Features ### -->
        <P91>0</P91> <!-- Disable Call Waiting. 0 - No, 1 - Yes. Default is 0 -->

        <!-- ### Maintenance/Upgrade and Provisioning ### -->
        <P212>0</P212> <!-- Config Upgrade Via. 0 - TFTP -->
        <P1359>Password</P1359> <!-- XML Config File Password -->
        <P240>0</P240> <!-- Authenticate Conf File. 0 - No, 1 - Yes. -->

        <!-- ### Network/Basic Settings ### -->
        <P146>SIP-STUDY</P146> <!-- Host name  -->
        <P1415>2</P1415> <!-- Internet Protocol. IPv4 Only -->
        <P8>0</P8> <!-- IP Address Mode. DHCP -->

        <!-- ### Network/Advanced Settings ### -->
        <P1348>0</P1348> <!-- PC Port Mode. 0 - Enable, 1 - Disabled, 2 - Mirrored. Default is 0 -->
        <P229>20</P229> <!-- PC Port VLAN Tag -->

        <!-- ### Maintenance/Language ### -->
        <P1362>ru</P1362> <!-- Display Language. Default is auto -->

        <!-- ### Settings/Preferences/Date and Time ### -->
        <P30>ua.pool.ntp.org</P30> <!-- NTP Server -->
        <P144>1</P144> <!-- Allow DHCP Option 42 to override NTP server. 0 - No, 1 - Yes. Default is 1 -->
        <P64>EET-2EEST,M3.5.0/3,M10.5.0/4</P64> <!-- Time Zone -->
        <P143>1</P143> <!-- Allow DHCP Option 2 to override Time Zone setting. 0 - No, 1 - Yes. Default is 1 -->
        <P246>EET-2EEST,M3.5.0/3,M10.5.0/4</P246> <!-- Self Defined Time zone. Max length allowed is 64 characters -->
        <P102>2</P102> <!-- Date Display Format -->
        <P122>1</P122> <!-- Time Display Format. 0 - 12 Hour, 1 - 24 Hour -->

        <!-- ### Maintenance/ Web Access ### -->
        <P196>Password</P196> <!-- New User Password -->
        <P2>Password</P2> <!-- New Admin password for web interface -->
    </config>
</gs_provision>

# create_folder
/ip service
set ftp disabled=no address=127.0.0.1/32

--
:local mkdir do={
:put $folder
/file print file=temp
/tool fetch address=127.0.0.1 mode=ftp user=USER password="PASSWORD" src-path=temp.txt dst-path=($folder."/temp.txt")
:delay 1
/file remove temp.txt
/file remove ($folder."/temp.txt")
}

# folderName:
$mkdir folder="tftp"

:delay 1

/ip service
set ftp disabled=yes address=""

--
/interface bridge
add comment="Private Subnet:" name=bridge

/interface bridge port
add bridge=bridge interface=ether2

/ip address
add address=10.7.0.254/24 comment="Private Subnet:" interface=bridge network=10.7.0.0

/ip pool
add comment="Private Subnet:" name=pool1 ranges=10.7.0.1-10.7.0.253

/ip dhcp-server
add address-pool=pool1 disabled=no interface=bridge name=dhcp1

/ip dhcp-server option
add code=66 name=Provisioning_66 value="s'10.7.0.254'"
add code=43 name=Provisioning_43 value="s'10.7.0.254'"

/ip dhcp-server option sets
add name=SIP options=Provisioning_43,Provisioning_66

/ip dhcp-server network
add address=10.7.0.0/24 comment="Private Subnet:" dhcp-option-set=SIP dns-server=1.1.1.1,9.9.9.9 gateway=10.7.0.254

/ip tftp
add ip-addresses=10.7.0.0/24 real-filename=tftp/ req-filename=.*

openssl enc –e –aes-256-cbc –k password –in config.xml –out cfg000b82f81d21.

---
https://serveradmin.ru/zablokirovat-dostup-k-kontejneram-docker-iz-interneta/
http://vasilisc.com/21-examples-iptables

sudo iptables -I DOCKER-USER 1 -i eth0 -p tcp --dport 8000 -s 77.120.163.57/32 -j ACCEPT
sudo iptables -I DOCKER-USER 2 -i eth0 -p tcp --dport 9000 -s 77.120.163.57/32 -j ACCEPT
sudo iptables -I DOCKER-USER 3 -i eth0 -p tcp --dport 8000 -j DROP
sudo iptables -I DOCKER-USER 4 -i eth0 -p tcp --dport 9000 -j DROP

---
=-=-=-=-=-=
docker:
=-=-=-=-=-=
https://evilinside.ru/docker-cleanup-ochistka-docker/

sudo docker system // посмотреть доступные команды
sudo docker system df // получить статистику о docker-окружении
sudo docker system prune // очиститься

sudo docker system df
sudo docker system prune -a
sudo docker image prune
sudo docker container prune

---
=-=-=-=-=-=
portainer:
=-=-=-=-=-=
https://documentation.portainer.io/v2.0/deploy/linux/

sudo docker stop portainer

sudo docker system prune -a && \
sudo docker image prune && \
sudo docker container prune

sudo docker pull portainer/portainer-ce

sudo docker run -d -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce

sudo docker ps

---
=-=-=-=-=-=
SSH:
=-=-=-=-=-=
sudo adduser owner
id owner
ls -lad /home/owner/
passwd owner

sudo ssh-keygen -b 4096
cat public-key.pub | ssh owner@192.168.0.100 "mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys && chmod -R go= ~/.ssh && cat >> ~/.ssh/authorized_keys"

sudo nano /etc/ssh/sshd_config
PasswordAuthentication no
PermitRootLogin no
Protocol 2

sudo systemctl restart ssh

sudo usermod -aG sudo owner
sudo whoami
echo "%sudo ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/owner

---
touch `date +%Y%m%d-%H%M%S`

---
https://zalinux.ru/?p=4244
https://hackware.ru/?p=8215
https://losst.ru/shifrovanie-fajlov-i-papok-v-linux
https://vds-admin.ru/unix-toolbox/files-crypting

#Зашифровать данные:
openssl enc -aes-256-cbc -pbkdf2 -in art.txt -out art.txt.enc -iter 1986000

#Расшифровать данные:
openssl enc -aes-256-cbc -pbkdf2 -d -in art.txt.enc -out art-new.txt -iter 1986000

cryptsetup luks
https://www.dkws.org.ua/article.php?id=77
