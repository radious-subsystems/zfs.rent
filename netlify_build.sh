#!/bin/bash

cd "$(git rev-parse --show-toplevel)"

frontend() {
    pushd frontend
        rm -rf dist
        cp -rv src dist

        for src in src/*.html; do
            echo "$src"
            basename="$(basename "$src")"
            cat header.html "$src" footer.html > dist/"$basename"
        done
    popd
}

backend() {
    # install npm deps for netlify functions
    pushd backend/netlify_functions
        npm ci
    popd
}

cli() {
    # build zz binary command and host it 
    ./zz/build.sh
    cp -v ./zz/dist/zz.bin ./frontend/dist/zz
    time gzip --keep -v ./frontend/dist/zz
}

(frontend) &
(backend) &
(cli) &
wait
