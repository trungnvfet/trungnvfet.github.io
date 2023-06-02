---
layout: post
title: "HOW TO ENABLE ARCHIVELOG & FLASHBACK FOR ORACLE 11G AND LATER"
date: 2023-05-23 03:32:44
image: '/assets/img/'
description: 'HOW TO ENABLE ARCHIVELOG & FLASHBACK FOR ORACLE 11G AND LATER'
tags:
- System
- Oracle
- DevOps
categories:
- DevOps
twitter_text: 'HOW TO ENABLE ARCHIVELOG & FLASHBACK FOR ORACLE 11G AND LATER'
---

# CẤU HÌNH ARCHIVELOG & FLASHBACK CHO ORACLE 11G AND MỚI HƠN

## CẤU HÌNH ARCHIVELOG CHO ORACLE 11G AND MỚI HƠN

### 1. Kiểm tra cấu hình `ARCHIVELOG`:
```bash
SQL> select log_mode from v$database;
    LOG_MODE
    ------------
    NOARCHIVELOG
    SQL> archive log list;
    Database log mode              No Archive Mode
    Automatic archival             Disabled
    Archive destination            USE_DB_RECOVERY_FILE_DEST
    Oldest online log sequence     11
    Current log sequence           13
```

> **_NOTE:_**: `Automatic archival` là `Disabled` nên chế độ ARCHIVELOG chưa được bật

### 2. Tiến hành bật `ARCHIVELOG`:

#### 2.1 Tắt Oracle Database, port 1521 listner vẫn hoạt động
```bash
SQL> shutdown immediate;
    Database closed.
    Database dismounted.
    ORACLE instance shut down.
```

#### 2.2 Bật Oracle với chế độ Mount pfile
```bash
SQL> startup mount;
    ORACLE instance started.

    Total System Global Area 1553305600 bytes
    Fixed Size                  2253544 bytes
    Variable Size             956304664 bytes
    Database Buffers          587202560 bytes
    Redo Buffers                7544832 bytes
    Database mounted.
```

#### 2.3 Set chế độ ARCHIVELOG cho Oracle
```bash
SQL> alter database archivelog;
    Database altered.

SQL> alter database open;
    Database altered.
```

#### 2.4 Kiểm tra chế độ ARCHIVELOG cho Oracle
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

### 3. Bật chế độ `NOARCHIVELOG `
```bash
SQL> alter database noarchivelog;
    Database altered.

SQL> archive log list;
    Database log mode              No Archive Mode
    Automatic archival             Disabled
    Archive destination            USE_DB_RECOVERY_FILE_DEST
    Oldest online log sequence     11
    Current log sequence           13
```

### 4. Lưu ý <strong>KHÔNG</strong> bật chế độ `NOARCHIVELOG` & `ARCHIVELOG` ở system
```bash
SQL> alter system archivelog;
```

## CẤU HÌNH FLASHBACK CHO ORACLE 11G AND MỚI HƠN

### 1. Kiểm tra chế độ `Flashback`
```bash
SQL> select flashback_on from v$database;
```

### 2. Kích hoạt chế độ `Flashback`
```bash
SQL> alter database flashback on;
```

### 3. Set thời gian cho chế độ `Flashback`
> **_NOTE:_**: Mặc định là 1440 phút = 24 giờ
```bash
SQL> alter system set db_flashback_retention_target= 2880;
```

### 4. Các bước khôi phục dữ liệu khi `delete` dữ liệu
#### 4.1 Kiểm tra SCN hay thời gian hiện tại
```bash
SQL> select to_char(current_scn) from v$database;
    TO_CHAR(CURRENT_SCN)
    --------------------------------------------------------------------------------
    748335117

SQL> select to_char(sysdate, 'dd-MON-YYYY hh24.MI.SS') from dual;
    TO_CHAR(SYSDATE,'DD-MON-YYYYHH24.MI.SS')
    --------------------------------------------------------------------------------
    26-MAY-2023 08.50.00
```

#### 4.2 Kích hoạt `row movement`
```bash
SQL> alter table test.products enable row movement;
```

#### 4.3 Flashback to scn || timestamp
```bash
SQL> flashback table test.products to scn 748335117;

SQL> flashback table test.products to timestamp to_timestamp('26-MAY-2023 08.50.00','dd-MON-YY hh24.MI.SS');
```

#### 4.4 Bỏ kích hoạt `row movement`
```bash
SQL> alter table test.products disable row movement;
```

Thank you for your reading. Done!
