cd ~/environment
kill $(lsof -t -i:8080)

echo -e "aws-xray-sdk" >> ex-elasticache/FlaskApp/requirements.txt
sudo pip-3.6 install -r ex-elasticache/FlaskApp/requirements.txt

XrayCode="from aws_xray_sdk.core import xray_recorder\nfrom aws_xray_sdk.ext.flask.middleware import XRayMiddleware\napplication = Flask(__name__)\nxray_recorder.configure(service='elasticache exercise')\nXRayMiddleware(application, xray_recorder)\n"

sed -i "s/application = Flask(__name__)/$XrayCode/g" ex-elasticache/FlaskApp/application.py

MEMCACHED_HOST=$(aws cloudformation describe-stacks --stack-name edx-project-elasticache-stack \
--query 'Stacks[0].Outputs[?OutputKey==`ElastiCacheAddress`].OutputValue' --output text)
MEMCACHED_HOST=$MEMCACHED_HOST  python3 ex-elasticache/FlaskApp/application.py