#!/bin/bash --login

cd "$(dirname "$BASH_SOURCE")"

# Add this to cron:
# * * * * * /home/ryan/zfs.rent/backend/hypervisor/metrics/run.sh

source ~/zfs.rent.private/prod.env
export PGPORT=5433
ruby metrics.rb
