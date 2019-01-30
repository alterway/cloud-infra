#!/bin/bash
ENV=$1
PROJECT=$2

PRIVATE_SUBNETS="$(aws cloudformation describe-stacks --stack-name $ENV-$PROJECT-vpc --query 'Stacks[*].Outputs[1].OutputValue' --output text),$(aws cloudformation describe-stacks --stack-name prd-awh-vpc --query 'Stacks[*].Outputs[2].OutputValue' --output text),$(aws cloudformation describe-stacks --stack-name prd-awh-vpc --query 'Stacks[*].Outputs[3].OutputValue' --output text)"
VPC_ID=$(aws cloudformation describe-stacks --stack-name $ENV-$PROJECT-vpc --query 'Stacks[*].Outputs[4].OutputValue' --output text)
CONTROL_PLANE_SG=$(aws cloudformation describe-stacks --stack-name $ENV-$PROJECT-cluster --query 'Stacks[*].Outputs[0].OutputValue' --output text)

aws cloudformation deploy \
  --stack-name $ENV-$PROJECT-nodegroup-default \
  --capabilities CAPABILITY_NAMED_IAM \
  --template-file 02-infra-nodegroup.yml \
  --parameter-overrides \
    BootstrapArguments="" \
    ClusterControlPlaneSecurityGroup="$CONTROL_PLANE_SG" \
    ClusterName="$PROJECT-$ENV" \
    KeyName=aw-tp \
    NodeAutoScalingGroupDesiredCapacity=2 \
    NodeAutoScalingGroupMaxSize=4 \
    NodeAutoScalingGroupMinSize=2 \
    NodeGroupName="$ENV-$PROJECT-default" \
    NodeImageId=ami-01e08d22b9439c15a \
    NodeInstanceType=c5.large \
    NodeVolumeSize=20 \
    Subnets="$PRIVATE_SUBNETS" \
    VpcId="$VPC_ID"
