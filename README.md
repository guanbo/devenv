# Development Environment 

startup development environment on single ec2 instance. Provider single instance infrastructure. such as database, message queue etc.

## Prepare

spot ami-linux2

### Docker
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
## Quick Start

```shell
$ docker-compose up -d
```