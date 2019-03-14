export AWS_DEFAULT_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/\(.*\)[a-z]/\1/')
AWSAccountId=$(aws sts get-caller-identity --query 'Account' --output text)

aws cloudformation create-stack --stack-name edx-project-dynamodb-stack --template-body file://dynamodb.yaml 

aws cloudformation wait stack-create-complete --stack-name edx-project-dynamodb-stack
echo -e "${RED}Exercise 3.1 Dynamodb Stack created!${NOCOLOR}" 