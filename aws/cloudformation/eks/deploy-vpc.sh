#!/bin/bash
ENV=$1
PROJECT=$2

aws cloudformation deploy \
  --stack-name $ENV-$PROJECT-vpc \
  --capabilities CAPABILITY_NAMED_IAM \
  --template-file 00-infra-vpc.yml \
  --parameter-overrides \
    Project="$PROJECT" \
    Env="$ENV" \
    ClusterName=$ENV-$PROJECT \
    PrivateSubnetsCidr=10.1.10.1/24,10.1.11.0/24,10.1.12.0/24 \
    PublicSubnetsCidr=10.1.0.0/24,10.1.1.0/24,10.1.2.0/24 \
    VpcCidr=10.1.0.0/16
