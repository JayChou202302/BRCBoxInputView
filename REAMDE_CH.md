# BRCBoxInputView

<a href="./README.md">英文文档</a>

![](https://img.shields.io/github/v/tag/jaychou202302/BRCBoxInputView?label=Version)
[![Cocoapods Compatible](https://img.shields.io/badge/cocoapods-Compatible-brightgreen.svg)](https://cocoapods.org/pods/BRCBoxInputView)
[![Version](https://img.shields.io/cocoapods/v/BRCBoxInputView.svg?style=flat)](https://cocoapods.org/pods/BRCBoxInputView)
[![License: MIT](https://img.shields.io/badge/License-MIT-black.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/cocoapods/p/BRCBoxInputView.svg?style=flat)](https://cocoapods.org/pods/BRCBoxInputView)

适用于 iOS 的多功能、高度可定制的输入视图。它支持各种文本输入自定义，包括键盘设置、插入符号样式、框对齐和输入长度约束。该视图符合“UITextInput”协议，提供灵活、用户友好的文本输入体验，适合各种应用程序。

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

## 亮点

- **基于 UITextInput 协议**  
  支持各种文本输入自定义，代码高效简洁，无侵入性，同时不用创建UITextField / UITextView 视图来完成输入。

- **光标定制**  
  控制光标的外观和行为，包括宽度、高度、闪烁持续时间和不透明度。

- **盒子样式定制**  
  自定义输入框的外观和对齐方式，包括框之间的空间、选择过渡持续时间和自动填充选项，同时也支持通过继承的方式满足高度自定义的需求。

- **菜单操作**  
  支持输入视图中的复制、粘贴、剪切和删除操作。

## 快速接入

```objective-c
#import "BRCBoxInputView.h"
BRCBoxInputView *view = [[BRCBoxInputView alloc] initWithInputLength:8];
[self.view addSubview:view];
```

```swift
import BRCBoxInputView
let boxInputView = BRCBoxInputView(inputLength: 10);
addSubview(boxInputView);
```

## 自定义说明

如果你需要自定义你的输入框视图，你有以下的方式来达到你的目的

1.通过设置 `BoxStyle` / `SelectBoxStyle` 来完成样式定义

2.通过设置 `delegate`，对 `-boxStyleWithIndex:withBoxView:inInputView:` 方法的实现，来动态返回Style从而更灵活的设置你的BoxStyle

3.如果上面的基础属性无法满足你的要求，你可以可以通过重写一个BoxView来完成你对于视图的高度自定义需求，你需要创建一个视图继承与 `UICollectionCell`，而后将这个新创建的`Class赋值给InputView的BoxClass属性`，或者你可以直接继承与 `BRCBoxView` 它已经为我们封装了很多基础的功能，但是你需要注意的是，在某些情况下，你需要对 `BRCBoxViewProtocol` 中的方法和属性进行重写，这样才能保证你的样式不会被父类覆盖;

更多的信息，可以在Demo中的示例中获取

## 使用

```ruby
pod 'BRCBoxInputView'
```

## 作者
zhixiongsun, jaychou202302@gmail.com

## License

BRCBoxInputView is available under the MIT license. See the LICENSE file for more info.
