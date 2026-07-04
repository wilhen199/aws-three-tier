#!/bin/bash
PROJECT_NAME="aws-3-tier"
REGION="us-east-1"
SUFFIX=$(cat /dev/urandom | tr -dc 'a-f0-9' | head -c 8)
BUCKET_NAME="$PROJECT_NAME-tfstate-$SUFFIX"
DYNAMO_TABLE="$PROJECT_NAME-tfstate-lock"

echo -e "\n[1/4] Creating S3 bucket: $BUCKET_NAME"
aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION
aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled
aws s3api put-public-access-block --bucket $BUCKET_NAME \
  --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

echo -e "\n[2/4] Creating DynamoDB table: $DYNAMO_TABLE"
if ! aws dynamodb describe-table --table-name $DYNAMO_TABLE --region $REGION &>/dev/null; then
  aws dynamodb create-table \
    --table-name $DYNAMO_TABLE \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region $REGION
fi

echo -e "\n[3/4] Actualizando providers.tf con el nuevo bucket"
sed -i "s|\(\s*bucket\s*=\s*\)\".*\"|\1\"$BUCKET_NAME\"|" providers.tf
echo "    bucket = $BUCKET_NAME"

echo -e "\n[4/4] Initializing Terraform"
terraform init -reconfigure

echo -e "\nReady! Backend is configured with $BUCKET_NAME"
