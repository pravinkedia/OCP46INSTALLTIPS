# OCP46INSTALLTIPS
OCP4.6 install on UPI Bare metal servers for cp4d

## High Level Steps
https://docs.openshift.com/container-platform/4.6/installing/installing_bare_metal/installing-bare-metal.html

### Script to auto generate the Bootstrap files and change the YAML files

Refer to the script create_manifest_auto.sh

### PXE File configurations for RHCOS install

[root@mangalbp01 pxelinux.cfg]# cat 0A004093

DEFAULT pxeboot

TIMEOUT 200

PROMPT 0

LABEL pxeboot

    KERNEL images/rhcos-live-kernel-x86_64

    APPEND ip=10.0.63.147::10.0.63.1:255.255.255.0:mangalworp01:os_prod.772:none nameserver=10.176.126.200 domain=icpdanalytics.icloudanalytics.sbi bond=os_prod:ens3f0np0,ens6f0np0:mode=802.3ad vlan=os_prod.772:os_prod ip=10.0.64.147:::255.255.255.0::bond-os_mgmt:none bond=bond-os_mgmt:eno1,eno2:mode=active-backup rd.neednet=1 initrd=images/rhcos-4.6.8-x86_64-live-initramfs.x86_64.img,images/rhcos-4.6.8-x86_64-live-rootfs.x86_64.img coreos.inst=yes coreos.inst.install_dev=sdb coreos.inst.ignition_url=http://10.0.64.74:8080/RHCOS/bootstrap.ign

IPAPPEND 2

### Manual Command to stop the network fluctuations for the VLAN configuration

nmcli con up os_prod.772 

nmcli con mod os_prod ipv4.method disable ipv6.method ignore

### Steps to install support toolbox inside the Openshift container

podman run -it --name toolbox-root --privileged --ipc=host --net=host --pid=host -e HOST=/host -e NAME=toolbox-root -e IMAGE=<mirror_registry_hostname>:5000/support-tools:latest -v /run:/run -v /var/log:/var/log -v /etc/machine-id:/etc/machine-id -v /etc/localtime:/etc/localtime -v /:/host <mirror_registry_hostname>:5000/support-tools:latest

### Ports required for LB, Master/Worker node communications

Source IP: Master/Worker nodes

Destination IP: LB nodes (Haproxy based load Balancer)

Ports (TCP) in Bi-directional manner	22
80
443
8080
5000
5001
5002
5003
5004
5005
	
6443
22623
	
2379
2380

