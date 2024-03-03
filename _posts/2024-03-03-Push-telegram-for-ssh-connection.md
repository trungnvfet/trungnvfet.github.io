---
layout: post
title: "Monitoring SSH access in Linux Servers"
date: 2024-03-03 03:32:44
image: '/assets/img/'
description: ''
tags:
- DevOps
- System
- Data Engineer
categories:
- IPS/IDS series
twitter_text: 'Monitoring SSH access in Linux Servers'
---

## 1. Implementation

### Prerequisite

To configure a SSH monitoring on the linux servers, we need to prepare something in the following items:

```bash
- A `bot_token` token telegram Bot in the `@BotFather`
- A `chat_id` telegram Bot which get via `https://api.telegram.org/bot<YourBOTToken>/getUpdates`
- A `topic_id` telegram Bot (Option)
```

### Step-over-Step

<U><B>Step 1</B></U>. Create a `telegram-send` file in `/usr/bin/telegram-send` along with following contents:

```bash
#!/bin/bash
    
GROUP_ID=`chat_id`
BOT_TOKEN=`bot_token`

if [ "$1" == "-h" ]; then
  echo "Usage: `basename $0` \"text message\""
  exit 0
fi

if [ -z "$1" ]
  then
    echo "Add message text as second arguments"
    exit 0
fi

if [ "$#" -ne 1 ]; then
    echo "You can pass only one argument. For string with spaces put it on quotes"
    exit 0
fi

{
    curl -m 10 -s --data "text=$1" --data "chat_id=$GROUP_ID" 'https://api.telegram.org/bot'$BOT_TOKEN'/sendMessage' > /dev/null
} || {
	echo "Ignore exception at here"
}
```

<U><B>Step 2</B></U>. Create a `login-notify.sh` in the `/etc/profile.d/login-notify.sh` directory along with following contents:

```bash
#!/bin/bash

ip_ssh="$(echo $SSH_CONNECTION | cut -d " " -f 1)"
login_ip="$(hostname -I | cut -d " " -f 2)"
# For CentOS
login_hostname="$(hostnamectl --static)"
# Open below line for Redhat or Ubuntu
# login_hostname="$(hostname)"
login_date="$(date +"%e %b %Y, %a %r")"
login_name="$(whoami)"

if [ "$login_name" != root ]; then
        message="[AlertMGR] Accessing via SSH to $login_hostname $login_ip, following info:"$'\n'"1.User: $login_name"$'\n'"2.IP: $ip_ssh"$'\n'"3.Time: $login_date"
        telegram-send "$message"
fi

if [ "$login_name" == root ]; then
        message="[ROOT_ACCESS] $login_hostname $login_ip, Major Alert on:"$'\n'"1.User: $login_name"$'\n'"2.Time: $login_date"
        telegram-send "$message"
fi
```

<U><B>Step 3</B></U>: Add permission for files:

```bash
$ chmod +x /usr/bin/telegram-send
$ chown root:root /usr/bin/telegram-send
```

</B>Cheer !</B>

## 2. References
* https://bogomolov.tech/Telegram-notification-on-SSH-login/
