export AWS_DEFAULT_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/\(.*\)[a-z]/\1/')
AWSAccountId=$(aws sts get-caller-identity --query 'Account' --output text)
SourceBucket=sourcebucketname$AWSAccountId

CDNBucket=edx-static-website-$AWSAccountId
aws cloudformation create-stack --stack-name edx-project-cdn-stack --template-body file://cdn.yaml \
--capabilities CAPABILITY_NAMED_IAM \
--parameters ParameterKey=BucketName,ParameterValue=$CDNBucket
 
aws cloudformation wait stack-create-complete --stack-name edx-project-cdn-stack
echo -e "${RED}Exercise 2.1 CDN Stack created!${NOCOLOR}"   



