#!/bin/bash
set -euo pipefail

: "${S3_BUCKET_NAME:?S3_BUCKET_NAME is required}"
: "${CLOUDFRONT_DISTRIBUTION_ID:?CLOUDFRONT_DISTRIBUTION_ID is required}"

echo "Building frontend..."
cd frontend
npm ci
npm run build
cd -

echo "Syncing build to S3 bucket: $S3_BUCKET_NAME"
aws s3 sync frontend/dist "s3://$S3_BUCKET_NAME" --delete

echo "Invalidating CloudFront cache: $CLOUDFRONT_DISTRIBUTION_ID"
aws cloudfront create-invalidation --distribution-id "$CLOUDFRONT_DISTRIBUTION_ID" --paths "/*" >/dev/null

echo "Frontend deployed successfully ✅"
