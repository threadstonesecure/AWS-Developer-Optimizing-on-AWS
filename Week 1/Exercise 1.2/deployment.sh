export AWS_DEFAULT_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/\(.*\)[a-z]/\1/')
AWSAccountId=$(aws sts get-caller-identity --query 'Account' --output text)
SourceBucket=sourcebucketname$AWSAccountId

aws s3 sync . s3://$SourceBucket --exclude "*" --include "*.yaml"

aws cloudformation create-stack --stack-name edx-project-ecr-stack --template-body file://ecr.yaml
 
aws cloudformation wait stack-create-complete --stack-name edx-project-ecr-stack
echo -e "${RED}Exercise 1.2 ECR Stack created!${NOCOLOR}"   