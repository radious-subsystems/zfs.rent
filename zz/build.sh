#!/bin/bash

cd "$(dirname "$BASH_SOURCE")"

# build variables
mkdir -p lib/assets
git rev-parse --short HEAD | tee lib/assets/GIT_COMMIT_REF
date +%s                   | tee lib/assets/BUILD_DATE

# install fresh deps and upsert the version
npm ci
npm version --allow-same-version $(cat VERSION)

# generate binary
npx pkg .\
    --target node14-linux\
    --output dist/zz.bin\
    --options unhandled-rejections=strict

# compress binary too
gzip -f --keep -v dist/zz.bin
xz   -f --keep -v dist/zz.bin
