
# DevOp常用命令

## 查看应用端口使用

> lsof -i:3306

路由表查看
> netstat -anp

网络负载查看

> iftop -P

和iftop 命令一样，nethodgs也可以指定一个refresh rate，这样它会在屏幕上刷新结果。使用-d 选项即可

`nethogs -d 1`

每隔一秒刷新流量

## 查看磁盘容量

> df

符合人类读写习惯的用法

> df -h ../home

## Docker常用命令

## dockerfile使用

https://www.runoob.com/docker/docker-dockerfile.html

### Mysql创建实例

#### 创建mysql服务器

> docker run -p 3306:3306 --name mysql -v /root/docker/mysql/conf:/etc/my.conf.d -e MYSQL_ROOT_PASSWORD=20200121 -d 3a5e53f63281

#### 进入容器

>docker exec -it mysql bash

登录mysql
> mysql -u root

#### 安装mysql管理工具Phpmyadmin

安装
> docker pull phpmyadmin/phpmyadmin

启动
> docker run -d --name myadmin --link mysql:mysql -p 8080:8080 phpmyadmin/phpmyadmin

* -d - 以后台模式运行
* --name myadmin - 容器命名为 myadmin, 容器管理时用(启动/停止/重启/查看日志等)
* --link mysql:mysql - 容器关联, 这里我们关联到之前创建的 mysql 容器, 别名这里设置为 db
* -p 8080:80 - 端口映射, 本地端口:容器端口, 访问: http://ip:8080
* phpmyadmin/phpmyadmin - 要初始化的镜像名

#### mysql创建用户

> CREATE USER 'mengtnt'@'%' IDENTIFIED WITH mysql_native_password BY '密码'

授权
> GRANT ALL PRIVILEGES ON *.* TO 'mengtnt'@'%';

### 安装nginx

进入到容器中
> docker exec -it '容器id'  /bin/bash 

如果不行换成/bin/sh

#### `docker-compose`使用

* 要运行这个程序， 只要在这个目录下执行 docker-compose up -d 命令

* 要停止上面的容器， 只需要输入 docker-compose down 命令

#### 国内镜像解决慢的问题

```
curl -L https://get.daocloud.io/docker/compose/releases/download/1.24.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose
```

[引用博客](https://www.wanghaiqing.com/article/d72e5407-f67d-4325-8fc9-08c9f2a97539/)
> 一般情况下，将 /etc/apk/repositories 文件中 Alpine 默认的源地址 `http://dl-cdn.alpinelinux.org/` 替换为 `http://mirrors.ustc.edu.cn/` 即可
可以使用如下命令：`sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories`

#### 使主进程无法结束
`docker run -d '323232' /bin/bash -c "while true;do echo hello docker;sleep 1;done"`

#### 实时查看docker容器日志

`$ sudo docker logs -f -t --tail 行数 容器id `

#### 查看docker容器的使用情况

容器使用的资源
>`docker stats` 每隔一秒刷新

`--no-stream` 不刷新

查看网络内部信息
>`docker network list`
 >`docker network inspect simple-network`

 应用到容器时，可进入容器内部使用ifconfig查看容器的网络详情

## linux防火墙命令

iptable