#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-0c8b40fccb45fd37f"
ZONE_ID="Z0388521KFVW7JPV7X7D"
DOMAIN_NAME="narendaws-84s.site"
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalouge" "user" "cart" "shipping" "payment" "dispatch" "frontend")

for instance in ${INSTANCES[@]}
do
    INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID --instance-type t3.micro  --security-group-ids $SG_ID --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=$instance}]' --query "Reservations[0].Instances[0].InstanceId" --output text)

    if [ $instance !=  "frontend" ]
    then 
        IP=$(aws ec2 describe-instances --instance-ids i-xxxxxxxxxxxx --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
    else
        IP=$(aws ec2 describe-instances --instance-ids i-xxxxxxxxxxxx --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
    fi
    echo "$instance IP address is: $IP"

    # aws route53 change-resource-record-sets \
    # --hosted-zone-id "$ZONE_ID" \
    # --change-batch '{
    #     "Changes": [
    #         {
    #             "Comment" : "creating or update the ROute 53 records for ROBOSHOP Project"
    #             "Action": "UPSERT",
    #             "ResourceRecordSet": {
    #                 "Name"  : "'$instance.$DOMAIN_NAME'",
    #                 "Type"  : "A",
    #                 "TTL"   : 1,
    #                 "ResourceRecords": [
    #                     {
    #                         "Value": "'$IP'"
    #                     }
                        
    #                 ]
    #             }
    #         }
    #     ]
    # }'
    
done


