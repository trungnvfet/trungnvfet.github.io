---
layout: post
title: "How to delete Archive Logs of Oracle"
date: 2024-03-15 03:32:44
image: '/assets/img/'
description: ''
tags:
- DevOps
- Oracle
- Data Engineer
categories:
- DevOps series
twitter_text: 'How to delete Archive Logs of Oracle'
---

## 1. Implementation

### Prerequisite

This note is using for Oracle 11g and Oracle 19c. And `LOG_MODE` is `ARCHIVELOG`

```bash
SQL> select log_mode from v$database;
    LOG_MODE
    ------------
    ARCHIVELOG
    SQL> archive log list;
    Database log mode              Archive Mode
    Automatic archival             Enabled
    Archive destination            USE_DB_RECOVERY_FILE_DEST
    Oldest online log sequence     11
    Next log sequence to archive   13
    Current log sequence           13
```

### Steps

Should login to Oracle linux and/ or Redhat OS to perform following commands:

```bash
$ su - oracle
$ rman
$ connect target
$ delete backup; or only the obsolete backup files with:
$ delete obsolete;

$ delete force copy of archivelog all;
```

</B>Cheer !</B>

## 2. References
* stackoverflow
