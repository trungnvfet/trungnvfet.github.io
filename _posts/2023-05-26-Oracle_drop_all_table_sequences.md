---
layout: post
title: "HOW TO DROP ALL TABLES AND SEQUENCES IN THE ORACLE"
date: 2023-05-23 03:32:44
image: '/assets/img/'
description: 'HOW TO DROP ALL TABLES AND SEQUENCES IN THE ORACLE'
tags:
- System
- Oracle
- DevOps
categories:
- DevOps
twitter_text: 'HOW TO DROP ALL TABLES AND SEQUENCES IN THE ORACLE'
---

# DROP ALL TABLES AND SEQUENCES IN THE ORACLE

## List all of tables and sequences
This script will garther data and generate a script which use to drop all of tables and sequences, please look at in the following:
```bash
SQL> select 'drop table ' || table_name || ';' from user_tables;
SQL> select 'drop sequence ' || sequence_name || ';' from user_sequences;
```

> **_NOTE:_**: `Be careful` please check your expectation beforce implementation.


Thank you for your reading. Done!
