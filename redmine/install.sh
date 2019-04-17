#!/bin/bash

cd $(dirname $0)

echo "Start install gitlab..."

read -p 'DOMAIN_NAME: ' DOMAIN_NAME
sed "s/example.com/$DOMAIN_NAME/" configuration-tpl.yml > configuration.yml

read -p 'REDMINE_EMAIL_PASSWORD: ' REDMINE_EMAIL_PASSWORD
echo "export REDMINE_EMAIL_PASSWORD=$REDMINE_EMAIL_PASSWORD" >> ~/.bashrc

read -p 'REDMINE_DB_PASSWORD: ' REDMINE_DB_PASSWORD
echo "export REDMINE_DB_PASSWORD=$REDMINE_DB_PASSWORD" >> ~/.bashrc

echo "Setup crontab for backup..."
if [ "$(crontab -l|grep -c 'redmine_mysql')" -eq 0 ]
then
  crontab -l;cat << EOF | crontab -
0   3    * * *   docker exec redmine_mysql mysqldump -p${REDMINE_DB_PASSWORD} redmine > redmine-backup && aws s3 mv --region cn-northwest-1 redmine-backup s3://redmine.${DOMAIN_NAME}/backup/\$(date +\\%F)
*/1 8-23 * * 1-5 docker exec redmine rake redmine:fetch_changesets
EOF
fi

crontab -l

echo "=============================="
echo "Install OK"
echo "Start up: docker-compose up -d"
echo "Or edit docker-compose.yml and go"