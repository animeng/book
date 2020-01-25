
# DevOp常用命令

## 查看应用端口使用

> lsof -i:3306

路由表查看
> netstat -anp

网络负载查看

> iftop -P

## 查看磁盘容量

> df

## Docker常用命令

### Mysql命令

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

#### `docker-compose`使用

* 要运行这个程序， 只要在这个目录下执行 docker-compose up -d 命令

* 要停止上面的容器， 只需要输入 docker-compose down 命令