#!/bin/bash -ex

source "$(git rev-parse --show-toplevel)"/zfs.rent.private/prod.env
npx nodemon app.mjs
