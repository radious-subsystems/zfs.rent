#!/bin/bash
set -e

./build.sh
origin="git@github.com:radious-subsystems/zfs.rent"

cd dist
git init
git add .
git commit -m "deploy: $(date)"
git push --force "$origin" master:frontend-live
rm -rf .git
