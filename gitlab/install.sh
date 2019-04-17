#!/bin/bash

cd $(dirname $0)

echo "Start install gitlab..."

read -p 'DOMAIN_NAME: ' DOMAIN_NAME
# domain_dash=${DOMAIN_NAME//./-}
gitlab_bucket=gitlab.${DOMAIN_NAME}
if [ $(aws s3api head-bucket --bucket $gitlab_bucket 2>&1|grep -c 404) -gt 0 ] 
then
  aws s3 mb s3://$gitlab_bucket
fi
sed -e "s/example.com/$DOMAIN_NAME/" gitlab.yml > docker-compose.yml

read -p 'GITLAB_EMAIL_PASSWORD: ' GITLAB_EMAIL_PASSWORD
echo "export GITLAB_EMAIL_PASSWORD=$GITLAB_EMAIL_PASSWORD" >> ~/.bashrc

echo "Setup crontab for backup..."
if [ "$(crontab -l|grep -c 'gitlab:backup:create')" -eq 0 ]
then
  crontab -l;cat << EOF | crontab -
0   4    * * *   docker exec gitlab gitlab-rake gitlab:backup:create CRON=1
EOF
fi

crontab -l

echo "=============================="
echo "Install OK"
echo "Start up: docker-compose up -d"
echo "Or edit docker-compose.yml and go"