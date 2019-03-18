#!/bin/sh
export AWS_DEFAULT_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/\(.*\)[a-z]/\1/')
AWSAccountId=$(aws sts get-caller-identity --query 'Account' --output text)
SourceBucket=sourcebucketname$AWSAccountId

AWS_ACCESS_KEY_ID=$(aws cloudformation describe-stacks --stack-name edx-project-iam-stack \
--query 'Stacks[0].Outputs[?OutputKey==`AccessKey`].OutputValue' --output text)
AWS_SECRET_ACCESS_KEY=$(aws cloudformation describe-stacks --stack-name edx-project-iam-stack \
--query 'Stacks[0].Outputs[?OutputKey==`SecretKey`].OutputValue' --output text)

#Override Access Key to act as edXOptimizingUser to resolve https://aws.amazon.com/premiumsupport/knowledge-center/update-key-policy-future/
AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
aws cloudformation update-stack --stack-name edx-project-iam-stack --template-body file://iam.yaml \
--capabilities CAPABILITY_NAMED_IAM \
--parameters ParameterKey=Password,ParameterValue=P@ssw0rd 
 
aws cloudformation wait stack-update-complete --stack-name edx-project-iam-stack
AWS_ACCESS_KEY_ID=$(aws cloudformation describe-stacks --stack-name edx-project-iam-stack \
--query 'Stacks[0].Outputs[?OutputKey==`AccessKey`].OutputValue' --output text)
AWS_SECRET_ACCESS_KEY=$(aws cloudformation describe-stacks --stack-name edx-project-iam-stack \
--query 'Stacks[0].Outputs[?OutputKey==`SecretKey`].OutputValue' --output text)
EdxKeyArn=$(aws cloudformation describe-stacks --stack-name edx-project-iam-stack \
--query 'Stacks[0].Outputs[?OutputKey==`EdxKeyArn`].OutputValue' --output text)
LambdaDecryptRoleArn=$(aws cloudformation describe-stacks --stack-name edx-project-iam-stack \
--query 'Stacks[0].Outputs[?OutputKey==`LambdaDecryptRoleArn`].OutputValue' --output text)
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export EdxKeyArn=$EdxKeyArn
export LambdaDecryptRoleArn=$LambdaDecryptRoleArn
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID"
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY"
echo "EdxKeyArn=$EdxKeyArn"
echo "LambdaDecryptRoleArn=$LambdaDecryptRoleArn"
echo -e "${RED}Exercise 5.2 IAM Stack updated!${NOCOLOR}"   