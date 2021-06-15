# 崩溃分析

## 符号解析

symbolicatecrash dsym crash.logs三个放在同一个文件夹执行下面的步骤

1. export DEVELOPER_DIR="/Applications/XCode.app/Contents/Developer"

2. ./symbolicatecrash -v MyApp-Crash-log.crash MyApp.dSYM > result.log

或者 ./symbolicatecrash 1.crash xxx.app > 1.log

> 符号解析库路径 /Applications/Xcode.app/Contents/SharedFrameworks/DVTFoundation.framework/Versions/A/Resources/symbolicatecrash

## 系统符号

缺少系统符号可以查看下`~/Library/Developer/Xcode/iOS\ DeviceSupport`目录下系统的库

1. 系统符号表下载

[链接](https://github.com/Zuikyo/iOS-System-Symbols/blob/master/collected-symbol-files.md)

2. 如果设备不支持可以看如下的方法: 

> [参考资料](https://github.com/iGhibli/iOS-DeviceSupport)

放置./deploy文件到`/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform` 然后下载相应的符号，然后使用`./deploy.py` 加载符号

## 手动解析

atos -o /Users/munger/Library/Developer/Xcode/iOS\ DeviceSupport/14.4.2\ \(18D70\)/Symbols/System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore -arch arm64 -l 0x000000018c16f000 0x000000018cca2874
