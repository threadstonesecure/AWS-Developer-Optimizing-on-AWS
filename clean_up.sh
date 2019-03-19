for stack in $(aws cloudformation list-stacks --output text --query 'StackSummaries[?starts_with(StackName, `edx-project-`) && (StackStatus==`CREATE_COMPLETE`||StackStatus==`UPDATE_COMPLETE`) && (!ParentId)].[StackName]') ; \
do aws cloudformation delete-stack --stack-name $stack --output text; done

SourceBucket=sourcebucketname$AWSAccountId
aws s3 rb s3://$SourceBucket --force
