This repository contains the notes about the Docker training for the support team.

# Installation

We will use [brew](http://brew.sh) and [cask](http://caskroom.io) as package manager on osx.
Think of them az osx version of **yum** or **apt-get**. If you don’t have them:

## brew

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install caskroom/cask/brew-cask
```

If you have them make sure, you have the latest version:
```
brew update
```

## docker

Altaugh there is already docker-machine available, cloudbreak still has a dependency on boot2docker,
so let’s stick boot2docker (b2d):

```
brew cask install virtualbox
brew install docker
brew install boot2docker
```

Correct versions should be:
- `boot2docker version` : 1.8.0
- `docker --version` : 1.9.1

## boot2docker

Boot2docker can refer to 3 different thing:

- boot2docker VM: a virtual machine running in VirtualBox: Its a tiny core linux based minimal linux
  which is tailored to do nothing else than running docker.
- boo2docker cli tool on osx: which talks to virtualbox to create/start/stop the VM
- boot2docker.iso this is the read-only disk/media attached to the boot2docker VM. All the operating system
  even the docker binary is part of this fs. But the persistent data (images/containers/volumes) are going to a writable vhd disk.

## creating the boot2docker VM

Its important to give b2d enough resources:
```
boot2docker init --cpus=4 --disksize=30000 --memory=8192
```

## start th VM
Now you can start it:
```
boot2docker start
```

## setting env

You can do it an individual terminal session:
```
eval "$(boot2docker shellinit)"
```

or I advise to put it into your profile:
```
cat >> ~/.bash_profile << EOF
export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH=$HOME/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=1
EOF
```

You can test it by: `docker ps`

## aliases

Usefull aliases:
```
alias docker-kill-all='docker rm -f $(docker ps -aq)'
alias dps='docker ps'
alias dpsa='docker ps -a'
...
```

## launch the first cintainer

```
docker run -it centos
```


## install nginx

Nginx is not in the official repo, so we need to add a custom repo.

```
cat > /etc/yum.repos.d/nginx.repo <<'EOF'
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=0
enabled=1
EOF
```
Now we can install it:

```
yum update
yum install -y nginx
```

## test nginx

The command `nginx` starts the master and worker process in the background:
```
nginx
```

Lets test it:
```
curl 127.0.0.1
```

## modify the home page
```
cat > /usr/share/nginx/html/index.html <<EOF
<h1> almost lunch time </h1>
EOF
```

test it again: `curl 127.0.0.1`

## attach/detach

Detaching from a container means: *Jumping out of a container* back to the host:
**CTRL-P** followed by a **CTRL-Q**.

First lets rename the container to name we all can refer to:
```
docker rename $(docker ps -lq) cent1
```

Now we can *jump in*:

```
docker attach cent1
```

## check webserver from an other container

Inside of cent1:
```
ip -o -4 a
```


## create image

```
docker commit cent1 lunch
```

list images:
```
docker images
```

# New stuff

- pull ambari ...
- link (2 conatiner nginx/psql)
- consul/registrator
- docker-compose
- swarm?

