#!/bin/bash

cd $(dirname $0)

echo "Start install gitlab..."

read -p 'domain name: ' DOMAIN_NAME
sed "s/example.com/$DOMAIN_NAME/" gitlab.yml > docker-compose.yml

read -p 'GITLAB_EMAIL_PASSWORD: ' GITLAB_EMAIL_PASSWORD
echo "export GITLAB_EMAIL_PASSWORD=$GITLAB_EMAIL_PASSWORD" >> ~/.bashrc

docker-compose up -d 

echo "Setup crontab for backup..."
if [ "$(crontab -l|grep -c 'gitlab:backup:create')" -eq 0 ]
then
  crontab -l;cat << EOF | crontab -
0   4    * * *   docker exec gitlab gitlab-rake gitlab:backup:create CRON=1
EOF
fi

crontab -l
