#!/bin/bash

rm -rf dist
mkdir -p dist

for src in src_html/*.html; do
    basename="$(basename "$src")"
    echo "$basename"
    > "dist/$basename" cat\
        include_html/header.html\
        "$src"\
        include_html/footer.html
done

cp -v base.css dist/
echo gh.zfs.rent > dist/CNAME
