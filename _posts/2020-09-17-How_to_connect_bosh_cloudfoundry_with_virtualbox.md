---
layout: post
title: "How to connect BOSH CloudFoundry with VirtualBox"
date: 2020-04-01 03:32:44
image: '/assets/img/'
description: 'How to connect BOSH CloudFoundry with VirtualBox'
tags:
- cloudfoundry
- Linux
- bosh
categories:
twitter_text: 'How to connect BOSH CloudFoundry with VirtualBox'
---

Connect BOSH director with VirtualBox in Mint20
===============================================

1. Install VirtualBox
---------------------
```bash
$ wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
$ echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian bionic contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
$ sudo apt-get update -y
$ sudo apt-get install virtualbox-5.2 -y
$ VBoxManage --version
```

NOTE:
- Fix `libvpx5 version` error
```bash
<https://github.com/cloudfoundry/bosh-deployment/issues/378>
$ wget http://archive.ubuntu.com/ubuntu/pool/main/libv/libvpx/libvpx5_1.7.0-3_amd64.deb
$ sudo dpkg -i libvpx5_1.7.0-3_amd64.deb
```
- Bosh isn't support VirtualBox >=6.0

2. Install Ruby client
----------------------
```bash
$ sudo apt-get install ruby-full build-essential
$ ruby --version
```

3. Install BOSH of VirtualBox
-----------------------------
3.1 Install
-----------
```bash
$ mkdir -p  ~/Development/bosh-virtualbox
$ cd  ~/Development/bosh-virtualbox
$ cd bosh-deployment/

$ wget -O bosh https://github.com/cloudfoundry/bosh-cli/releases/download/v6.4.0/bosh-cli-6.4.0-linux-amd64
$ chmod  +x bosh
$ mv bosh /bin/
$ bosh --version
```
3.2 Create BOSH Director
------------------------
```bash
$ bosh delete-env bosh-deployment/bosh.yml \
  --state ./state.json \
  -o bosh-deployment/virtualbox/cpi.yml \
  -o bosh-deployment/virtualbox/outbound-network.yml \
  -o bosh-deployment/bosh-lite.yml \
  -o bosh-deployment/bosh-lite-runc.yml \
  -o bosh-deployment/jumpbox-user.yml \
  -o bosh-deployment/uaa.yml \
  -o bosh-deployment/credhub.yml \
  --vars-store ./creds.yml \
  -v director_name=VirtualBox-Director \
  -v internal_ip=192.168.50.6 \
  -v internal_gw=192.168.50.1 \
  -v internal_cidr=192.168.50.0/24 \
  -v outbound_network_name=NatNetwork
```

output:
- ifconfig
```bash
vboxnet2: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.50.1  netmask 255.255.255.0  broadcast 192.168.50.255
        inet6 fe80::800:27ff:fe00:2  prefixlen 64  scopeid 0x20<link>
        ether 0a:00:27:00:00:02  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 177  bytes 26603 (26.6 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```
- bosh director
```bash
root@trungnvfet:~/Development/bosh-virtualbox# bosh envs
URL           Alias  
192.168.50.6  virtualbox  

1 environments

Succeeded
```

3.3 Generate admin password from creds.yml file
-----------------------------------------------
```bash
bosh int ./creds.yml --path /admin_password
```
output:
```bash
root@trungnvfet:~/Development/bosh-virtualbox# bosh int ./creds.yml --path /admin_password
3cp4c0c7a25k2qxtnf80
```

3.4 Create bosh environment alias
---------------------------------
```bash
$ bosh -e 192.168.50.6 alias-env virtualbox --ca-cert <(bosh int ./creds.yml --path /director_ssl/ca)
```
3.5 Login to bosh environment
```bash
$ bosh -e virtualbox login
```
output:
```bash
root@trungnvfet:~/Development/bosh-virtualbox# bosh -e virtualbox login
Using environment '192.168.50.6'

Email (): admin
Password (): 

Successfully authenticated with UAA

<admin/3cp4c0c7a25k2qxtnf80>
```

3.6 Upload cloud-config
-----------------------
- cloud-config.yml
```yml
azs:
- name: z1
- name: z2
- name: z3

vm_types:
- name: default
  cloud_properties:
    cpu: 2
    ram: 1024
    disk: 3240
- name: large
  cloud_properties:
    cpu: 2
    ram: 4096
    disk: 30_240

disk_types:
- name: default
  disk_size: 3000
- name: large
  disk_size: 50_000

networks:
- name: default
  type: manual
  subnets:
  - range: ((internal_cidr))
    gateway: ((internal_gw))
    azs: [z1, z2, z3]
    dns: [8.8.8.8]
    reserved: []
    cloud_properties:
      name: ((network_name))

compilation:
  workers: 2
  reuse_compilation_vms: true
  az: z1
  vm_type: default
  network: default
```

```bash
$ export BOSH_ENVIRONMENT=virtualbox
$ bosh update-cloud-config bosh-deployment/warden/cloud-config.yml
```

3.7 Upload stemcell to director
-------------------------------
```bash
$ wget https://bosh.io/d/stemcells/bosh-warden-boshlite-ubuntu-trusty-go_agent
$ bosh upload-stemcell bosh-warden-boshlite-ubuntu-trusty-go_agent
```

3.8 Deploy nginx application on the stemcell
- Upload release for Nginx
```bash
bosh upload-release --sha1 1731de7995b785f314e87f54f2e29d3668f0b27f \
>   https://bosh.io/d/github.com/cloudfoundry-community/nginx-release?v=1.19.1
```
- Create nginx.yml
```yml
---
name: nginx

releases:
- name: nginx
  version: latest

stemcells:
- alias: ubuntu
  os: ubuntu-trusty
  version: latest

instance_groups:
- name: nginx
  instances: 1
  azs: [ z1 ]
  vm_type: default
  stemcell: ubuntu
  networks:
  - name: default
  jobs:
  - name: nginx
    release: nginx
    properties:
      nginx_conf: |
        worker_processes  1;
        error_log /var/vcap/sys/log/nginx/error.log   info;
        events {
          worker_connections  1024;
        }
        http {
          include /var/vcap/packages/nginx/conf/mime.types;
          default_type  application/octet-stream;
          sendfile        on;
          keepalive_timeout  65;
          server_names_hash_bucket_size 64;
          server {
            server_name demo.caarels.lab;
            listen *:80;
            access_log /var/vcap/sys/log/nginx/automate-it-access.log;
            error_log /var/vcap/sys/log/nginx/automate-it-error.log;
          }
        }

update:
  canaries: 1
  max_in_flight: 1
  serial: false
  canary_watch_time: 1000-60000
  update_watch_time: 1000-60000
```

- Deploy nginx
```bash
$ bosh -d nginx deploy nginx.yml
```

- Add route for Nginx application and access via web
```bash
$ ip route add 10.244.0.0/24 via 192.168.50.6 dev vboxnet2
```

- Delete Nginx deployment
```bash
$ bosh -d nginx delete-deployment
```

- Delete BOSH director connected the VirtualBox
```bash
bosh delete-env bosh-deployment/bosh.yml \
  --state ./state.json \
  -o bosh-deployment/virtualbox/cpi.yml \
  -o bosh-deployment/virtualbox/outbound-network.yml \
  -o bosh-deployment/bosh-lite.yml \
  -o bosh-deployment/bosh-lite-runc.yml \
  -o bosh-deployment/jumpbox-user.yml \
  -o bosh-deployment/uaa.yml \
  -o bosh-deployment/credhub.yml \
  --vars-store ./creds.yml \
  -v director_name=VirtualBox-Director \
  -v internal_ip=192.168.50.6 \
  -v internal_gw=192.168.50.1 \
  -v internal_cidr=192.168.50.0/24 \
  -v outbound_network_name=NatNetwork
```

- Check stemcells
```bash
root@trungnvfet:~/Development/bosh-virtualbox# bosh stemcells
Using environment '192.168.50.6' as user 'admin'

Name                                         Version    OS             CPI  CID  
bosh-warden-boshlite-ubuntu-trusty-go_agent  3586.100*  ubuntu-trusty  -    e294e8d9-f08b-4c27-6ee8-8ad07bc12684  

(*) Currently deployed

1 stemcells

Succeeded
```

- Check deployments
```bash
root@trungnvfet:~/Development/bosh-virtualbox# bosh deployments
Using environment '192.168.50.6' as user 'admin'

Name   Release(s)    Stemcell(s)                                           Team(s)  
nginx  nginx/1.19.1  bosh-warden-boshlite-ubuntu-trusty-go_agent/3586.100  -  

1 deployments

Succeeded
```

- Check nginx app
```bash
root@trungnvfet:~/Development/bosh-virtualbox# bosh vms
Using environment '192.168.50.6' as user 'admin'

Task 5. Done

Deployment 'nginx'

Instance                                    Process State  AZ  IPs         VM CID                                VM Type  Active  Stemcell  
nginx/5253875e-1116-4262-bc5b-241b491cbd79  running        z1  10.244.0.2  a72db803-86ff-49d5-56af-b848e37443d6  default  true    bosh-warden-boshlite-ubuntu-trusty-go_agent/3586.100  

1 vms

Succeeded
```

- Deploy 2 nginx application
Output:
```bash
root@trungnvfet:~/Development/bosh-virtualbox# bosh vms
Using environment '192.168.50.6' as user 'admin'


Task 8. Done

Deployment 'nginx'

Instance                                    Process State  AZ  IPs         VM CID                                VM Type  Active  Stemcell  
nginx/0222239b-4861-4f5d-a333-70591227635c  running        z1  10.244.0.3  ac5314b6-faf3-4020-7e99-904fa3d185b5  default  true    bosh-warden-boshlite-ubuntu-trusty-go_agent/3586.100  
nginx/5253875e-1116-4262-bc5b-241b491cbd79  running        z1  10.244.0.2  a72db803-86ff-49d5-56af-b848e37443d6  default  true    bosh-warden-boshlite-ubuntu-trusty-go_agent/3586.100  

2 vms

Succeeded
```

- Check disks
```bash
root@trungnvfet:~/Development/bosh-virtualbox# bosh disks --orphaned
Using environment '192.168.50.6' as user 'admin'

Disk CID  Size  Deployment  Instance  AZ  Orphaned At  

0 disks

Succeeded
```


Done!!!
