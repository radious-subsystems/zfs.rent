#!/bin/bash

PG_URL="REDACTED"

psql "$PG_URL" < sw_syslog.sql
psql "$PG_URL" < user_login.sql
psql "$PG_URL" < reset_passwd.sql
