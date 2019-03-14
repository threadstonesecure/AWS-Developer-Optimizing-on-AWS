export AWS_DEFAULT_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/\(.*\)[a-z]/\1/')
AWSAccountId=$(aws sts get-caller-identity --query 'Account' --output text)
docker rm -f $(docker ps -a -q)

wget -c https://us-west-2-tcdev.s3.amazonaws.com/courses/AWS-100-ADO/v1.0.0/exercises/ex-elasticache.zip -O ~/ex-elasticache.zip
cd ~/environment
unzip -o ~/ex-elasticache.zip
sudo pip-3.6 install -r ex-elasticache/FlaskApp/requirements.txt

kill $(lsof -t -i:8080)

MEMCACHED_HOST=$(aws cloudformation describe-stacks --stack-name edx-project-elasticache-stack \
--query 'Stacks[0].Outputs[?OutputKey==`ElastiCacheAddress`].OutputValue' --output text)
MEMCACHED_HOST=$MEMCACHED_HOST  python3 ex-elasticache/FlaskApp/application.py