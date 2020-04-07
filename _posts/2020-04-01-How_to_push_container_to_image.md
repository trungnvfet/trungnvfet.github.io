---
layout: post
title: "Build image from docker running container"
date: 2020-04-01 03:32:44
image: '/assets/img/'
description: 'Build image from docker running container'
tags:
- Docker
- Linux
categories:
twitter_text: 'How to build image from docker running container'
---

## Dockers CLI

1. Login docker hub on your host
```bash
docker login --username=yourhubusername --password=yourpassword
```

2. Commit your running container
```bash
docker container commit [CONATINER_ID] trungnvfet/openstack:vtel_heat
```

3. Tag created image after commit
```bash
docker tag [IMAGE_ID] trungnvfet/openstack:vtel_heat
```

4. Complete with docker push to docker hub
```bash
docker push trungnvfet/openstack:vtel_heat
```

Done!!!
