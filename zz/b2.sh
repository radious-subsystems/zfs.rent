#!/bin/bash

# download b2 binary if necessary
b2="/tmp/b2.bin"
if [ ! -f "$b2" ]; then
    curl -o "$b2" "https://f000.backblazeb2.com/file/backblazefiles/b2/cli/linux/b2"
    chmod +x "$b2"
fi

# hand over control to b2
exec "$b2" "$@"
