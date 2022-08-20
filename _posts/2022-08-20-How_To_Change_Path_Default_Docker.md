---
layout: post
title: "How to change a path docker default"
date: 2022-08-20 03:32:44
image: '/assets/img/'
description: 'Thay đổi đường dẫn thu mục của docker'
tags:
- Docker
- DevOps
categories:
- DevOps
twitter_text: 'Thay đổi đường dẫn thu mục của docker'
---

1. Kiểm tra dung lượng của `/var/lib/docker`
```bash
# du -h /var/lib/docker
```

2. Tạm dừng service của Docker Daemon
```bash
# service docker stop
```

3. Chuyển toàn bộ file của docker default sang thư mục mới
```bash
# mv /var/lib/docker /data/
```

4. Tạo một symlink đến default docker
```bash
# ln -s /data/docker /var/lib/docker
```

5. Start Docker Daemon trở lại
```bash
# service docker start
```

6. Kiểm tra dung lượng của docker default
```bash
# du -h /var/lib/docker
# du -h /data/docker
```
