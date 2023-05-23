---
layout: post
title: "How to fix log_archive_format must contain %s, %t and %r for Oracle Database"
date: 2023-05-23 03:32:44
image: '/assets/img/'
description: 'How to fix log_archive_format must contain %s, %t and %r for Oracle Database'
tags:
- System
- Oracle
- DevOps
categories:
- DevOps
twitter_text: 'How to fix log_archive_format must contain %s, %t and %r for Oracle Database'
---

ISSUE:
------
```bash
ORA-32004: obsolete and/or deprecated parameter(s) specified
ORA-19905: log_archive_format must contain %s, %t and %r

```

REASON:
-------
```bash
Lack %r in SQL cli

SQL> alter system set log_archive_format='arch_%t_%s.arc' scope=spfile;
```

SOLUTION:
---------
1. Truy cập Oracle và copy bản `init.ora` file
```bash
[root@oracledb19 ~]# su - oracle
[oracle@oracledb19]$ export $ORACLE_HOME=/data/app/oracle
[oracle@oracledb19]$ cd $ORACLE_HOME/admin/orcl19c/pfile/
[oracle@oracledb19]$ cp init.ora init.ora_bak
```

2. Start Oracle và `nomount` pfile trong `$ORACLE_HOME/admin/orcl19c/pfile/` folder
```bash
[oracle@oracledb19 pfile]$ sqlplus / as sysdba
SQL> shutdown immediate
SQL> startup nomount pfile='init.ora'
```

3. Tạo spfile từ pfile trong `$ORACLE_HOME/admin/orcl19c/pfile/` folder
```bash
SQL> create spfile='spfile.ora' from pfile='init.ora'
```

4. Tắt Oracle và start trở lại
```bash
SQL> shutdown immediate
SQL> startup mount
```

5. Thực hiện Alter `Archive log` mode
```bash
SQL> alter system set log_archive_start=TRUE scope=spfile;
SQL> alter system set log_archive_format="%s_%t_%r.ARC" scope=spfile;
SQL> alter system set log_archive_dest_1='location=/data/app/oracle/product/19.0.0/archivelog/oracle19c/' scope=spfile;
```

6. Kiểm tra `Archive log` mode
```bash
SQL> archive log list
    Database log mode              Archive Mode
    Automatic archival             Enabled
    Archive destination            /data/app/oracle/product/19.0.0/archivelog/oracle19c/
    Oldest online log sequence     269
    Next log sequence to archive   271
    Current log sequence           271

SQL>  show parameter log_archive_format
    NAME                                 TYPE        VALUE
    ------------------------------------ ----------- ------------------------------
    log_archive_format                   string      %s_%t_%r.ARC
```

Thank you for your reading. Done!
