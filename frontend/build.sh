#!/bin/bash

rm -rf dist
mkdir -p dist

for page in pages/*.html; do
    echo "$page"
    basename="$(basename "$page")"
    cat header.html "$page" footer.html > dist/"$basename"
done

cp -v base.css dist/
echo gh.zfs.rent > dist/CNAME
