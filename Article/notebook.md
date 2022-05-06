# 一些记录

## 麒麟操作系统

### 1. 新系统采用了4不像如下构架：
* 底层采用 mach 微内核为蓝本；
* 服务层采用 FreeBSD 系统为参照；
* 应用层采用 linux 作参考；
* 界面仿照 windows 来设计。

### 2. 2009年，国家核高基重大专项陆续启动。麒麟系统得到了工信部的支持，得以继续迭代。

* 2006-2009三年间，Linux 一统天下大势已定，多数专家也意识到了“四不像”架构的弊端，在他们的坚持下，麒麟OS 终于转向了 Linux 内核。

* 自从2006年第一版银河麒麟通过验收之后，国家尝试了大量的进口系统替代工作，但是一个残酷的事实摆在面前，由于兼容性缺失，银河麒麟无法替代国外的系统。在原有的架构下，工程师有力气都没处使。

* 但是在银河麒麟OS 3.0 发布之后，人们突然发现，银河麒麟终于可以替代国外系统了。于是，在党政军各个关键机关，真正开启了国产替代的大潮。

### 3. 替代

> 在西昌卫星基地，以及后来的文昌卫星基地，银河麒麟系统已经可以完全承担测发控任务，大家熟悉的天舟飞船发射，以及胖五（长征五号运载火箭），都是由银河麒麟系统保障的。
某军用特种飞机，原来采用惠普的机器、以色列的系统，现在已经全系列配备了“飞腾+银河麒麟”组合。
至于政务系统、军队管理系统、大型国企系统，替换成为银河麒麟的更是数不胜数。

* 2016年，国防科大正式成立天津麒麟，授权天津麒麟成为麒麟品牌唯一的使用者。

* 2017年，孔金珠正式离开军队，成为天津麒麟总裁。

## 有用的资料

* C++学习网站 https://www.learncpp.com/

## 标准monad的实现

``` javascript
class Result{
    constructor(Ok, Err){
        this.Ok = Ok;
        this.Err = Err;
    }
    isOk(){
        return this.Err === null || this.Err === undefined;
    }
    map(fn){
        return this.isOk() ? Result.of(fn(this.Ok),this.Err) : Result.of(this.Ok, fn(this.Err));
    }
    join(){
        if (this.isOk()) {
            return this.Ok;
        }else{
            return this.Err;
        }
    }
    flatMap(fn){
        return this.map(fn).join();
    }
}
Result.of = function(Ok, Err){
    return new Result(Ok, Err);
}

```

