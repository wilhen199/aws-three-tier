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

echo -e "\n[1/4] Deleting bucket versioning: $BUCKET_NAME"
VERSIONS=$(aws s3api list-object-versions --bucket $BUCKET_NAME \
  --query 'Versions[].{Key:Key,VersionId:VersionId}' --output json)
if [ "$VERSIONS" != "[]" ] && [ "$VERSIONS" != "null" ]; then
  aws s3api delete-objects --bucket $BUCKET_NAME --delete "{\"Objects\":$VERSIONS}"
fi

echo -e "\n[2/4] Deleting delete markers"
MARKERS=$(aws s3api list-object-versions --bucket $BUCKET_NAME \
  --query 'DeleteMarkers[].{Key:Key,VersionId:VersionId}' --output json)
if [ "$MARKERS" != "[]" ] && [ "$MARKERS" != "null" ]; then
  aws s3api delete-objects --bucket $BUCKET_NAME --delete "{\"Objects\":$MARKERS}"
fi

echo -e "\n[3/4] Deleting bucket"
aws s3 rb s3://$BUCKET_NAME

DYNAMO_TABLE="$PROJECT_NAME-tfstate-lock"

echo -e "\n[4/4] Deleting DynamoDB table: $DYNAMO_TABLE"
if aws dynamodb describe-table --table-name $DYNAMO_TABLE &>/dev/null; then
  aws dynamodb delete-table --table-name $DYNAMO_TABLE
  echo "    Table $DYNAMO_TABLE deleted"
else
  echo "    Table not found, skipping"
fi

echo -e "\nBucket $BUCKET_NAME deleted successfully"
