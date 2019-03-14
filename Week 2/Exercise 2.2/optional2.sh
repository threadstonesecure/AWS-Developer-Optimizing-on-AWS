cp Dockerfile ../../../ex-elasticache/FlaskApp/

cd ../../../ex-elasticache/FlaskApp/
XrayCode="xray_recorder.configure(service='elasticache exercise',daemon_address='aws-xray-daemon:2000')"
sed -i "s/xray_recorder.configure(service='elasticache exercise')/$XrayCode/g" application.py

docker build -t elasticache_server .

kill $(lsof -t -i:8080)
MEMCACHED_HOST=$(aws cloudformation describe-stacks --stack-name edx-project-elasticache-stack \
--query 'Stacks[0].Outputs[?OutputKey==`ElastiCacheAddress`].OutputValue' --output text)
docker run -it \
-v /home/ec2-user/.aws:/root/.aws \
-e MEMCACHED_HOST=$MEMCACHED_HOST \
-p 8080:8080 \
--link aws-xray-daemon:aws-xray-daemon \
--name elasticache_server elasticache_server