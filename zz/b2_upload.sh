#!/bin/bash

# download b2 binary if necessary
b2="/tmp/b2.bin"
if [ ! -f "$b2" ]; then
    curl -o "$b2" "https://f000.backblazeb2.com/file/backblazefiles/b2/cli/linux/b2"
    chmod +x "$b2"
fi

# login
"$b2" authorize-account "$b2_key_id" "$b2_app_key"

# upload
"$b2" upload-file "zfs-rent" "dist/zz.bin" "zz"
