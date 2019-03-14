AWSAccountId=$(aws sts get-caller-identity --query 'Account' --output text)
CDNBucket=edx-static-website-$AWSAccountId
cd ~/environment/ex-serverless/html-frontend/
aws s3 sync . s3://$CDNBucket