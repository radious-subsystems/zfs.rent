#!/bin/bash

rm -rf dist
mkdir -p dist

for page in pages/*.html; do
    basename="$(basename "$page")"
    echo "$basename"
    > "dist/$basename" cat\
        include_html/header.html\
        "$page"\
        include_html/footer.html
done

cp -v base.css dist/
echo gh.zfs.rent > dist/CNAME
