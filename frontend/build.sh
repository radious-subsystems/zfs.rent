#!/bin/bash

rm -rf dist
cp -rv pages dist

for page in pages/*.html; do
    echo "$page"
    basename="$(basename "$page")"
    cat header.html "$page" footer.html > dist/"$basename"
done

echo gh.zfs.rent > dist/CNAME
