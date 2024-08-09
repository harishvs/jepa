#!/bin/bash
set -e
source common_env.sh
echo " hello $CUSTOM_AMI_LOGS_BUCKET"
if aws s3api head-bucket --bucket "$S3_BUCKET" 2>/dev/null; then
    aws s3 mb $CUSTOM_AMI_LOGS_BUCKET --region $AWS_REGION
fi
echo "Creating pcluster ami using base ami: $PARENT_AMI_ID"
echo "Using following image config"
cat jepa-pcluster-build-config.yaml

pcluster build-image --debug --image-id $PARENT_AMI_ID --image-configuration jepa-pcluster-build-config.yaml --region $AWS_REGION

pcluster export-image-logs --debug --image-id  $PARENT_AMI_ID --region $AWS_REGION --bucket $CUSTOM_AMI_LOGS_BUCKET_ARN

pcluster describe-image --image-id $PARENT_AMI_ID --region $AWS_REGION | grep imageBuildStatus

pcluster list-images --image-status AVAILABLE --region $AWS_REGION

export PCLUSTER_AMIID=$(pcluster describe-image --image-id $PARENT_AMI_ID --region $AWS_REGION |jq -r '.ec2AmiInfo.amiId')
while [ -z "$PCLUSTER_AMIID" ]; do
    echo "custom ami building"
    export PCLUSTER_AMIID=$(pcluster describe-image --image-id $PARENT_AMI_ID --region $AWS_REGION |jq -r '.ec2AmiInfo.amiId')
    sleep 10
done

echo "$PCLUSTER_AMIID is ready to use"
