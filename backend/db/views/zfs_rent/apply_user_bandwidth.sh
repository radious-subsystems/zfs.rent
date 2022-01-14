#!/bin/bash

cd "$(dirname "$BASH_SOUCE")"

source ~/zfs.rent.private/prod.env

psql <<EOM
BEGIN;
$(cat _user_bandwidth.sql)
$(cat ~/zfs.rent.private/monthly_bw.sql)
ROLLBACK;
EOM
