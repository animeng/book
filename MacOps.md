# mac下常用命令

## 恢复模式

command+R进入恢复模式

* 关闭系统完备性，可以删除某些系统文件
    `csrutil disable`

* 开启系统完备性，可以删除某些系统文件
    `csrutil enabled`

* 查看系统完备性权限
    `csrutil status`

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

## 查看日志

* 实时输出 `tail -f -10`