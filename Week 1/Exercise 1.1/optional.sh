cd ~/environment
wget https://us-west-2-tcdev.s3.amazonaws.com/courses/AWS-100-ADO/v1.0.0/exercises/ex-ecs-apache.zip -O ~/ex-ecs-apache.zip
unzip -o ~/ex-ecs-apache.zip
docker rm -f $(docker ps -a -q)
cd ex-ecs/ApplicationServer/
docker build -t timezones-appserver-apache .
docker images
docker run -d -p 8081:8081 timezones-appserver-apache
private_ip=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
docker ps
curl http://$private_ip:8081/api/v1.0/get_zones
cd ~/environment/ex-ecs/FrontEnd
docker build -t timezones-frontend-apache .
docker run -d -e APP_SERVER=http://$private_ip:8081 -p 8080:8080 timezones-frontend-apache