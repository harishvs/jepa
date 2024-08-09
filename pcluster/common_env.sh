#!/bin/bash
AWS_REGION=us-east-2
# this is the ami id for Deep Learning Base OSS Nvidia Driver GPU AMI, will be different for different regions
PARENT_AMI_ID=ami-0ab5d8adfc131aa29 
CUSTOM_AMI_LOGS_BUCKET=s3://jepa-custom-ami-logs
CUSTOM_AMI_LOGS_BUCKET_ARN="arn:aws:s3:::jepa-custom-ami-logs"
SSH_KEY_NAME=$SSH_KEY_NAME
COMPUTE_INSTANCE_TYPE=g5.16xlarge
#the subnet where you want the head and compute nodes to be launched
SUBNET_ID=subnet-0e19a389b1e361480
FSX_IMPORT_PATH="jepa-fsx-import-bucket"
FSX_EXPORT_PATH="s3://jepa-fsx-export-bucket/"
FSX_STORAGE_CAPACITY=2400
CLUSTER_NAME=vjepa6