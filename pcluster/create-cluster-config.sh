#!/bin/bash
set -e
source common_env.sh

aws s3 mb $FSX_IMPORT_PATH --region $AWS_REGION

export PCLUSTER_AMIID=$(pcluster describe-image --image-id $PARENT_AMI_ID --region $AWS_REGION |jq -r '.ec2AmiInfo.amiId')


cat > config.yaml << EOF
Region: ${AWS_REGION}
Image:
  Os : ubuntu2004
  CustomAmi: ${PCLUSTER_AMIID}
SharedStorage:
  - MountDir: /shared
    Name: fsx
    StorageType: FsxLustre
    FsxLustreSettings:
      StorageCapacity: ${FSX_STORAGE_CAPACITY}   # GB 
      DeploymentType: PERSISTENT_2  # Adjust performance as needed
      PerUnitStorageThroughput: 1000
      WeeklyMaintenanceStartTime: "3:02:30"
HeadNode:
  InstanceType: c5.xlarge
  Networking:
    SubnetId: ${SUBNET_ID}
    ElasticIp: false
  Ssh:
    KeyName: ${SSH_KEY_NAME}
  LocalStorage:
    RootVolume:
        Size: 1024
  Iam:
    S3Access:
    - BucketName: ${FSX_IMPORT_PATH}
    AdditionalIamPolicies:
    - Policy: arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore
  CustomActions:
    OnNodeConfigured:
      Script: s3://${FSX_IMPORT_PATH}/pcluster/postinstall.sh
Scheduling:
  Scheduler: slurm
  SlurmSettings:
    QueueUpdateStrategy: TERMINATE  
  SlurmQueues:
    - Name: compute
      ComputeSettings:
        LocalStorage:
          RootVolume:
            Size: 1024
      CapacityType: ONDEMAND
      ComputeResources:
        - Name: compute
          InstanceType: ${COMPUTE_INSTANCE_TYPE}
          MinCount: 0
          MaxCount: 4
          Efa:
            Enabled: true
      Networking:
        SubnetIds:
          - ${SUBNET_ID}
        PlacementGroup:
          Enabled: true
      Iam:
        AdditionalIamPolicies:
        - Policy: arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore          
EOF