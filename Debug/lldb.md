# 常见调试方法

## 使用lldb调试

lldb --source debug.cmd
1. platform select ios-simulator
2. platform connect 72910B8C-9149-4260-8552-023E8543A0C9
3. process attach -n Calculator --waitfor
4. br s -F main
5. process continue

> [参考资料](http://junch.github.io/debug/2016/09/19/original-lldb.html)

## linux signal
下面是linux内核定义的POSIX的API
> [signal处理](https://www.gnu.org/software/libc/manual/html_node/Signal-Handling.html)
