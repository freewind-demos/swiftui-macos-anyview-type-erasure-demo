# SwiftUI macOS AnyView Type Erasure Demo

## 简介

这是 1 个专门讲 `AnyView` 的 macOS SwiftUI demo。

它只回答 1 个问题：

```swift
AnyView
```

它到底是干嘛的，为什么大家又常说“别乱用它”。

## 快速开始

### 环境要求

- macOS 14+
- Xcode 15+
- XcodeGen

### 运行

```bash
cd /Volumes/SN550-2T/freewind-demos/swiftui-macos-anyview-type-erasure-demo
./scripts/build.sh
open AnyViewTypeErasureDemo.xcodeproj
```

### 开发循环

```bash
cd /Volumes/SN550-2T/freewind-demos/swiftui-macos-anyview-type-erasure-demo
./dev.sh
```

## 注意事项

- 这里不展开讲复杂泛型
- 这里不展开讲底层性能细节
- 重点只放在“类型擦除”这个体感

## 教程

### 1. `AnyView` 先直觉理解成什么

可以先把它理解成：

- 1 个统一盒子
- 能把不同具体类型的 View 都装进去

比如：

- `Text`
- `HStack`
- `VStack`

本来它们不是同 1 个具体类型。

但装进 `AnyView` 后，外面统一只看见：

- “这是 1 个 `AnyView`”

### 2. 它解决什么问题

`some View` 的前提是：

- 背后仍然是 1 个确定具体类型

但有些场景里，你真要把几种不同具体 View 放到同 1 个位置：

- 条件分支里返回完全不同结构
- 数组里想装不同种类的 View
- 配置项里想缓存不同预览块

这时 `AnyView` 就像“统一包装盒”。

### 3. 生动例子

把 `AnyView` 想成“快递柜标准箱”。

你往里塞的可能是：

- 书
- 水杯
- 耳机

里面东西不同。

但只要都进了标准箱，仓库系统外面就统一按“1 个箱子”处理。

`AnyView` 就是这个“标准箱”。

### 4. 为什么很多人说别乱用

因为它会把原本具体的类型信息擦掉。

所以通常优先考虑：

- 直接写 `some View`
- 用 `@ViewBuilder`
- 用泛型

只有当你真的需要“把不同 View 统一装箱”时，再上 `AnyView`。

### 5. 这个 demo 怎么演示

我做了 2 组体验：

1. 左边切换 3 种完全不同的预览块
2. 左下同时摆 3 个不同类型的 widget，但都先装成 `AnyView`

右边日志会记录：

- 当前到底是哪个具体 View 被装箱了

### 6. 操作

1. 运行 app
2. 点左边 3 个切换按钮
3. 看中间预览样子完全变化
4. 再看左下 widget 货架
5. 体会“外面统一是 `AnyView`，里面具体类型可以不同”
