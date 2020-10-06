# swift-package

[标准文档](https://swift.org/getting-started/#using-the-package-manager)

## Start

``` shell
 swift package init --type executable // 可执行文件
 swift package init --type library // 库文件
```

### 编译
``` shell
swift build
```

### 运行
``` shell
swift run
```

### 生成xcode工程
```
swift package generate-xcodeproj
```

## grammar

``` swift
let package = Package(
    name: "SimpleCoreDataExample",
    products: [
        .executable(name: "SimpleCoreDataExample", targets: ["SimpleCoreDataExample"]),
    ],
    dependencies: [
        // "from" is git tag
         .package(url: "../../",from:"0.0.1") 
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        .target(
            name: "SimpleCoreDataExample",
            dependencies: ["SimpleCoreData"]),
    ]
)
```

## file struct

```
SimpleCoreDataExample
├── Sources
│   └── SimpleCoreDataExample
│       ├── AppDelegate.swift
│       ├── SceneDelegate.swift
│       └── ViewController.swift
└── Package.swift
```

## xcode工程增加swift package依赖

https://developer.apple.com/documentation/swift_packages

## problem

> qa : ```error: executable product 'SimpleCoreDataExample' should have exactly one executable target```

> answer: executable需要一个main.swift
* [参考资料](https://forums.swift.org/t/swift-5-building-from-package-manifest-resulting-in-error-stating-an-incorrect-number-of-targets-for-executable/18869/5)