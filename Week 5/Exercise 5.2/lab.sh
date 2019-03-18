#!/bin/sh
cd ~/environment
wget -c https://us-west-2-tcdev.s3.amazonaws.com/courses/AWS-100-ADO/v1.0.0/exercises/ex-kms.zip -O ~/ex-kms.zip
unzip -o ~/ex-kms.zip
cd ~/environment/ex-kms
sudo pip-3.6 install -r requirements.txt
EdxKeyArn=$(aws cloudformation describe-stacks --stack-name edx-project-iam-stack \
--query 'Stacks[0].Outputs[?OutputKey==`EdxKeyArn`].OutputValue' --output text)
LambdaDecryptRoleArn=$(aws cloudformation describe-stacks --stack-name edx-project-iam-stack \
--query 'Stacks[0].Outputs[?OutputKey==`LambdaDecryptRoleArn`].OutputValue' --output text)
AWS_ACCESS_KEY_ID=$(aws cloudformation describe-stacks --stack-name edx-project-iam-stack \
--query 'Stacks[0].Outputs[?OutputKey==`AccessKey`].OutputValue' --output text)
AWS_SECRET_ACCESS_KEY=$(aws cloudformation describe-stacks --stack-name edx-project-iam-stack \
--query 'Stacks[0].Outputs[?OutputKey==`SecretKey`].OutputValue' --output text)

AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
python3 encryptor.py $EdxKeyArn "Super Secret Connection String" --verbose
AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
python3 encryptor.py $EdxKeyArn "Really Super Secret Connection String with Credentials" --output lambdaEnvVars.json

cd ~/environment/ex-kms
aws lambda create-function --function-name "decryptor" --runtime "python3.6" --role $LambdaDecryptRoleArn --handler "decryptor.lambda_handler" \
--zip-file fileb://decryptor.zip --description "lambda function with an encrypted envvar, which we'll decrypt" --cli-input-json file://lambdaEnvVars.json
aws lambda invoke --function-name decryptor decrypt.output
cat decrypt.output