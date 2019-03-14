wget -c https://us-west-2-tcdev.s3.amazonaws.com/courses/AWS-100-ADO/v1.0.0/exercises/ex-dynamodbscale.zip -O ~/ex-dynamodbscale.zip
cd ~/environment
unzip -o ~/ex-dynamodbscale
cd ex-dynamodbscale
python3 put_item_load_test.py
sleep 10m
cd ~/environment/ex-dynamodb
python3 put_ddb_item.py