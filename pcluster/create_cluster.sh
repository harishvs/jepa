#!/bin/bash
set -e
source common_env.sh

pcluster create-cluster --cluster-name $CLUSTER_NAME  --cluster-configuration config.yaml

export PCLUSTER_STATUS=$(pcluster describe-cluster -n $CLUSTER_NAME | grep cloudFormationStackStatus)

while [ ! "$PCLUSTER_STATUS" == *"COMPLETE"* ]; do
    echo "building cluster"
    export PCLUSTER_STATUS=$(pcluster describe-cluster -n $CLUSTER_NAME | grep cloudFormationStackStatus)
    sleep 10
done

