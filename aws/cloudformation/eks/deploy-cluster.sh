#!/bin/bash
ENV=$1
PROJECT=$2

PRIVATE_SUBNETS="$(aws cloudformation describe-stacks --stack-name $ENV-$PROJECT-vpc --query 'Stacks[*].Outputs[1].OutputValue' --output text),$(aws cloudformation describe-stacks --stack-name prd-awh-vpc --query 'Stacks[*].Outputs[2].OutputValue' --output text),$(aws cloudformation describe-stacks --stack-name prd-awh-vpc --query 'Stacks[*].Outputs[3].OutputValue' --output text)"
PUBLIC_SUBNETS="$(aws cloudformation describe-stacks --stack-name $ENV-$PROJECT-vpc --query 'Stacks[*].Outputs[5].OutputValue' --output text),$(aws cloudformation describe-stacks --stack-name prd-awh-vpc --query 'Stacks[*].Outputs[6].OutputValue' --output text),$(aws cloudformation describe-stacks --stack-name prd-awh-vpc --query 'Stacks[*].Outputs[7].OutputValue' --output text)"
VPC_ID=$(aws cloudformation describe-stacks --stack-name $ENV-$PROJECT-vpc --query 'Stacks[*].Outputs[4].OutputValue' --output text)

aws cloudformation deploy \
  --stack-name $ENV-$PROJECT-cluster \
  --capabilities CAPABILITY_NAMED_IAM \
  --template-file 01-infra-cluster.yml \
  --parameter-overrides \
    Project="$PROJECT" \
    Env="$ENV" \
    ClusterName="$ENV-$PROJECT" \
    ClusterVersion="1.11" \
    PrivateSubnets="$PRIVATE_SUBNETS" \
    PublicSubnets="$PUBLIC_SUBNETS" \
    VpcId="$VPC_ID"
