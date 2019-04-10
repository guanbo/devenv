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

## Quick Start

```shell
$ git clone https://github.com/guanbo/devenv.git
$ cd devenv
$ docker-compose up -d
```