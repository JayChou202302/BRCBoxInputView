# BRCBoxInputView

<a href="./REAMDE_CH.md">中文文档</a>

![](https://img.shields.io/github/v/tag/jaychou202302/BRCBoxInputView?label=Version)
[![Cocoapods Compatible](https://img.shields.io/badge/cocoapods-Compatible-brightgreen.svg)](https://cocoapods.org/pods/BRCBoxInputView)
[![Version](https://img.shields.io/cocoapods/v/BRCBoxInputView.svg?style=flat)](https://cocoapods.org/pods/BRCBoxInputView)
[![License: MIT](https://img.shields.io/badge/License-MIT-black.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/cocoapods/p/BRCBoxInputView.svg?style=flat)](https://cocoapods.org/pods/BRCBoxInputView)

A versatile, highly customizable input view for iOS. It supports various text input customizations, including keyboard settings, caret styles, box alignment, and input length constraints. The view conforms to the `UITextInput` protocol and offers a flexible, user-friendly text input experience suitable for a wide range of applications.

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

## Features

- **Based on UITextInput protocol**
  Supports various text input customizations, the code is efficient, concise and non-invasive, and there is no need to create a UITextField / UITextView view to complete the input.

- **Cursor customization**
  Control the appearance and behavior of the cursor, including width, height, blink duration, and opacity.

- **Box style customization**
  Customize the appearance and alignment of input boxes, including the space between boxes, selection transition duration, and autofill options. It also supports inheritance to meet highly customized needs.

- **Menu operation**
  Supports copy, paste, cut and delete operations in input views.

## Fast Usage

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

## Custom Usage

If you need to customize your input box view, you have the following ways to achieve your purpose

1. Complete the style definition by setting `BoxStyle` / `SelectBoxStyle`

2. By setting `delegate` and implementing the `-boxStyleWithIndex:withBoxView:inInputView:` method, you can dynamically return Style and set your BoxStyle more flexibly.

3. If the above basic properties cannot meet your requirements, you can rewrite a BoxView to meet your highly customized requirements for the view. You need to create a view that inherits `UICollectionCell`, and then use this newly created ` Class is assigned to the BoxClass property of InputView, or you can directly inherit from `BRCBoxView` which has encapsulated many basic functions for us, but you need to note that in some cases, you need to modify the `BRCBoxViewProtocol` in Rewrite methods and properties to ensure that your styles will not be overwritten by the parent class;

More information can be obtained from the examples in the Demo


## Installation

BRCBoxInputView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BRCBoxInputView'
```

# Requirements
iOS 13.0+
Xcode 12+

# Requirements
-  iOS 13.0
-  Xcode 12+

## Author

zhixiongsun, sunzhixiong91@gmail.com

## License

BRCBoxInputView is available under the MIT license. See the LICENSE file for more info.
