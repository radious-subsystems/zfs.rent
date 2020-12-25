#!/bin/bash

source "$(git rev-parse --show-toplevel)"/backend/zfs.rent.private/radious.env

while sleep 1; do
    timeout 5 node process_login_req.js
    date
done
