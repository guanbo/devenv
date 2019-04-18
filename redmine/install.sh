#!/bin/bash

cd $(dirname $0)

echo "Start install gitlab..."

read -p 'DOMAIN_NAME: ' DOMAIN_NAME
redmine_bucket=gitlab.${DOMAIN_NAME}
if [ $(aws s3api head-bucket --bucket $redmine_bucket 2>&1|grep -c 404) -gt 0 ] 
then
  aws s3 mb s3://$redmine_bucket
fi

sed "s/example.com/$DOMAIN_NAME/" configuration-tpl.yml > configuration.yml

read -p 'REDMINE_EMAIL_PASSWORD: ' REDMINE_EMAIL_PASSWORD
echo "export REDMINE_EMAIL_PASSWORD=$REDMINE_EMAIL_PASSWORD" >> ~/.bashrc

read -p 'REDMINE_DB_PASSWORD: ' REDMINE_DB_PASSWORD
echo "export REDMINE_DB_PASSWORD=$REDMINE_DB_PASSWORD" >> ~/.bashrc

echo "Setup crontab for backup..."
crontab -l > crontab.tmp
if [ "$(grep -c 'gitlab:backup:create' crontab.tmp)" -eq 0 ]
then
  echo '0   4    * * *   docker exec gitlab gitlab-rake gitlab:backup:create CRON=1' >> crontab.tmp
  crontab crontab.tmp
fi
rm crontab.tmp

crontab -l

echo "=============================="
echo "Install OK"
echo "Start up: docker-compose up -d"
echo "Or edit docker-compose.yml and go"