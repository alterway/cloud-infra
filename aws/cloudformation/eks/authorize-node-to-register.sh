#!/bin/bash

ENV=$1
PROJECT=$2
NODE_ARN=$(aws cloudformation describe-stacks --stack-name prd-awh-nodegroup-default --query 'Stacks[*].Outputs[0].OutputValue' --output text)

aws eks update-kubeconfig --cluster-name $PROJECT-$ENV

cat << EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: $NODE_ARN
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
EOF

