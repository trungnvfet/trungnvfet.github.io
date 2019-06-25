---
layout: post
title: "[MacOS] Note something for next installation"
date: 2019-03-13 03:32:44
image: '/assets/img/'
description: '[MacOS] Note something for next installation'
tags:
- Macos
- Docker
categories:
- Macos series
twitter_text: '[MacOS] Note something for next installation'
---

# Install and enable docker in MACOS

## Install Docker
```bash
$ brew install docker docker-compose docker-machine xhyve docker-machine-driver-xhyve
$ brew install docker-compose
```

## Enable Docker
- Docker in MACOS has been requiring virtualbox manager(vbox) is running

Install virtualbox from following link: https://download.virtualbox.org/virtualbox/6.0.4/VirtualBox-6.0.4-128413-OSX.dmg
```bash
$ docker-machine create --driver virtualbox dev
$ docker-machine env dev
$ eval $(docker-machine env dev)
$ docker ps
```

## Process with stopped machine
```bash
$ docker-machine ls
NAME   ACTIVE   DRIVER       STATE     URL   SWARM   DOCKER    ERRORS
dev    -        virtualbox   Stopped                 Unknown   

$ docker-machine start dev
Starting "dev"...
(dev) Check network to re-create if needed...
(dev) Waiting for an IP...
Machine "dev" was started.
Waiting for SSH to be available...
Detecting the provisioner...
Started machines may have new IP addresses. You may need to re-run the `docker-machine env` command.

$ docker-machine env dev
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.100:2376"
export DOCKER_CERT_PATH="/Users/trungnv/.docker/machine/machines/dev"
export DOCKER_MACHINE_NAME="dev"
# Run this command to configure your shell: 
# eval $(docker-machine env dev)

$ eval $(docker-machine env dev)
```

### Using docker on other tab in terminal:
```bash
$ eval $(docker-machine env dev)
```

Enjoy Docker!!!
