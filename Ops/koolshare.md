# 梅林系统

## koolshare安装ss

## 更新ss的rules

* 在/koolshare/ss/rules 路径下。可以使用下面的国内ip地址段

> [国内ip段](https://ispip.clang.cn/all_cn.txt)

## 磁盘满了

通过下面几个步骤检测

1. `df -h` 查看哪个挂载的磁盘已经满了

2. `du -h` 查看具体挂载盘的文件夹的大小，找出来比较大的。

3. 移除比较大的日志文件，koolshare中一般是，移除nc文件夹下的日志和传输的日志。

