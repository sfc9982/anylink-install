#!/bin/bash
cd $(dirname $0)
iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -o eth0 -j MASQUERADE
sysctl -w net.ipv4.ip_forward=1
echo net.ipv4.ip_forward = 1 >> "/etc/sysctl.conf"
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0
yum install -y -q epel-release
yum -y install epel-release
yum -y install golang
yum -y install nodejs
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
rpm --import https://dl.yarnpkg.com/rpm/pubkey.gpg
yum -y install git
yum -y install yarn
yum clean all
yum makecache fast
git clone https://github.com/bjdgyc/anylink.git
cd /root/anylink
sh /root/anylink/build.sh
/bin/cp /root/anylink/anylink-deploy/conf/server-sample.toml ./anylink-deploy/conf/server.toml
/bin/cp -r /root/anylink/anylink-deploy/ /usr/local/anylink-deploy/
/bin/cp /root/anylink/systemd/anylink.service /usr/lib/systemd/system/
systemctl enable anylink
systemctl start anylink
