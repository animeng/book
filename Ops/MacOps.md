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
    
* 查看某台服务的端口是否开发
    `nc -vz -w 2 xxxx 080`

## 查看日志

* 实时输出 `tail -f -10`

## 打开模拟器

``` open -a Simulator ```

## 常用证书生成

* 转换成pem格式 openssl rsa -in ~/.ssh/id_rsa -outform pem > id_rsa.pem

## 查看磁盘

1. 查看磁盘情况
`diskutil list `

查看当前目录下所有文件大小 `du -d 1 -h`

查看目录磁盘的排序 `du -s * | sort -nr`

2. 安装smartmontools 检测磁盘寿命
`brew install smartmontools`
`smartctl -a disk0`
