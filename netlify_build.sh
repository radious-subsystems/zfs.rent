#!/bin/bash

cd "$(git rev-parse --show-toplevel)"

# frontend: generate frontend HTML
(cd frontend; ./build.sh)

# backend: install npm deps for netlify functions
(cd backend/netlify_functions; npm ci)

# cli tool: build zz binary command and host it 
./zz/build.sh
./zz/b2_upload.sh
