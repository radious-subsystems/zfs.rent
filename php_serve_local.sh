#!/bin/bash

php -S 0.0.0.0:1101 -n\
    -t /home/ryan/zfs-rent/www\
    -d extension=pgsql\
    -d extension=json
