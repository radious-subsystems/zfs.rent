#!/bin/bash

cd "$(dirname "$BASH_SOURCE")"

# build variables
git rev-parse --short HEAD | tee lib/assets/GIT_COMMIT_REF
date +%s                   | tee lib/assets/BUILD_DATE

npm ci
npm version --allow-same-version $(cat VERSION)
npx pkg .\
    --target node14-linux\
    --output dist/zz.bin\
    --options unhandled-rejections=strict
