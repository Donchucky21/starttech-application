#!/bin/bash
set -euo pipefail

echo "Starting backend deployment..."

: "${ASG_NAME:?ASG_NAME is required (set it before running: export ASG_NAME=...)}"

aws autoscaling start-instance-refresh \
  --auto-scaling-group-name "$ASG_NAME"

echo "Backend deployment triggered for ASG: $ASG_NAME"
