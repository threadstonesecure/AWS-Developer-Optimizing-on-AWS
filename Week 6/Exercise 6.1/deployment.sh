#!/bin/sh
export AWS_DEFAULT_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/\(.*\)[a-z]/\1/')
wget -c https://s3-us-west-2.amazonaws.com/us-west-2-tcdev/courses/AWS-100-ADO/v1.0.0/exercises/templates/template.yaml
sudo yum -y install jq
aws ec2 create-key-pair --region $AWS_DEFAULT_REGION --key-name "edxkeypair" | jq -r ".KeyMaterial" > edxkeypair.pem
chmod 400 edxkeypair.pem

aws cloudformation create-stack --stack-name edx-custom-resources --template-body file://template.yaml \
--capabilities CAPABILITY_NAMED_IAM \
--parameters ParameterKey=KeyName,ParameterValue=edxkeypair

aws cloudformation wait stack-create-complete --stack-name edx-custom-resources
echo -e "${RED}Exercise 6.1 edx-custom-resources Stack updated!${NOCOLOR}"   