# AWS/Serverless/Blog

## About

Check out the [Osones article](https://blog.osones.com/gerer-son-blog-en-serverless-avec-s3-cloudfront-github-codepipeline-et-codebuild.html) about this template.

CloudFormation template to setup :

- S3 bucket with website hosting capabilities
- CloudFront distribution in front of the S3 bucket
- Route 53 records to match to the CloudFront CNAME

**Note:** you need to set up the [Route 53 Public Hosted Zone](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingHostedZone.html)
and get an Certificate within the `us-east-1` region from Amazon Certificate
Manager.

## Usage

## Deployment

Edit `XX-parameters.json` according to deployment and launch stack:

```
aws cloudformation create-stack --stack-name prefix-infra-blog-env --template-body file:/serverless-blog-s3.yml --capabilities CAPABILITY_IAM --parameter file://serverless-blog-s3-parameters.json
```
