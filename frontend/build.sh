#!/bin/bash

rm -rf ./dist
cp -r  ./src ./dist

for src in src/*.html; do
    echo "$src"
    basename="$(basename "$src")"
    cat header.html "$src" footer.html > dist/"$basename"
done

# override 404 page
echo "404: not found" > dist/404.html
