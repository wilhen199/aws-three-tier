#!/bin/bash
PROJECT_NAME="aws-3-tier"

echo -e "\n[0/3] Searching bucket $PROJECT_NAME-tfstate"
BUCKET_NAME=$(aws s3api list-buckets \
  --query "Buckets[?starts_with(Name, '$PROJECT_NAME-tfstate')].Name" \
  --output text)

if [ -z "$BUCKET_NAME" ] || [ "$BUCKET_NAME" == "None" ]; then
  echo "Bucket not found"
  exit 1
fi
echo "    Bucket found: $BUCKET_NAME"

echo -e "\n[1/3] Deleting bucket versioning: $BUCKET_NAME"
VERSIONS=$(aws s3api list-object-versions --bucket $BUCKET_NAME \
  --query 'Versions[].{Key:Key,VersionId:VersionId}' --output json)
if [ "$VERSIONS" != "[]" ] && [ "$VERSIONS" != "null" ]; then
  aws s3api delete-objects --bucket $BUCKET_NAME --delete "{\"Objects\":$VERSIONS}"
fi

echo -e "\n[2/3] Deleting delete markers"
MARKERS=$(aws s3api list-object-versions --bucket $BUCKET_NAME \
  --query 'DeleteMarkers[].{Key:Key,VersionId:VersionId}' --output json)
if [ "$MARKERS" != "[]" ] && [ "$MARKERS" != "null" ]; then
  aws s3api delete-objects --bucket $BUCKET_NAME --delete "{\"Objects\":$MARKERS}"
fi

echo -e "\n[3/3] Deleting bucket"
aws s3 rb s3://$BUCKET_NAME

echo -e "\nBucket $BUCKET_NAME deleted successfully"
