#!/usr/bin/bash
set -x

mkdir $1
chmod 777 $1
cp install-config.yaml $1
sleep 5
openshift-install create manifests --dir=$1
sleep 5
cp 99-* $1/openshift
sleep 5
sed -i 's/true/false/g' $1/manifests/cluster-scheduler-02-config.yml
sleep 5
cat $1/manifests/cluster-scheduler-02-config.yml
openshift-install create ignition-configs --dir=$1
sleep 5
cp -f $1/*.ign /var/www/html/RHCOS/
sleep 5
ls -ltr /var/www/html/RHCOS/*
sleep 5
systemctl restart dhcpd tftp httpd haproxy
sleep 5
systemctl status dhcpd tftp httpd haproxy
