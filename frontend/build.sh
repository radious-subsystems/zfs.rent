#!/bin/bash

for src in src_html/*.html; do
    basename="$(basename "$src")"
    echo "$basename"
    > "build/$basename" cat\
        include_html/header.html\
        "$src"\
        include_html/footer.html
done
