#!/bin/bash

read -p 'Enter your MFA token: ' token
read -p 'Enter profile name: ' profile

json=$(aws sts assume-role --role-arn arn:aws:iam::546240550610:role/Admins \
--role-session-name tf \
--serial-number $( aws configure get mfa_serial --profile $profile ) \
--token-code $token \
--profile $profile)

eval $(echo  $json | jq -r '.Credentials | "AccessKeyId=\(.AccessKeyId)","SecretAccessKey=\(.SecretAccessKey)","SessionToken=\(.SessionToken)"')

export AWS_ACCESS_KEY_ID=$AccessKeyId
export AWS_SECRET_ACCESS_KEY=$SecretAccessKey
export AWS_SESSION_TOKEN=$SessionToken

terraform plan

sleep 5

terraform apply
