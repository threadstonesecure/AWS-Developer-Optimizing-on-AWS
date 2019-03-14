export AWS_DEFAULT_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/\(.*\)[a-z]/\1/')
AWSAccountId=$(aws sts get-caller-identity --query 'Account' --output text)

wget -c https://us-west-2-tcdev.s3.amazonaws.com/courses/AWS-100-ADO/v1.0.0/exercises/ex-dynamodb.zip -O ~/ex-dynamodb.zip
cd ~/environment
unzip -o ~/ex-dynamodb.zip
sudo pip-3.6 install -r ex-dynamodb/requirements.txt
cd ex-dynamodb
python3 populate_ddb_data.py