#!/bin/bash -e

source "$(git rev-parse --show-toplevel)"/backend/zfs.rent.private/radious.env

while sleep 0.1; do
    node process_login_req.js
done
