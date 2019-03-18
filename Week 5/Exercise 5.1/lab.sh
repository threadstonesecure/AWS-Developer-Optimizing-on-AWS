#!/bin/sh

rm -vf ${HOME}/.aws/credentials
sudo yum -y install jq
export AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')
echo "export AWS_REGION=${AWS_REGION}" >> ~/.bash_profile
# Refer https://docs.aws.amazon.com/cli/latest/reference/configure/set.html
aws configure set default.region ${AWS_REGION}
aws configure get default.region

AWS_ACCESS_KEY_ID=$(aws cloudformation describe-stacks --stack-name edx-project-iam-stack \
--query 'Stacks[0].Outputs[?OutputKey==`AccessKey`].OutputValue' --output text)
AWS_SECRET_ACCESS_KEY=$(aws cloudformation describe-stacks --stack-name edx-project-iam-stack \
--query 'Stacks[0].Outputs[?OutputKey==`SecretKey`].OutputValue' --output text)
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID"
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY"
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY

AWSAccountId=$(aws sts get-caller-identity --query 'Account' --output text)
aws s3 mb s3://edx-exercise5-1-$AWSAccountId
aws s3 rb s3://edx-exercise5-1-$AWSAccountId
AllowBucketDeletionRoleArn=$(aws cloudformation describe-stacks --stack-name edx-project-iam-stack \
--query 'Stacks[0].Outputs[?OutputKey==`AllowBucketDeletionRoleArn`].OutputValue' --output text)
aws sts assume-role --role-arn $AllowBucketDeletionRoleArn --role-session-name 'Session'

aws configure set role_arn $AllowBucketDeletionRoleArn --profile PrivilegedRole
aws configure set source_profile default --profile PrivilegedRole

aws s3 rb s3://edx-exercise5-1-$AWSAccountId --profile PrivilegedRole
