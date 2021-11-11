
# DevOp常用命令

## 1 查看网络相关命令

* 查看应用端口使用 `lsof -i:3306`
* 路由表查看 `netstat -anp`
* 网络负载查看 `iftop -P`
* `nethogs -d 1` 和iftop 命令一样，nethodgs也可以指定一个refresh rate，这样它会在屏幕上刷新结果。使用-d 选项即可每隔一秒刷新流量
* linux防火墙命令 iptable查看路由表

## 2 查看磁盘相关命令

* 查看当前所有磁盘容量 `df`
* 符合人类读写习惯的用法 `df -h ../home`
* 命令用于显示目录或文件的大小 `du -h home`

## 3 Docker使用

### 3.1 dockerfile的使用文档

[dockerfile官方文档](https://www.runoob.com/docker/docker-dockerfile.html)

### 3.2 docker使用Mysql

1. 创建mysql服务器

`docker run -p 3306:3306 --name mysql -v /root/docker/mysql/conf:/etc/my.conf.d -e MYSQL_ROOT_PASSWORD=20200121 -d 3a5e53f63281`

2. 进入容器

`docker exec -it mysql bash`

3. 登录mysql
`mysql -u root`

4. 安装mysql管理工具Phpmyadmin

安装`docker pull phpmyadmin/phpmyadmin`

启动`docker run -d --name myadmin --link mysql:mysql -p 8080:8080 phpmyadmin/phpmyadmin`

* -d - 以后台模式运行
* --name myadmin - 容器命名为 myadmin, 容器管理时用(启动/停止/重启/查看日志等)
* --link mysql:mysql - 容器关联, 这里我们关联到之前创建的 mysql 容器, 别名这里设置为 db
* -p 8080:80 - 端口映射, 本地端口:容器端口, 访问: http://ip:8080
* phpmyadmin/phpmyadmin - 要初始化的镜像名

5. mysql创建用户

* 创建用户 ` CREATE USER 'mengtnt'@'%' IDENTIFIED WITH mysql_native_password BY '密码' `

* 授权 `GRANT ALL PRIVILEGES ON *.* TO 'mengtnt'@'%';`

### 3.3 安装nginx

1. 使用`docker search nginx`命令获取ngin镜像列表。
2. 使用`docker pull nginx`命令拉取nginx镜像到本地，此处我们获取排名第一的是官方最新镜像，其它版本可以去DockerHub查询。
3. 使用`docker images nginx`命令，查看我们拉取到本地的nginx镜像IMAGE ID
4. 首先测试下nginx镜像是否可用，使用`docker run -d --name mynginx -p 80:80 xxxx`创建并启动nginx容器

* -d 指定容器以守护进程方式在后台运行
* --name 指定容器名称，此处我指定的是mynginx
* -p 指定主机与容器内部的端口号映射关系，格式 -p  [宿主机端口号]：[容器内部端口]，此处我使用了主机80端口，映射容器80端口
* xxxx 是nginx的镜像IMAGE ID前4位

5. 进入到容器中 `docker exec -it '容器id'  /bin/bash ` 如果不行换成/bin/sh

### 3.4 `docker-compose`使用

* 要运行这个程序， 只要在这个目录下执行 docker-compose up -d 命令

* 要停止上面的容器， 只需要输入 docker-compose down 命令

* To rebuild this image you must use `docker-compose build` or `docker-compose up --build`

### 3.5 docker国内镜像解决慢的问题

1. 修改 /etc/docker/daemon.json 文件的镜像
2. sudo systemctl daemon-reload
3. sudo systemctl restart docker
4. docker info 查看源

* 一般情况下，将 /etc/apk/repositories 文件中 Alpine 默认的源地址 `http://dl-cdn.alpinelinux.org/` 替换为 `http://mirrors.ustc.edu.cn/` 即可
可以使用如下命令：`sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories`

5. 通过国内的源下载docker-compose
```
curl -L https://get.daocloud.io/docker/compose/releases/download/1.24.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose
```

### 3.6 docker常用的命令

1. 使主进程无法结束 `docker run -d '323232' /bin/bash -c "while true;do echo hello docker;sleep 1;done"`

2. 实时查看docker容器日志`$ sudo docker logs -f -t --tail 行数 容器id `

3. 查看docker容器的使用情况

* 容器使用的资源 `docker stats` 每隔一秒刷新 `--no-stream` 不刷新

* 查看网络内部信息 `docker network list` `docker network inspect simple-network`

* 应用到容器时，可进入容器内部使用ifconfig查看容器的网络详情

4. docker清除命令

* docker container prune 清除已经停止的容器

* docker image prune 清除一些没有构建容器的，无用的镜像

* docker image prune --force --all

5. docker重启

* systemctl restart docker.service 重启所有
* docker ps -a | grep Exited | awk '{print $1}' |xargs docker start 重启所有的服务

### 3.7 docker搭建服务器开发环境

1. 安装ruby环境
``` sh
FROM ruby
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
RUN bundle install
ADD . /myapp
```

2. 安装nodejs
``` sh

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -\
  && apt-get update -qq && apt-get install -qq --no-install-recommends \
    nodejs \
  && apt-get upgrade -qq \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*\
  && npm install -g yarn@1

RUN  curl -sL https://rpm.nodesource.com/setup_14.x | yum install nodejs

```

### 3.8 docker常见问题

1. 启动容器后，立即exit(0)时的原因如下: 

对比发现 启动正常的镜像：
```

"Entrypoint": [
                "/docker-entrypoint.sh"
            ]
```

异常的镜像：

```
"Entrypoint": null
```
原因是容器最后一个进程在容器启动后马上退出，则容器也会退出

entrypoint配置，该配置的作用是在容器启动之前做一些初始化配置，如果没有则容器启动时没有进程，容器也会退出，所以要在`docker-compose.yml` 文件中加上`entrypoint: /docker-entrypoint.sh`即可

## 4 使用vscode远程桌面

[remote官方文档]https://code.visualstudio.com/docs/remote/remote-overview

## 5 githook使用

1. 搭建一个nodejs服务
2. 使用docker搭建ruby服务环境
3. 写webhook的代码 [文档](https://docs.github.com/en/developers/webhooks-and-events/about-webhooks)
