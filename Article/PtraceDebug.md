在iOS逆向中，很多技术帖都提到，可使用ptrace进行反调试。当然为了防止这种反调试手段被攻破，我们还可以使用其他的变种方案。

## 1、为什使用ptrace
如果不了解ptrace的意思和大致作用，可以参照下面的链接：

* [Linux Ptrace 详解](https://www.cnblogs.com/yibutian/p/9482972.html)
* [ptrace - linux man](http://man7.org/linux/man-pages/man2/ptrace.2.html)

或者先不深究，而是简单的，把ptrace理解成用于进程监控和控制的linux方法。也就是说，可以通过ptrace，对指定的进程进行监控和控制。比如XCode中的debug功能，就是通过ptrace实现的。

既然debug功能是通过ptrace实现的，而且反调试的目的就是阻止我们的APP，被破解者在XCode中debug砸壳后的包。那么，我们就可以使用ptrace来反调试。

## 2、怎么使用ptrace
我们先看下ptrace的API定义（可以在sys/ptrace.h里找到）：

``` int ptrace(int _request, pid_t _pid, caddr_t _addr, int _data); ```

一共有四个参数：

* _request: 表示要执行的操作类型，我们反调试会用到PT_DENY_ATTACH，也就是去除进程依附
* _pid: 要操作的目的进程ID，因为我们是反调试，所以就传递0，表示对当前进程进行操作
* _addr: 要监控的内存地址，目前用不上所以就传0
* _data: 保存读取出或者要写入的数据，也用不上，所以就传0
所以合到一起以后，就是这样一句简单的代码：

``` ptrace(PT_DENY_ATTACH, 0, 0, 0)```

不过需要注意的是，因为这句代码只在调用的时候执行，而不是调用一次就循环检测，所以我们需要在代码中加一个定时器，每隔一段时间就调用一次。

此外，我们会发现在iOS工程中，没法儿直接引入sys/ptrace.h，这是因为苹果没有对iOS项目公开。不过，我们可以先新建一个macOS下的command Line Tool类型工程，在这个工程中进入到sys/ptrace.h文件里面，然后复制文件内的所有内容，放到iOS工程里我们随便新建的一个.h文件里面，比如my_ptrace.h。这样，我们就可以通过import my_ptrace.h，做到在iOS工程里面调用ptrace了。

## 3、变种API方案
大家都说虽然调用ptrace可以做到反调试，但是这样直白的调用，会很容易通过fishhook攻破，那我们就换种稍微相对安全点的方案来做。

既然我们知道ptrace的本质，是一种linux的系统调用函数，那么我们是不是可以通过直接调用系统函数的方式，变相的来调用ptrace。

所以我们来看下系统调用的API：

``` int syscall(int, ...); ```

这是个多参函数，只规定了第一个参数是int类型的，而这第一个参，就是我们所希望执行的系统调用。而后面的参数，就是每个系统调用对应的参数。

系统调用类型很多，可以参照sys/syscall.h里面的定义，对于我们反调试来说，就是SYS_ptrace。

所以综合来看，如果使用syscall的方式来调用，就可以这样写：

```syscall(SYS_ptrace, PT_DENY_ATTACH, 0, 0, 0)```
## 4、汇编方案
虽然使用syscall的方案稍微相对安全一点，但说到底都是API调用，仍然无法避免被fishhook攻破。所以我们就一步到底，直接用内联汇编的方式来做。也就是下面这段：

```
static __attribute__((always_inline)) void asm_ptrace() {
#ifdef __arm64__
    __asm__("mov X0, #31\n"
            "mov X1, #0\n"
            "mov X2, #0\n"
            "mov X3, #0\n"
            "mov X16, #26\n"
            "svc #0x80\n"
            );
#endif
}

```
在对代逐行分析之前，我们先对这段代码有个大体的了解。首先，这段汇编代码，就是ptrace调用的汇编写法。其次，X0、X1、X2、X3寄存器，存贮着我们调用ptrace的传参。

然后，我们来逐行分析，先解释汇编以外的代码。第一行：

``` static __attribute__((always_inline)) void asm_ptrace() ```

这行的作用，是定义了一个C方法asm_ptrace，同时设置为内联函数，也就是inline。为什么要设置成always_inline呢？是因为只要设置成了内联函数，那么在编译阶段，就会把这段代码复制到各个调用位置，最终编译的结果里面，我们调用了几次，这段代码就会出现几次，揉杂在其他汇编里，分散在各处加大了攻破的难度。

下一句：

``` #ifdef __arm64__ ```

显而易见，用于判断当前的CPU架构是不是arm64的。

然后是汇编部分的代码，在解释这部分之前，先回顾一下汇编的知识。

arm64架构下，一共有X0 - X30，总计31个通用寄存器，和SP、PC、CPSR等特殊寄存器。我们只着重介绍在本文里会用到的寄存器，其他寄存器的用处，可参照文末的参考资料。

X0 - X7：这8个寄存器，用来存储函数调用时的传参
X16(IP0)：程序内函数间调用临时寄存器
然后是汇编指令，同样的，我们只关注本文中会用到的指令。

MOV：寄存器值传递，比如MOV X0, X1的意思，就是把寄存器X1里的值，传递到X0里
SVC：进入异常同步，即使CPU跳转到同步异常的入口地址，并从这个地址陷入到内核态里
然后我们再回过头大致分析下那段汇编代码：

```
mov X0, #31：为X0寄存器赋值31
mov X1, #0：为X1寄存器赋值0
mov X2, #0：为X2寄存器赋值0
mov X3, #0：为X3寄存器赋值0
mov X16, #26：为X16寄存器赋值26？
svc #0x80：进入内核态？
```

我们可以模模糊糊的对应上，前两节里我们写的高级代码syscall。

第1～4行，表示存储用于ptrace系统调用需要用到的传参。

但是，对于第5、第6行我们还是存在疑问，为什么要这样写？因为这种写法是来源于linux系统。

在linux系统里，提供了通过int 0x80方式调用系统调用的方法。同时使用系统调用号，来区分入口函数。也就是说，想要在linux系统中调用指定的系统调用，就得先指定系统调用号，然后执行int 0x80，就像下面这样：

```
mov eax, 3 //指定系统调用号
mov ebx, fd
mov ecx, buffer
mov edx, nbytes
int 0x80
```

而在arm64架构里，int 0x80对应的就是SVC #0x80，mov eax, 3对应的就是mov X16, #26。

到此为止，我们已经基本上明白了这段汇编代码。但是想要更深入的理解，比如SVC指令和int指令的异同，X16寄存器的更详细解释，还是得继续深入的学一下arm64。所以，这部分内容就留到以后学完了再聊吧。

## 5、拓展一下
那这种使用内联汇编的方式，是不是一定安全的呢？当然不是，我们还是可以通过IDA定位SVC语句，然后再直接修改汇编代码的方式来攻破。

此外，如果我们还想调用其他系统调用怎么办呢？比如说exit。那我们就可以用类似的方式来做：

```
mov X0, #0
mov X16, #1
svc #0x80
```

6、参考资料

> [Linux+ARM64 系统调用](https://blog.csdn.net/liuhangtiant/article/details/85149369)

> [Linux系统调用：使用int 0x80](https://blog.csdn.net/hq815601489/article/details/80009791)

> [用户态和内核态的区别](https://blog.csdn.net/youngyoungla/article/details/53106671)

> [ARM64 汇编——寄存器和指令](https://www.jianshu.com/p/2f4a5f74ac7a)
