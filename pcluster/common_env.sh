#!/bin/bash
AWS_REGION=us-east-2
PARENT_AMI_ID=ami-0ab5d8adfc131aa29
CUSTOM_AMI_LOGS_BUCKET=s3://jepa-custom-ami-logs
SSH_KEY_NAME=$SSH_KEY_NAME
COMPUTE_INSTANCE_TYPE=g5.16xlarge
IFACE=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
SUBNET_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${IFACE}/subnet-id)
FSX_IMPORT_PATH=jepa-harish-fsx-import-bucket
FSX_EXPORT_PATH=s3://jepa-harish-fsx-export-bucket/
FSX_STORAGE_CAPACITY=2400
CLUSTER_NAME=vjepa-take5