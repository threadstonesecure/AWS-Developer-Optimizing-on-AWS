export AWS_DEFAULT_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/\(.*\)[a-z]/\1/')
cd ~/environment
wget -c https://us-west-2-tcdev.s3.amazonaws.com/courses/AWS-100-ADO/v1.0.0/exercises/ex-serverless.zip -O ~/ex-serverless.zip
unzip -o ~/ex-serverless.zip
cd ~/environment/ex-serverless/api-service/
sed -i "s/region: us-west-2/region: $AWS_DEFAULT_REGION/g" serverless.yml
npm install -g serverless
npm install
serverless deploy -v
aws cloudformation wait stack-update-complete --stack-name api-service-dev
ServiceEndpoint=$(aws cloudformation describe-stacks --stack-name api-service-dev \
--query 'Stacks[0].Outputs[?OutputKey==`ServiceEndpoint`].OutputValue' --output text)
curl $ServiceEndpoint/v1.0/get_zones
curl $ServiceEndpoint/v1.0/get_current_time/us-west-2
cd ~/environment/ex-serverless/html-frontend/
sudo yum install jq -y
ApiID=$(aws cloudformation describe-stack-resources --stack-name api-service-dev | jq -r '.StackResources[]|select(.ResourceType=="AWS::ApiGateway::RestApi")|.PhysicalResourceId')
aws apigateway get-sdk --rest-api-id $ApiID --stage-name dev --sdk-type javascript ~/javascript-sdk.zip
unzip ~/javascript-sdk.zip