---
layout: post
title: "Part-1: How to deploy n8n solution on-prem"
date: 2025-04-22 03:32:44
image: '/assets/img/'
description: ''
tags:
- DataOps
- Automation
categories:
- DataOps series
twitter_text: 'Part-1: How to deploy n8n solution on-prem'
---

## Implementation

### Prerequisite

This is a production `docker-compose.yml` should implement in your on-prem location.

```bash
version: '3.7'

services:
  n8n:
    image: n8nio/n8n:latest
    container_name: n8n
    environment:
      - GENERIC_TIMEZONE=Asia/Ho_Chi_Minh
      - N8N_HOST=<your-domain> # your domain with https
      - WEBHOOK_TUNNEL_URL=<your-domain> # your domain with https
      - WEBHOOK_URL=<your-domain> # your domain with https
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_DATABASE=<your_db_name>
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_USER=<your_db_username>
      - DB_POSTGRESDB_PASSWORD=<your_db_password>
      - DB_POSTGRESDB_SCHEMA=public # by default is public in postgresql
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=admin
      - N8N_BASIC_AUTH_PASSWORD=<your_password> # your password
      - N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
      - N8N_SECURE_COOKIE=true # by default is false to accept insecure access via http
    ports:
      - "5678:5678"
    depends_on:
      - postgres
    networks:
      - n8n
    restart: always

  postgres:
    image: postgres:13-alpine
    container_name: postgres_v2
    environment:
      - POSTGRES_USER=<your_db_username> # your db username
      - POSTGRES_PASSWORD=<your_db_password> # your db password
      - POSTGRES_DB=<your_db_name> # your db name
    volumes:
      - n8n_postgres_data:/var/lib/postgresql/data
    networks:
      - n8n
    restart: always

networks:
  n8n:
    driver: bridge

volumes:
 n8n_postgres_data:
   driver: local
```

To perform a backup mechanism, you only need to build a workflow on the top of n8n services (self-host). This workflow keep a mechanism to backup a `postgresql database`.

### Limitation

Please notes that, the version is a community bundle and they don't have SSO, LDAP and share functionality to keep your eyes with your friends.

This version a suitable solution to keep te update egde technologies in the devops, dataops, some automated tasks in your company, ...

### More information

You able to click the following of `GITHUB` where indicates templates (csv files) and backup mechanism <https://github.com/trungnvfet/sre_n8n>


</B>KeepTheSimpleWays !</B>

## References
* stackoverflow
* openapi
