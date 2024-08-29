# BRCBoxInputView

<a href="./README.md">英文文档</a>

![](https://img.shields.io/github/v/tag/jaychou202302/BRCBoxInputView?label=Version)
[![Cocoapods Compatible](https://img.shields.io/badge/cocoapods-Compatible-brightgreen.svg)](https://cocoapods.org/pods/BRCBoxInputView)
[![Version](https://img.shields.io/cocoapods/v/BRCBoxInputView.svg?style=flat)](https://cocoapods.org/pods/BRCBoxInputView)
[![License: MIT](https://img.shields.io/badge/License-MIT-black.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/cocoapods/p/BRCBoxInputView.svg?style=flat)](https://cocoapods.org/pods/BRCBoxInputView)

适用于 iOS 的多功能、高度可定制的输入视图。它支持各种文本输入自定义，包括键盘设置、插入符号样式、框对齐和输入长度约束。该视图基于 `UITextInput` 协议，提供灵活、用户友好的文本输入体验，适合各种应用程序。

<table>
    <thead>
        <tr>
            <th>BaseInput</th>
            <th>CustomInput</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>
                <img src="https://jaychou202302.github.io/media/BRCBoxInputView/main.PNG"/>
            </td>
            <td>
                <img src="https://jaychou202302.github.io/media/BRCBoxInputView/test.PNG"/>
            </td>
        </tr>
    </tbody>
</table>

## 功能

- **多平台/多框架支持**<br>支持 `UIKit、SwiftUI`框架以及`OC、Swift`两种语言

- **基于 UITextInput 协议**  
  支持各种文本输入自定义，代码高效简洁，无侵入性，同时不用创建`UITextField / UITextView` 视图来完成输入。

- **光标定制**  
  控制光标的外观和行为，包括宽度、高度、闪烁持续时间和不透明度。

- **盒子样式定制**  
  自定义输入框的外观和对齐方式，包括框之间的空间、选择过渡持续时间和自动填充选项，同时也支持通过继承的方式满足高度自定义的需求。

- **菜单操作**  
  支持输入视图中的复制、粘贴、剪切和删除操作。

## 快速使用

`objective-c`
```objective-c
#import "BRCBoxInputView.h"
BRCBoxInputView *view = [[BRCBoxInputView alloc] initWithInputLength:8];
[self.view addSubview:view];
```

`swift`
```swift
import BRCBoxInputView
let boxInputView = BRCBoxInputView(inputLength: 10);
addSubview(boxInputView);
```

`swift-ui`
```swift
import BRCBoxInputView
BRCBoxInput<BRCBox>(text: $boxInputText,isFocus: $isBoxInputFocus)
  .inputLength(8)
  .frame(height: 80)
```

## 使用说明

### 1.参数说明

> [!Note]
> BRCBoxInputView 提供了诸多自定义参数，学习正确使用这些参数，将会帮助你更好的使用该组件

**Q:** 我想要自定义输入框的输入样式，我应该如何设置参数呢<p>
**A:** <p>
1）**基础属性**：`boxSpace`,`boxSize`,`inputMaxLength` 通过这些参数，你可以设置每一个输入框之间的距离以及输入框的大小和输入框的最多数目 <p>
2）**高级属性**：<p>
`boxStyle` 输入框正常状态下的样式，内部支持设置 文本/占位符 的样式以及 `cornerRadius / border / shadow / background-color / foreground-color` 等样式 <p>
`selectedBoxStyle` 输入框选中状态下的样式，内部支持设置 文本/占位符 的样式以及 `cornerRadius / border / shadow / background-color / foreground-color` 等样式 <p>
`autoFillBoxContainer` 是否自动填满整个输入框视图，当该属性设置为 `true`，你可以不用设置参数 `boxSize` ，内部会自己进行计算来自适应设置 `boxSize`

3）**如何使用**：<p>
除了支持直接设置 `boxStyle` 和 `selectedBoxStyle` 等属性外，我们还支持通过回调来自定义每一个输入框不同状态下的样式，你需要设置 `delegate` 参数，同时实现下面方法即可实现不同输入框不同状态下的丰富样式
```objective-c
- (BRCBoxStyle *)boxStyleWithIndex:(NSInteger)index withBoxView:(BRCBoxView *)boxView inInputView:(BRCBoxInputView *)inputView {

}
```

----

**Q:** 我想要自定义输入光标的样式，我应该如何设置参数？<p>
**A:** <p>
`caretWidth`、`caretHeight`、`caretMaxOpacity`、`caretMinOpacity`、`blinkDuration`、`caretTintColor`、`showCaret` 通过这些参数，你可以自定义光标的宽度和高度、颜色以及光标动画的时长、最大/最小透明度 <p>

----

**Q:** 我想要输入框可以进行复制、粘贴、剪切、删除等操作，我应该如何设置<p>
**A:** <p>
`menuActions` 通过设置该参数，你可以决定输入框对哪些剪切板方法的响应，目前支持响应输入框的 复制、粘贴、剪切、删除 四个方法，且内部均已适配完善<p>
`menuDirection` 决定菜单弹出的方向<p>

----

**Q:** 我想要自定义输入框的加密样式，我应该如何设置参数？<p>
**A:** <p>
`secureTransitionDuration`、`secureDelayDuration` 通过设置这些参数，你可以决定加密样式的过渡时长以及延迟展示时长。<p>

----

**Q:** 我想要自定义输入框的键盘、交互样式，我应该如何设置参数？<p>
**A:** <p>
1）**基础参数:** `contentType`、`keyboardType`、`returnKeyType` 通过设置这些参数，你可以设置输入框的键盘、内容、键盘返回按钮样式<p>
2）**高级参数:** <p>
`autoDismissKeyBoardWhenFinishInput`: 是否在完成输入时自动关闭键盘，当输入框输入字符达到 `inputMaxLength` 的时候，键盘会被自动收起<p>
`focusScrollPosition`: 当设置的 `inputMaxLength` 过多的时候，其内部会成为一个可滑动的视图，当输入到一个超出用户视图的输入框时，内部会自动滚动到当前输入视图，你可以选择滚动到当前输入视图的左侧/中间/右侧<p>
`onClickInputViewBlock`: 点击输入框视图进行的操作，默认是点击输入框会反转当前的键盘展示情况 <p>

----

**Q:** 我想要自定义输入框的内容，我应该如何设置参数？<p>
**A:** <p>
1）**基础参数:** `placeHolder`, `text` 你可以通过这些参数来设置输入框的 文本/占位符 <p>
2）**高级参数:** <p>
`alignment` 输入框的对齐样式，当输入框的长度比较短的时候，给定的容器宽度比较长时，这个时候你或许需要设置其对齐方式，例如左对齐/居中对齐/右对齐 <p>
`inputPattern` 输入框的正则输入过滤，你可以通过设置该属性来保证输入框输入的内容是你想要的文本<p>

----

**Q:** 设置的参数不生效是什么原因？<p>
**A:** <p>
内部对属性的设置方法都进行了重写，但是可能存在少部分更新属性比较频繁的时候，会出现没有更新样式的可能，因此我们建议，在完成属性的时候都去调用 `-reloadView:` 方法来重新加载视图，保证视图的样式和你设置的完全一样

----

**Q:** 我想要重写输入框的Box，来达到高度自定义的样式，我应该如何操作？<p>
**A:**<p>
**1.UIKit**
> 方法 1
> 1. 首先你需要写一个 `View` 继承 `UICollectionCell` 类 或者 继承 `BRCBoxView` 来完成你对于视图的高度自定义需求
> 2. 建议你的视图需要遵循 `BRCBoxViewProtocol` 协议，对协议的方法进行实现，这样能够快速高效的搭建其你的输入框样式。

> 方法 2
> 1. 首先你需要写一个 `View` 遵循 `BRCBoxViewProtocol` 协议，并对协议的方法进行实现，这样能够快速搭建输入框样式
> 2. 设置 `delegate` 属性，并对 `delegate` 中的下面方法进行实现，返回你的输入框即可

```objective-c
- (UIView<BRCBoxViewProtocol> *)boxWithIndex:(NSInteger)index inInputView:(BRCBoxInputView *)inputView {

}
```

**2.SwiftUI**
> 1. 你需要自定义一个视图遵循 `View, BRCBoxProtocol` 两个协议，同时对协议中的方法进行实现
> 2. 你需要在使用的时候指定你的 Box 类型并实现 `-customBoxView:` 方法，如下所示 
```swift
BRCBoxInput<CustomBoxView>(text: $text, isFocus: $isFocus)
      .customBoxView { index, isSelect, boxSize in
          CustomBoxView(text:character(at: index, in: text),isSelected:isSelect,boxSize:boxSize)
      }
      .frame(height: 80)
```

### 2.SwiftUI支持

> [!Note]
> BRCBoxInputView 在  **v1.2.0** 的版本之后对 `SwiftUI` 进行了拓展与支持，如果你需要在 SwiftUI 中使用该组件，请升级到 **> v1.2.0** 的版本

**1.支持程度**

目前 `SwiftUI` 已经支持组件的所有参数，你只需要引入 `BRCBoxInputView` 即可调用组件。

**2.高级使用**

由于 `SwiftUI` 中不支持直接继承于 `UIKit` 的某个类型，为了适配自定义输入框视图的需求，我们对其进行了 `UIView` 和 `View`的桥接处理，调用方无需关注其转换过程，只需要遵循新的协议 `BRCBoxProtocol`，对协议方法进行实现即可实现输入框的样式自定义。

## 安装

```ruby
pod 'BRCBoxInputView'
```

## 作者
zhixiongsun, jaychou202302@gmail.com

BRCBoxInputView is available under the MIT license. See the LICENSE file for more info.
