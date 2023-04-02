---
layout: post
title: "How to configure sftp users in centos7"
date: 2023-04-02 03:32:44
image: '/assets/img/'
description: 'How to configure sftp users in centos7'
tags:
- System
- DevOps
categories:
- DevOps
twitter_text: 'How to configure sftp users in centos7'
---

1. Tạo group mới cho sftp `sftpusers`:
```bash
[root@centos7 ]# groupadd sftpusers
```

2. Tạo/ gán account kèm home_directory và gán vào group `sftpusers`:
```bash
Tạo user mới:
[root@centos7 ]# useradd -g sftpusers -s /sbin/nologin -m -d /opt/omipay omipay
[root@centos7 ]# passwd omipay

Gán user vào group:
[root@centos7 ]# usermod -a -G sftpusers omipay
```

3. Cập nhật Subsystem trong `/etc/ssh/sshd_config`:
```bash
Subsystem sftp internal-sftp
```

4. Cập nhật cuối dòng của `/etc/ssh/sshd_config` hoặc tạo 1 file mới `/etc/ssh/sshd_config.d/omipay.conf`
```bash
    Match Group sftpusers
    # Match User omipay
    ForceCommand internal-sftp
    PasswordAuthentication yes
    PermitTunnel no
    AllowAgentForwarding no
    AllowTcpForwarding no
    X11Forwarding no
```
Lưu ý: Có thể dùng `Match User omipay` để cụ thể cho phép từng users trong sftpusers

5. Test kết nối `ssh` và `sftp`

Kết nối ssh bị từ chối
```bash
[root@centos7]# ssh omipay@<remote_ip>
omipay@<remote_ip>'s password:
This service allows sftp connections only.
Connection to 192.168.0.8 closed.
```
Cho phép kết nối duy nhất thông qua sftp
```bash
[root@centos7]# sftp omipay@<remote_ip>
omipay@<remote_ip>'s password:
Connected to <remote_ip>.
sftp> 
```
