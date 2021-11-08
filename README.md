# 开发运维资料

主要是记录自己开发的一些学习资料

* [gitbook使用](https://zhuanlan.zhihu.com/p/34946169)

## 常见问题

` TypeError: cb.apply is not a function `
` TypeError: Cannot read property 'pipes' of undefined `

上面的错误是因为gitbook使用的graceful-fs读取文件的库的方式是4.2.0版本的，graceful-fs最新的版本已经废弃了。

* 解决方案1

上面的错误统一解决方案是使用4.2.0版本的库 ``` npm install graceful-fs@4.2.0 --save```

[参考链接](https://stackoverflow.com/questions/64211386/gitbook-cli-install-error-typeerror-cb-apply-is-not-a-function-inside-graceful/65840763#65840763)

* 解决方案2

通过修改graceful-fs的源码解决，如果是用docker部署建议用这个解决方案。

1. 安装完gitbook后，去gitbook的node_module下找到graceful-fs
2. 注释掉`polyfills.js`文件的兼容性代码。

``` javascript

//   fs.stat = statFix(fs.stat)
//   fs.fstat = statFix(fs.fstat)
//   fs.lstat = statFix(fs.lstat)

```
[参考链接](https://mizeri.github.io/2021/04/24/gitbook-cbapply-not-a-function/)
