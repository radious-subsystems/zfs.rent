#!/bin/bash

./b2 authorize-account "$b2_key_id" "$b2_app_key"
./b2 upload-file "zfs-rent" "dist/zz.bin" "zz"
