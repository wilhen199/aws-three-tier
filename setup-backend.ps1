# Setup Backend S3 + DynamoDB para Terraform
$PROJECT_NAME = "aws-3-tier"
$REGION       = "us-east-1"
$SUFFIX       = -join ((48..57) + (97..102) | Get-Random -Count 8 | ForEach-Object { [char]$_ })
$BUCKET_NAME  = "$PROJECT_NAME-tfstate-$SUFFIX"
$DYNAMO_TABLE = "$PROJECT_NAME-tfstate-lock"

Write-Host "`n[1/4] Creating S3 bucket: $BUCKET_NAME" -ForegroundColor Cyan
aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION
aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled
aws s3api put-public-access-block --bucket $BUCKET_NAME `
  --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

Write-Host "`n[2/4] Creating DynamoDB table: $DYNAMO_TABLE" -ForegroundColor Cyan
$tableExists = aws dynamodb describe-table --table-name $DYNAMO_TABLE --region $REGION 2>$null
if (-not $tableExists) {
  aws dynamodb create-table `
    --table-name $DYNAMO_TABLE `
    --attribute-definitions AttributeName=LockID,AttributeType=S `
    --key-schema AttributeName=LockID,KeyType=HASH `
    --billing-mode PAY_PER_REQUEST `
    --region $REGION
}

Write-Host "`n[3/4] Actualizando providers.tf con el nuevo bucket" -ForegroundColor Cyan
(Get-Content "providers.tf") | ForEach-Object { $_ -replace '(\s*bucket\s*=\s*)".*"', "`$1`"$BUCKET_NAME`"" } | Set-Content "providers.tf"
Write-Host "    bucket = $BUCKET_NAME"

Write-Host "`n[4/4] Initializing Terraform" -ForegroundColor Cyan
terraform init -reconfigure

Write-Host "`nReady! Backend is configured with $BUCKET_NAME" -ForegroundColor Green
