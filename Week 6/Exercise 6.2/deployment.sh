#!/bin/sh
export AWS_DEFAULT_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/\(.*\)[a-z]/\1/')
wget -c https://s3-us-west-2.amazonaws.com/us-west-2-tcdev/courses/AWS-100-ADO/v1.0.0/exercises/templates/challenge.yaml

sed -i "s/DesiredCapacity: '0'/DesiredCapacity: '1'/g" challenge.yaml
aws ec2 create-key-pair --region $AWS_DEFAULT_REGION --key-name "edxchallengekeypair" | jq -r ".KeyMaterial" > edxchallengekeypair.pem
chmod 400 edxchallengekeypair.pem

aws cloudformation create-stack --stack-name edx-challenge --template-body file://challenge.yaml \
--capabilities CAPABILITY_NAMED_IAM \
--parameters ParameterKey=KeyName,ParameterValue=edxchallengekeypair \
ParameterKey=DBInstanceMasterPassword,ParameterValue=Passw0rd

aws cloudformation wait stack-create-complete --stack-name edx-challenge
echo -e "${RED}Exercise 6.2 edx-custom-resources Stack created!${NOCOLOR}"   