#!/bin/bash --login

# Add this to cron:
# * * * * * /home/ryan/zfs.rent/backend/hypervisor/metrics/run.sh

source ~/zfs.rent.private/prod.env
ruby metrics.rb
