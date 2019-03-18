sed -i "s/WriteCapacityUnits: 1/WriteCapacityUnits: 15/g" challenge.yaml

aws cloudformation update-stack --stack-name edx-challenge --template-body file://challenge.yaml \
--capabilities CAPABILITY_NAMED_IAM \
--parameters ParameterKey=KeyName,ParameterValue=edxchallengekeypair \
ParameterKey=DBInstanceMasterPassword,ParameterValue=Passw0rd

aws cloudformation wait stack-update-complete --stack-name edx-challenge
echo -e "${RED}Exercise 6.2 lab 3 Stack updated!${NOCOLOR}"   