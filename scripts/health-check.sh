#!/bin/bash
set -euo pipefail

URL="${1:-}"
if [[ -z "$URL" ]]; then
  echo "Usage: ./scripts/health-check.sh <url>"
  exit 1
fi

echo "Checking: $URL"
code=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
echo "HTTP Status: $code"

if [[ "$code" != "200" ]]; then
  echo "Health check failed"
  exit 1
fi

echo "Health check passed ✅"
