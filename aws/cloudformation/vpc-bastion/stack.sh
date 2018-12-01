#! /bin/sh
COMMAND=${1}
ENV=${2:-default}
REGION=${3:-eu-west-1}
PROJECT=common
STACK_NAME=vpc-bastion-${ENV}
PATH_TO_ENV=file://../../../env

# ----- ----- ----- ----- -----
if [ $COMMAND = "create" ]; then
    SUBCOMMAND="create-stack"
elif [ $COMMAND = "update" ]; then
    SUBCOMMAND="update-stack"
fi

# ----- ----- ----- ----- -----
function launchStack
{
    aws --profile ${AWS_PROFILE} cloudformation \
        validate-template --template-body file://${STACK_NAME}.yml

    aws --profile ${AWS_PROFILE} \
        --region ${REGION} \
        cloudformation \
        ${SUBCOMMAND} \
        --stack-name els-lab-${ENV}-${STACK_NAME} \
        --template-body file://${STACK_NAME}.yml \
        --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
        --parameter ${PATH_TO_ENV}/${ENV}/${PROJECT}/${STACK_NAME}/parameters.json
}

launchStack
