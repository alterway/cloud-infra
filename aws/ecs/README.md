# AWS/ECS

## About

CloudFormation templates to setup :

- Custom VPC, public/private subnets and bastion instances
- ECS Cluster

Templates need to be deployed in correct order as stacks make use of globally exported cross stack outputs.

## Usage

## First deployment

Edit `XX-parameters.json` according to deployment and launch stack:

```
aws cloudformation create-stack --stack-name prefix-infra-bastion-prd --template-body file://00-infra-vpc-bastion.yml --capabilities CAPABILITY_IAM --parameter file://00-parameters.json
```

## Apply a change set

It is possible to apply a `ChangeSet` without redeploying the entire stack:

```
aws cloudformation deploy --stack-name prefix-infra-ecs-prd --template-file 00-infra-ecs-cluster.yml --capabilities CAPABILITY_IAM
```
