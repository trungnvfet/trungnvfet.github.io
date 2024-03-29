---
layout: post
title: "How to create container logrotate manualy"
date: 2022-08-21 03:32:44
image: '/assets/img/'
description: 'Thay đổi đường dẫn logrotate cho docker'
tags:
- Docker
- DevOps
categories:
- DevOps
twitter_text: 'Thay đổi đường dẫn logrotate cho docker'
---

1. Tạo ổ lưu trữ file dài hạn:
```bash
[root@centos7 ]# mkdir -p /data/rotate_logs
```

2. Kiểm tra các containers đang có:
```bash
    [root@centos7 ]# ll /var/lib/docker/containers/
    total 0
    drwx--x--- 4 root root 237 Aug 21 10:51 a38e7ebfd43a4fad3f045eb188589ae7a1e8bc3d1f1b6a135c4d0c00493fc7f4
    drwx--x--- 4 root root 237 Aug 21 10:40 bde505bd2246251a40890c984fcfac75b25d23f67f15b5c3035461f38b272547
    drwx--x--- 4 root root 237 Aug 21 10:51 d27fb874c3ef0352535ba0b3b95b79b03826f988bbddab386c4610bce2e4b6ba
```

3. Tạo file logrotate theo từng container `/etc/logrotate.d/docker`:
```bash
    olddir /data/rotate_logs
    /var/lib/docker/containers/*/*-json.log {
     rotate 180
     missingok
     compress
     daily
     dateext
     dateformat -%Y%m%d
     copytruncate
    }
```

4. Set hiệu lực cho logrotate cho file vừa tạo
```bash
[root@centos7 ]# logrotate /etc/logrotate.d/docker
```

5. Test debug file logrote
```bash
[root@centos7 ]# logrotate -d /etc/logrotate.d/docker
```
