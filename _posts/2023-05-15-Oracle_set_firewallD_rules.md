---
layout: post
title: "How to set FirewallD & iptables rules for Oracle Database"
date: 2023-05-15 03:32:44
image: '/assets/img/'
description: 'How to set FirewallD & iptables rules for Oracle Database'
tags:
- System
- Oracle
- DevOps
categories:
- DevOps
twitter_text: 'How to set FirewallD & iptables rules for Oracle Database'
---

1. Tạo rules cho `iptables` đối với `Oracle` trên centos7:
```bash
    # service iptables start
    # chkconfig iptables on
    # iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    # iptables -A INPUT -p tcp --dport 1521 -j ACCEPT
    # service iptables save
    # service iptables status
```

2. Tạo rules cho `firewallD` đối với `Oracle` trên centos7:
```bash
    # systemctl start firewalld.service
    # systemctl enable firewalld.service
    # firewall-cmd --permanent --zone=public --add-port=22/tcp
    # firewall-cmd --permanent --zone=public --add-port=1521/tcp
    # firewall-cmd --reload
    # firewall-cmd --permanent --zone=public --list-ports
    1521/tcp 22/tcp
```

3. Các rules cho `firewallD` khác:
```bash
    # firewall-cmd --permanent --zone=public --remove-port=8080-8081/tcp
    # firewall-cmd --permanent --zone=public --add-rich-rule="rule family="ipv4" source address="192.168.0.4/24" service name="http" accept"
    # firewall-cmd --permanent --zone=public --remove-rich-rule="rule family="ipv4" source address="192.168.0.4/24" service name="http" accept"
```

Thank you for your reading. Done!
