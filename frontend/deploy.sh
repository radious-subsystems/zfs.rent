#!/bin/bash
set -e

cd dist
git init
git add .
git commit -m "deploy: $(date)"
git push --force origin frontend-live
rm -rf .git
