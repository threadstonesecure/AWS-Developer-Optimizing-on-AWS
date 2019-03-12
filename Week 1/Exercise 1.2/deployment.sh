export AWS_DEFAULT_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/\(.*\)[a-z]/\1/')
AWSAccountId=$(aws sts get-caller-identity --query 'Account' --output text)
SourceBucket=sourcebucketname$AWSAccountId

aws cloudformation create-stack --stack-name edx-project-ecr-stack --template-body file://ecr.yaml
 
aws cloudformation wait stack-create-complete --stack-name edx-project-ecr-stack
echo -e "${RED}Exercise 1.2 ECR Stack created!${NOCOLOR}"   

$(aws ecr get-login --no-include-email --region $AWS_DEFAULT_REGION)
docker tag timezones-appserver:latest $AWSAccountId.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/timezones-appserver:latest
docker push $AWSAccountId.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/timezones-appserver:latest
docker tag timezones-frontend:latest $AWSAccountId.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/timezones-frontend:latest
docker push $AWSAccountId.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/timezones-frontend:latest
docker images

# Refer to https://github.com/nathanpeck/ecs-cloudformation
aws iam create-service-linked-role --aws-service-name ecs.amazonaws.com
aws cloudformation create-stack --stack-name edx-project-ecs-stack --template-body file://ecs.yaml \
--capabilities CAPABILITY_NAMED_IAM
 
aws cloudformation wait stack-create-complete --stack-name edx-project-ecs-stack
echo -e "${RED}Exercise 1.2 ECS Stack created!${NOCOLOR}"  

