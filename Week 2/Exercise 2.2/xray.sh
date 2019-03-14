AWS_DEFAULT_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/\(.*\)[a-z]/\1/')
AWS_ACCESS_KEY_ID=$(aws cloudformation describe-stacks --stack-name edx-project-iam-stack \
--query 'Stacks[0].Outputs[?OutputKey==`AccessKey`].OutputValue' --output text)
AWS_SECRET_ACCESS_KEY=$(aws cloudformation describe-stacks --stack-name edx-project-iam-stack \
--query 'Stacks[0].Outputs[?OutputKey==`SecretKey`].OutputValue' --output text)
docker run -p 2000:2000 -p 2000:2000/udp \
-e AWS_REGION=$AWS_DEFAULT_REGION \
-e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
-e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
--name aws-xray-daemon amazon/aws-xray-daemon