#!/bin/bash

rm -rf dist
cp -rv src dist

for src in src/*.html; do
    echo "$src"
    basename="$(basename "$src")"
    cat header.html "$src" footer.html > dist/"$basename"
done

echo zfs.rent > dist/CNAME
