#!/bin/bash -e

source "$(git rev-parse --show-toplevel)"/backend/zfs.rent.private/prod.env
npx nodemon app.js
