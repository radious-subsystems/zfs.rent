#!/bin/bash

# download b2 binary and create a cleanup routine
b2="$(mktemp -t b2.bin.XXX)"
trap "rm -v '$b2'" EXIT
curl -o "$b2" "https://f000.backblazeb2.com/file/backblazefiles/b2/cli/linux/b2"
chmod +x "$b2"

"$b2"
