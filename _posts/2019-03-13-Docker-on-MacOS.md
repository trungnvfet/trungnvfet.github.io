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

Enjoy Docker!!!
