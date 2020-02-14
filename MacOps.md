# mac下常用命令

## 查看进程占用的端口号

* 查找监听的端口号

    `netstat -an | grep LISTEN`

* 查找某个端口号的进程

    `lsof -n -i:80`

* 查找某个进程的方法，name代表进程的名字

    ` ps -le | grep name`

* 查找所有的进程占用的端口号

    `lsof -i -P`
* 查看路由表
    `netstat -r`