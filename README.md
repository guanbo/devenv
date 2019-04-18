# Development Environment 

startup development environment on single ec2 instance. Provider single instance infrastructure. such as database, message queue etc.

## Perpare EC2

### Startup

- create iam role with `AmazonEC2ContainerRegistryPowerUser` policy
- spot ami-linux2 with role

### Install Git
```shell
$ sudo yum install -y git
```

### Install Docker
```shell
$ sudo amazon-linux-extras install docker
$ cat << EOF | sudo tee /etc/docker/daemon.json
{
  "registry-mirrors": ["https://registry.docker-cn.com"]
}
EOF
$ sudo service docker start
$ sudo usermod -aG docker ec2-user
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose 
```

### ECR
```shel
$ aws configure
AWS Access Key ID [None]: 
AWS Secret Access Key [None]: 
Default region name [cn-northwest-1]: 
Default output format [json]:
```
AWS id and key are not necessary to be set, because of iam role has already provided.


### Intall Node.js

```sh
$ curl -OL https://nodejs.org/dist/v10.15.3/node-v10.15.3-linux-x64.tar.xz
$ tar -xvf node-v10.15.3-linux-x64.tar.xz
$ cd node-v10.15.3-linux-x64
$ sudo cp bin/node /usr/bin/
$ sudo cp include/* /usr/include/
$ sudo cp lib/* /usr/lib/
$ sudo cp share/* /usr/share/
$ sudo ln -s /usr/lib/node_modules/npm/bin/npm-cli.js /usr/bin/npm
```

## Quick Start

```shell
$ git clone https://github.com/guanbo/devenv.git
$ cd devenv
$ mkdir -p data/mysql
$ docker-compose up -d
```

### Gitlab

- [Startup Gitlab](gitlab/README.md)

### ~~Web Deploy by Nginx~~

```sh
$ cd nginx/conf.d/
$ cp example.com.conf mydomain.com.conf
# edit mydomain.com.conf and save
$ docker exec -t nginx /etc/init.d/nginx reload
# grant gitlab-runner cp static html to nginx/html
$ sudo usermod -aG ec2-user gitlab-runner
$ chmod 750 ~
```