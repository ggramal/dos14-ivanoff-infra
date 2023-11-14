#!/bin/bash
# For use this script you need to install jq "sudo apt install jq"
read -p 'Enter your MFA code: ' mfa_code
read -p 'Enter your MFA name: ' mfa_name
read -p 'Enter your profile name: ' profile_name
export AWS_PROFILE=$profile_name
accountID=$( aws sts get-caller-identity --profile $profile_name | jq -r '.Account')
json=$( aws sts assume-role --role-arn arn:aws:iam::$accountID:role/Admins \
--role-session-name tf \
--serial-number arn:aws:iam::$accountID:mfa/$mfa_name \
--token-code $mfa_code \
--profile $profile_name )
eval $(echo  $json | jq -r '.Credentials | "AccessKeyId=\(.AccessKeyId)","SecretAccessKey=\(.SecretAccessKey)","SessionToken=\(.SessionToken)"')
export AWS_ACCESS_KEY_ID=$AccessKeyId
export AWS_SECRET_ACCESS_KEY=$SecretAccessKey
export AWS_SESSION_TOKEN=$SessionToken
echo "AWS environment variables is create"