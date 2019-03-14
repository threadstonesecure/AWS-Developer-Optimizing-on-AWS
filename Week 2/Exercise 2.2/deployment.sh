export AWS_DEFAULT_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/\(.*\)[a-z]/\1/')
AWSAccountId=$(aws sts get-caller-identity --query 'Account' --output text)

sudo yum install jq -y
DedaultVpcId=$(aws ec2 describe-vpcs --filters "Name=isDefault, Values=true" | jq -r .Vpcs[0].VpcId)
DefaultSubnet1Id=$(aws ec2 describe-subnets --query 'Subnets[?DefaultForAz==`true`]' | jq .[0].SubnetId)
DefaultSubnet2Id=$(aws ec2 describe-subnets --query 'Subnets[?DefaultForAz==`true`]' | jq .[1].SubnetId)
Cloud9SecurityGroupName=$(ec2-metadata -s | cut -d " " -f 2);
Cloud9SecurityGroupId=$(aws ec2 describe-security-groups --group-names $Cloud9SecurityGroupName | jp  "SecurityGroups[0].GroupId")

aws cloudformation create-stack --stack-name edx-project-elasticache-stack --template-body file://elasticache.yaml \
--parameters ParameterKey=VPC,ParameterValue=$DedaultVpcId \
ParameterKey=Subnet1,ParameterValue=$DefaultSubnet1Id \
ParameterKey=Subnet2,ParameterValue=$DefaultSubnet2Id \
ParameterKey=Cloud9SecurityGroupId,ParameterValue=$Cloud9SecurityGroupId

aws cloudformation wait stack-create-complete --stack-name edx-project-elasticache-stack
echo -e "${RED}Exercise 2.2 ElastiCache Stack created!${NOCOLOR}"   



