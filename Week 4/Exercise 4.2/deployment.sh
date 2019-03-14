export AWS_DEFAULT_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/\(.*\)[a-z]/\1/')
AWSAccountId=$(aws sts get-caller-identity --query 'Account' --output text)

# Refer to https://aws.amazon.com/blogs/database/how-to-use-aws-cloudformation-to-configure-auto-scaling-for-amazon-dynamodb-tables-and-indexes/
aws cloudformation update-stack --stack-name edx-project-ecs-stack --template-body file://ecs.yaml \
--capabilities CAPABILITY_NAMED_IAM

aws cloudformation wait stack-update-complete --stack-name edx-project-ecs-stack
echo -e "${RED}Exercise 4.2 ECS Stack updated!${NOCOLOR}" 