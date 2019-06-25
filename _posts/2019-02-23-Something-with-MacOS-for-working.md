---
layout: post
title: "[MacOS] Note something for next installation"
date: 2019-02-23 03:32:44
image: '/assets/img/'
description: '[MacOS] Note something for next installation'
tags:
- Macos
- Docker
categories:
- Macos series
twitter_text: '[MacOS] Note something for next installation'
---

# Install HomeBrew:
```bash
$ xcode-select --install
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

# Install some softwares
### Terminator
```bash
$ brew install terminator
```

### Docker
```bash
$ brew install docker
$ brew install docker-machine
$ brew services start docker-machine
# Create "docker" group and put me in it
$ sudo dseditgroup -o create docker
$ sudo dseditgroup -o edit -a price -t user docker

# Run this to set environment before running docker
$ eval $(docker-machine env default)
```

### GIT
```bash
$ 
```

### PIP
```bash
$ 
```

### Python 2 & Python 3
```bash
$ 
```

### Go
```bash
$ 
```

### Vscode
```bash
$ 
```

### Virtualenv
```bash
$ pip install virtualenv
```
### Pycharm
https://www.jetbrains.com/pycharm/download/#section=mac
```bash
$./pycharm.sh
```

### Goland
https://www.jetbrains.com/go/download/
```bash
$./goland.sh
```
