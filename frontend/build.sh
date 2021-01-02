#!/bin/bash

cd "$(dirname "$BASH_SOURCE")"

rm -rf dist
cp -rv src dist

for src in src/*.html; do
    echo "$src"
    basename="$(basename "$src")"
    cat header.html "$src" footer.html > dist/"$basename"
done

echo zfs.rent > dist/CNAME

# install npm deps for netlify functions
pushd ../backend/netlify_functions
npm install
popd

# build zz binary command and host it 
../zz/build.sh
cp -v ../zz/dist/zz.bin ./dist/zz
xz --keep -v -T0 ./dist/zz
