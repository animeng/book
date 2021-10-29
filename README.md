# 开发运维资料

主要是记录自己开发的一些学习资料

* [gitbook使用](https://zhuanlan.zhihu.com/p/34946169)

## 常见问题

1. ``` TypeError: cb.apply is not a function ```
2. ``` TypeError: Cannot read property 'pipes' of undefined ```

上面的错误统一解决方案是使用4.2.0版本的库 ``` npm install graceful-fs@4.2.0 --save```

[参考链接](https://stackoverflow.com/questions/64211386/gitbook-cli-install-error-typeerror-cb-apply-is-not-a-function-inside-graceful/65840763#65840763)