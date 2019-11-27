---
layout: post
title: "Use Pycharm on Remote Ubuntu Server"
date: 2019-08-15 03:32:44
image: '/assets/img/'
description: 'Use Pycharm on Remote Ubuntu Server'
tags:
- Debug
- Python
categories:
- 
twitter_text: 'How to install and use Pycharm on Remote Ubuntu Server'
---

How to use pycharm IDE on Remote Ubuntu Server from windows OS
==============================================================

Preparation:
===========
1. Windows OS 10 or up to you --- LOL
2. Mobaxterm <https://mobaxterm.mobatek.net/download-home-edition.html>
3. Ubuntu Server (16/18)
4. Pycharm (Community/ Pro) <https://www.jetbrains.com/pycharm/download/>

Installation:
============

We need to install a JDK Runtime Environment on the Ubuntu Server

Note: Java v9 have an issue during open the Pycharm software from the Ubuntu Server

```bash
# apt install openjdk-8-jre-headless
# java -version
openjdk version "1.8.0_222"
OpenJDK Runtime Environment (build 1.8.0_222-8u222-b10-1ubuntu1~16.04.1-b10)
OpenJDK 64-Bit Server VM (build 25.222-b10, mixed mode)
```
A X11-VNX also required on the Ubuntu Server which support open X-Server on Mobaxterm software.

```bash
# apt install x11vnc
```

Xauth have reuired during validate x11 conection via x11vnc, we need to check and add them into Ubuntu Server

```bash
# Rename the existing .Xauthority file by running the following command
mv .Xauthority old.Xauthority 

# xauth with complain unless ~/.Xauthority exists
touch ~/.Xauthority

# only this one key is needed for X11 over SSH 
xauth generate :0 . trusted 

# generate our own key, xauth requires 128 bit hex encoding
xauth add ${HOST}:0 . $(xxd -l 16 -p /dev/urandom)

# To view a listing of the .Xauthority file, enter the following 
xauth list 
```

Lastest, a pycharm (community/ professional) should have in the Ubuntu server.

```bash
# cd ~/<pycharm_folder>/bin
# ./pycharm.sh
```

Issue: `Unable to detect graphics environment`
----------------------------------------------
Logs:
-----
  ```bash
  OpenJDK 64-Bit Server VM warning: Option UseConcMarkSweepGC was deprecated in version 9.0 and will likely be removed in a future  release.

  Startup Error: Unable to detect graphics environment
  ```
  AND
  ```bash
  trungnv@pv-controller-3:~$ ssh root@45.64.126.90 -X
  root@45.64.126.90's password:
  X11 forwarding request failed on channel 0
  Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.4.0-166-generic x86_64)
  ```
==> 
Solution:

  ```bash
  $ sudo vim /etc/ssh/sshd_config
    Set `X11UseLocalhost no`
  $ sudo service sshd restart
  $ exit
  $ ssh -X user@remotehost
  $ xclock
  $ ./pycharm.sh
  ```

Conclution:
===========
- This solution will help developers don't have much $ to build strong PC/ laptop. LOL

Enjoy!
Author: TrungNV
