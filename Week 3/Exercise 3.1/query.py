# Copyright 2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except
# in compliance with the License. A copy of the License is located at
#
# https://aws.amazon.com/apache-2-0/
#
# or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.
from __future__ import print_function
import boto3
from boto3.dynamodb.conditions import Key, Attr
import pprint

pp = pprint.PrettyPrinter(indent=4)

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Courses')

response = table.query(
    KeyConditionExpression=Key('subject').eq('Accounting') 
)
print("subject=Accounting")
items = response['Items']
pp.pprint(items)

response = table.query(
    KeyConditionExpression=Key('subject').eq('Marketing') & Key('course_name').begins_with("Humor")
)
print("subject=Accounting, course_name=begins_with->Humor")
items = response['Items']
pp.pprint(items)

response = table.query(
    KeyConditionExpression=Key('subject').eq('Art History') 
)
print("subject=Accounting")
items = response['Items']
pp.pprint(items)