#!/bin/bash
# For use this script you need to install jq "sudo apt install jq"
read -p 'Input token code: ' token_key
read -p 'Input profile name: ' profile
json=$(aws sts assume-role --role-arn arn:aws:iam::546240550610:role/Admins \
--role-session-name tf \
--serial-number arn:aws:iam::546240550610:mfa/$profile \
--token-code $token_key \
--profile $profile)
eval $(echo  $json | jq -r '.Credentials | "AccessKeyId=\(.AccessKeyId)","SecretAccessKey=\(.SecretAccessKey)","SessionToken=\(.SessionToken)"')
export AWS_ACCESS_KEY_ID=$AccessKeyId
export AWS_SECRET_ACCESS_KEY=$SecretAccessKey
export AWS_SESSION_TOKEN=$SessionToken
#terraform plan