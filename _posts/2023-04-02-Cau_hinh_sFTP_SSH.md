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
    [root@centos7 ]# useradd -g sftpusers -s /sbin/nologin -m -d /opt/omi omi
    [root@centos7 ]# passwd omi

    Gán user vào group:
    [root@centos7 ]# usermod -a -G sftpusers omi
```

3. Cập nhật Subsystem trong `/etc/ssh/sshd_config`:
```bash
    Subsystem sftp internal-sftp
```

4. Cập nhật cuối dòng của `/etc/ssh/sshd_config` hoặc tạo 1 file mới `/etc/ssh/sshd_config.d/omi.conf`
```bash
    Match Group sftpusers
    # Match User omi
    ForceCommand internal-sftp
    PasswordAuthentication yes
    PermitTunnel no
    AllowAgentForwarding no
    AllowTcpForwarding no
    X11Forwarding no
    ChrootDirectory /opt/omi
```

Lưu ý:
- Có thể dùng `Match User omi` để cụ thể cho phép từng users trong sftpusers
- Sử dụng `ChrootDirectory` để giới hạn quyền truy cập duy nhất đến folder đó

5. Cập quyền cho tài khoản và folders của sFTP:
```bash
$ chown root:sftpusers /opt/omi
$ chmod 755 /opt/omi
$ chown -R omi.omi /opt/omi/*
```

6. Test kết nối `ssh` và `sftp`
```bash  
    [root@centos7]# ssh omi@<remote_ip>
    omi@<remote_ip>'s password:
    This service allows sftp connections only.
    Connection to 10.0.0.10 closed.
    
    &
    
    [root@centos7]# sftp omi@<remote_ip>
    omi@<remote_ip>'s password:
    Connected to <remote_ip>.
    sftp> 
```

Thank you for your reading. Done!
