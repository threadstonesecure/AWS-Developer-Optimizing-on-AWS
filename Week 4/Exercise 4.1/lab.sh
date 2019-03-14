wget -c https://us-west-2-tcdev.s3.amazonaws.com/courses/AWS-100-ADO/v1.0.0/exercises/ex-dynamodbscale.zip -O ~/ex-dynamodbscale.zip
cd ~/environment
unzip -o ~/ex-dynamodbscale
cd ex-dynamodbscale
sed -i "s/    print(\"PutItem succeeded:\")/print(\"1000 PutItem succeeded:\")/g" put_item_load_test.py
python3 put_item_load_test.py
echo "Sleep 10s"
sleep 10s
python3 put_item_load_test.py
echo "Sleep 10s"
sleep 10s
python3 put_item_load_test.py
echo "Sleep 1m"
sleep 1m
python3 put_item_load_test.py
echo "Sleep 10s"
sleep 10s
python3 put_item_load_test.py
echo "Sleep 10s"
sleep 10s
python3 put_item_load_test.py
sleep 10m
cd ~/environment/ex-dynamodb
python3 put_ddb_item.py