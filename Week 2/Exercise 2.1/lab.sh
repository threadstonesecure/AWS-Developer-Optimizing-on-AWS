export AWS_DEFAULT_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/\(.*\)[a-z]/\1/')
AWSAccountId=$(aws sts get-caller-identity --query 'Account' --output text)
CDNBucket=edx-static-website-$AWSAccountId
docker rm -f $(docker ps -a -q)

cd ~/environment
gem install jekyll bundler
jekyll new my-static-website
cd my-static-website
bundle exec jekyll serve --port 8080 -B
cd _site/
aws s3 sync . s3://$CDNBucket