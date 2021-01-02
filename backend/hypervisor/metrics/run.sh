#!/bin/bash --login

cd "$(dirname "$BASH_SOURCE")"
source ~/zfs.rent.private/prod.env
ruby metrics.rb
