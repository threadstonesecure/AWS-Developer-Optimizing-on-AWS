cp Dockerfile ../../../ex-elasticache/FlaskApp/

cd ../../../ex-elasticache/FlaskApp/
XrayCode="import os\nxray_recorder.configure(service='elasticache exercise',daemon_address=os.environ['DOCKER_HOST']+':2000')"
sed -i "s/xray_recorder.configure(service='elasticache exercise')/$XrayCode/g" application.py

docker build -t elasticache_server .

kill $(lsof -t -i:8080)
MEMCACHED_HOST=$(aws cloudformation describe-stacks --stack-name edx-project-elasticache-stack \
--query 'Stacks[0].Outputs[?OutputKey==`ElastiCacheAddress`].OutputValue' --output text)
docker run -it \
-v /home/ec2-user/.aws:/root/.aws \
-e MEMCACHED_HOST=$MEMCACHED_HOST \
-e "DOCKER_HOST=$(ip -4 addr show docker0 | grep -Po 'inet \K[\d.]+')" \
-p 8080:8080 \
--name elasticache_server elasticache_server