<p align='center'>
    <img src="https://jaychou202302.github.io/media/BRCBoxInputView/logo.gif"/>
</p>


# BRCBoxInputView

![](https://img.shields.io/github/v/tag/jaychou202302/BRCBoxInputView?label=Version)
[![Cocoapods Compatible](https://img.shields.io/badge/cocoapods-Compatible-brightgreen.svg)](https://cocoapods.org/pods/BRCBoxInputView)
[![Version](https://img.shields.io/cocoapods/v/BRCBoxInputView.svg?style=flat)](https://cocoapods.org/pods/BRCBoxInputView)
[![License: MIT](https://img.shields.io/badge/License-MIT-black.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/cocoapods/p/BRCBoxInputView.svg?style=flat)](https://cocoapods.org/pods/BRCBoxInputView)

A versatile, highly customizable input view for iOS. It supports various text input customizations, including keyboard settings, caret styles, box alignment, and input length constraints. The view conforms to the `UITextInput` protocol and offers a flexible, user-friendly text input experience suitable for a wide range of applications.

<table>
    <thead>
        <tr>
            <th>PopUp</th>
            <th>DropDown</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>
                <img src="https://jaychou202302.github.io/media/BRCDropDown/1.GIF"/>
            </td>
            <td>
                <img src="https://jaychou202302.github.io/media/BRCDropDown/2.GIF"/>
            </td>
        </tr>
    </tbody>
</table>

## Features

- **UITextInput Compliance**  
  Supports various text input customizations such as autocapitalization, autocorrection, spell checking, and more.

- **Caret Customization**  
  Control the appearance and behavior of the caret, including width, height, blink duration, and opacity.

- **Box Style Customization**  
  Customize the appearance and alignment of input boxes, including space between boxes, select transition duration, and auto-fill options.

- **Menu Actions**  
  Support for copy, paste, cut, and delete actions within the input view.

- **Input Handling**  
  Manage the input length, current input index, and handle custom input events.

- **First Responder Control**  
  Toggle the first responder status programmatically.

## Usage

### Required Parameters
1. `inputLength` - The length of the input.

### Available Customizations - Optional Parameters

#### UITextInput Traits
1. `autocapitalizationType` - Controls whether text should be auto-capitalized.
2. `autocorrectionType` - Controls whether text should be auto-corrected.
3. `spellCheckingType` - Controls whether text should be spell-checked.
4. `smartQuotesType` - Controls whether smart quotes should be used.
5. `smartDashesType` - Controls whether smart dashes should be used.
6. `smartInsertDeleteType` - Controls whether smart insert/delete should be used.
7. `keyboardType` - The type of keyboard to display.
8. `keyboardAppearance` - The appearance style of the keyboard.
9. `returnKeyType` - The return key type for the keyboard.
10. `enablesReturnKeyAutomatically` - Controls whether the return key is automatically enabled.
11. `textContentType` - The type of content the text input represents.
12. `passwordRules` - The password rules for the text input.

#### Menu Customization
1. `copyable` - Controls whether text can be copied.
2. `pasteable` - Controls whether text can be pasted.
3. `cutable` - Controls whether text can be cut.
4. `deleteable` - Controls whether text can be deleted.
5. `setMenuable:` - Sets whether the text menu is enabled.

#### Caret Customization
1. `showCaret` - Controls whether the caret is shown.
2. `caretWidth` - The width of the caret.
3. `caretHeight` - The height of the caret.
4. `caretMaxOpacity` - The maximum opacity of the caret.
5. `caretMinOpacity` - The minimum opacity of the caret.
6. `blinkDuration` - The duration of the caret blink animation.

#### Box Style Customization
1. `boxSpace` - The space between boxes.
2. `selectTransitionDuration` - The duration of the select transition animation.
3. `alignment` - The alignment of the boxes.
4. `autoDismissKeyBoardWhenFinishInput` - Controls whether the keyboard is automatically dismissed when input is finished.
5. `autoFillBoxContainer` - Controls whether the box container is automatically filled.
6. `isRTL` - Controls whether the text input is in right-to-left mode.
7. `placeHolder` - The placeholder text for the input.
8. `inputText` - The current input text.
9. `currentInputIndex` - The current input index (read-only).
10. `inputMaxLength` - The maximum length of the input (read-only).
11. `onClickInputViewBlock` - A block that is called when the input view is clicked.

### Initialization
1. `initWithInputLength:` - Initializes the input view with a specified length.
2. `boxInputWithLength:` - Creates a new input view with a specified length.

### Basic Example

```objective-c
#import "BRCBoxInputView.h"

// Create an input view with a specified length
BRCBoxInputView *inputView = [[BRCBoxInputView alloc] initWithInputLength:6];

// Customize appearance
inputView.autocapitalizationType = UITextAutocapitalizationTypeWords;
inputView.autocorrectionType = UITextAutocorrectionTypeNo;
inputView.keyboardType = UIKeyboardTypeNumberPad;
inputView.placeHolder = @"Enter Code";

// Set caret properties
inputView.showCaret = YES;
inputView.caretWidth = 2.0;
inputView.caretMaxOpacity = 1.0;

// Set box style properties
inputView.boxSpace = 8.0;
inputView.selectTransitionDuration = 0.25;
inputView.alignment = BRCBoxAlignmentCenter;

// Show the input view
[inputView toggleFirstResponder];
```

## Installation

BRCBoxInputView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BRCBoxInputView', '~> 1.0'
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
