#!/bin/bash -e

source "$(git rev-parse --show-toplevel)"/backend/zfs.rent.private/radious.env
npx nodemon app.js
