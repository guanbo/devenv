# GitLab

## Prepare

### Data Volume

- create > 60GB volume for store data
- format volume and mount it

```shell
$ sudo mkdir /srv/docker
$ sudo mkfs.ext4 /dev/xvdb
$ echo '/dev/xvdb /srv/docker ext4 defaults,nofail 0 2' | sudo tee -a /etc/fstab
$ sudo mount -a
```

## Install

```sh
$ ./install.sh
```

## Restore

```sh
# aws s3 cp s3://backup.gitlab.example.com/1529946801_2018_06_26_11.0.0_gitlab_backup.tar --region cn-northwest-1 /srv/docker/gitlab/data/backups
sudo vi /srv/docker/gitlab/config/gitlab-secrets.json # $.gitlab_rails.*_key_base
docker exec -it gitlab gitlab-rake gitlab:backup:restore
docker restart gitlab
docker exec -it gitlab gitlab-ctl status
docker exec -it gitlab gitlab-rake gitlab:check SANITIZE=true
```

## Update SSL Certificates

### Install Let' encrypt

```sh
$ wget https://dl.eff.org/certbot-auto
$ chmod a+x certbot-auto
$ sudo mv certbot-auto /usr/local/bin
```

### Generate Certificate

```sh
$ certbot-auto certonly --manual --preferred-challenges "dns"  --agree-tos --no-bootstrap \
  -d *.example.com,*.dev.example.com \
  -m email@example.com
  --cert-name example.com

$ sudo cp /etc/letsencrypt/live/example.com/fullchain.pem ~/lab/ssl/wildcard.example.com.crt
$ sudo cp /etc/letsencrypt/live/example.com/privkey.pem ~/lab/ssl/wildcard.example.com.key
```