# Eliminar bucket S3 con versionado
$PROJECT_NAME = "aws-3-tier"

Write-Host "`n[0/3] Searching bucket $PROJECT_NAME-tfstate" -ForegroundColor Cyan
$BucketName = aws s3api list-buckets --query "Buckets[?starts_with(Name, '$PROJECT_NAME-tfstate')].Name" --output text

if (-not $BucketName -or $BucketName -eq "None") {
  Write-Host "Bucket not found" -ForegroundColor Red
  exit 1
}
Write-Host "    Bucket found: $BucketName" -ForegroundColor Green

Write-Host "`n[1/3] Deleting bucket versioning: $BucketName" -ForegroundColor Cyan
$versions = aws s3api list-object-versions --bucket $BucketName `
  --query 'Versions[].{Key:Key,VersionId:VersionId}' --output json
if ($versions -ne '[]' -and $versions -ne 'null') {
  aws s3api delete-objects --bucket $BucketName --delete "{`"Objects`":$versions}"
}

Write-Host "`n[2/3] Deleting delete markers" -ForegroundColor Cyan
$markers = aws s3api list-object-versions --bucket $BucketName `
  --query 'DeleteMarkers[].{Key:Key,VersionId:VersionId}' --output json
if ($markers -ne '[]' -and $markers -ne 'null') {
  aws s3api delete-objects --bucket $BucketName --delete "{`"Objects`":$markers}"
}

Write-Host "`n[3/3] Deleting bucket" -ForegroundColor Cyan
aws s3 rb s3://$BucketName 

Write-Host "`nBucket $BucketName deleted successfully" -ForegroundColor Green