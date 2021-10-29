JIT = just in time ,简单来说就是在运行时动态编译。一个程序在它运行的时候创建并且运行了全新的代码，而并非那些最初作为这个程序的一部分保存在硬盘上的固有的代码。其实包含两个概念，一个是动态生成代码，再一个是动态运行代码。

我们都知道，计算机运行的都是机器码，而汇编语言的全称应该是“机器码注记语言”，每一条汇编都对应一串机器码。而JIT的原理就是在内存中生成和运行一段代码。

生成的过程，是编译器干的，当然手动也是可以的，而在内存中运行一段代码，则是依赖操作系统提供的mmap syscall来实现的。

比如，下面是一个求和的机器码

//求和函数
long add(long num) { return num + 2; }
//对应机器码
0x55,0x48,0x89,0xe5,0x48,0x89,0x7d,0xf8,0x48,0x8b,0x45,0xf8,
, 0x83, 0xc0, 0x02,0x5d,0xc3
动态地在内存上创建函数之前，我们需要在内存上分配空间。具体到模拟动态创建函数，其实就是将对应的机器码映射到内存空间中。这里我们使用c语言，利用 mmap函数来实现这一点。而mmap函数的底层就是对操作系统mmap syscall的一个封装。

头文件：#include <unistd.h>    #include <sys/mman.h>

定义函数：void *mmap(void *start, size_t length, int prot, int flags, int fd, off_t offsize);

参数说明：
参数     说明
start     指向欲对应的内存起始地址，通常设为NULL，代表让系统自动选定地址，对应成功后该地址会返回。
length     代表将文件中多大的部分对应到内存。

其中，prot 代表映射区域的保护方式，有下列组合
    PROT_EXEC  映射区域可被执行；
    PROT_READ  映射区域可被读取；
    PROT_WRITE  映射区域可被写入；

参数flags：影响映射区域的各种特性。在调用mmap()时必须要指定MAP_SHARED 或MAP_PRIVATE
我们需要这块代码可读可执行，所以我们可以这样来创建一块空间

#include <stdio.h>                                                                                   
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>

//分配内存
void* createSpace(size_t size) {
    void* ptr = mmap(0, size,
            PROT_READ | PROT_WRITE | PROT_EXEC,
            MAP_PRIVATE | MAP_ANON,
            -1, 0);   
    return ptr;
}
我们可以试试把“可执行”PROT_EXEC权限去掉，看看结果如何。

这样我们就获得了一块分配给我们存放代码的空间。下一步就是实现一个方法将机器码拷贝到分配给我们的那块空间上去。使用 memcpy 即可。

//内存中创建函数
void copyCodeToMem(unsigned char* addr) {
    unsigned char macCode[] = {
        0x55,
        0x48,0x89,0xe5,
        0x48,0x89,0x7d,0xf8,
        0x48,0x8b,0x45,0xf8,
        0x48, 0x83, 0xc0, 0x02,
        0x5d,
        0xc3 
    };
    memcpy(addr, macCode, sizeof(macCode));
}
完整的代码如下：

#include <stdio.h>                                                                                   
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>

//分配内存
void* createSpace(size_t size) {
    void* ptr = mmap(0, size,
            PROT_READ | PROT_WRITE | PROT_EXEC,
            MAP_PRIVATE | MAP_ANON,
            -1, 0);   
    return ptr;
}

long add(long num) { return num + 2; }

//内存中创建函数
void copyCodeToMem(unsigned char* addr) {
    unsigned char macCode[] = {
        0x55,
        0x48,0x89,0xe5,
        0x48,0x89,0x7d,0xf8,
        0x48,0x8b,0x45,0xf8,
        0x48, 0x83, 0xc0, 0x02,
        0x5d,
        0xc3 
    };
    memcpy(addr, macCode, sizeof(macCode));
}

int main(int argc, char** argv) {                                                                                              
    const size_t SIZE = 1024;
    typedef long (*demo)(long);
    void* addr = createSpace(SIZE);
    copyCodeToMem(addr);
    demo d1 = addr;
    long result = d1(1);
    printf("result = %ld\n", result); 
    return 0;
}
编译运行结果如下：

[root@VM-0-7-centos develop]# gcc demo.c
[root@VM-0-7-centos develop]# ./a.out
result = 3
copyCodeToMem中的这段机器码是怎么来的呢，其实就是先编译add函数，然后dump出来的机器码。

[root@VM-0-7-centos develop]#startaddress=$(nm -n a.out |grep add| awk '{print "0x"$1;exit}')
[root@VM-0-7-centos develop]#endaddress=$(nm -n a.out |grep -A1 add| awk '{getline;print "0x"$1;exit}')
[root@VM-0-7-centos develop]#objdump -S a.out --start-address=$startaddress --stop-address=$endaddress

a.out:     file format elf64-x86-64


Disassembly of section .text:

0000000000400613 <add>:
  400613:       55                      push   %rbp
  400614:       48 89 e5                mov    %rsp,%rbp
  400617:       48 89 7d f8             mov    %rdi,-0x8(%rbp)
  40061b:       48 8b 45 f8             mov    -0x8(%rbp),%rax
  40061f:       48 83 c0 02             add    $0x2,%rax
  400623:       5d                      pop    %rbp
  400624:       c3                        retq
不用objdump来查看机器码也是可以的，我们可以直接用gcc -S来生成汇编代码，通过查表得方式得到机器码。当然，不同的架构体系有不同的表。

当然，真实的JIT不会只有这么简单，但是基本原理大同小异，其重点也在代码的动态生成和优化上。事实上，动态获取一段程序的机器码也不是通过objdump来做的，现代的编译器，从前端到后端，每一个步骤都是解耦的，比如llvm就提供了这样的能力

mmap能被用来动态执行代码或映射一段内存，更最常见的用途还是文件映射实现共享内存。和mmap类似的memfd_create()共享内存实现，则常被脚本小子用来隐藏进程或在内存中执行木马。

https://llvm.liuxfe.com/post/6799