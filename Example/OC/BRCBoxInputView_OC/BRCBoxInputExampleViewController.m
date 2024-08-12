//
//  BRCBoxInputExampleViewController.m
//  BRCBoxInputView_OC
//
//  Created by sunzhixiong on 2024/8/8.
//

#import "BRCBoxInputExampleViewController.h"
#import "BRCLineBoxView.h"
#import "BRCGiftBoxView.h"
#import <BRCBoxInputView/BRCBoxInputView.h>
#import <BRCFastTest/UIColor+BRCFastTest.h>

@interface BRCBoxInputExampleViewController ()
<BRCBoxInputViewDelegate>

@end

@implementation BRCBoxInputExampleViewController

- (void)setUpViews {
    [super setUpViews];
    [self addTestView];
}

- (void)addTestView {
    BRCBoxStyle *style = [BRCBoxStyle defaultStyle];
    style.boxBorderColor = [UIColor brtest_black];
    style.textAttributedDict = @{
        NSForegroundColorAttributeName : [UIColor brtest_black],
        NSFontAttributeName : [UIFont boldSystemFontOfSize:14.0]
    };
    BRCBoxStyle *selectedStyle = [BRCBoxStyle defaultSelectedStyle];
    selectedStyle.boxBorderColor = [UIColor brtest_red];
    selectedStyle.textAttributedDict = @{
        NSForegroundColorAttributeName : [UIColor brtest_black],
        NSFontAttributeName : [UIFont boldSystemFontOfSize:14.0]
    };
    BRCBoxInputView *inputView1 = [[BRCBoxInputView alloc] initWithInputLength:5];
    inputView1.boxStyle = style;
    inputView1.selectedBoxStyle = selectedStyle;
    inputView1.alignment = BRCBoxAlignmentCenter;
    inputView1.keyboardType = UIKeyboardTypeNumberPad;
    inputView1.textContentType = UITextContentTypeOneTimeCode;
    inputView1.placeHolder = @"你好我是超级英雄";
    [self addTestView:inputView1 withTitle:@"key.component.test.style.00" height:80];
    
    BRCBoxInputView *inputView2 = [[BRCBoxInputView alloc] initWithInputLength:15];
    inputView2.selectedBoxStyle.textAttributedDict = selectedStyle.textAttributedDict;
    inputView2.boxStyle.textAttributedDict = style.textAttributedDict;
    inputView2.selectedBoxStyle.boxBorderWidth = 0;
    inputView2.boxStyle.boxBorderWidth = 0;
    inputView2.keyboardType = UIKeyboardTypeDefault;
    inputView2.boxViewClass = [BRCLineBoxView class];
    [self addTestView:inputView2 withTitle:@"key.component.test.style.01" height:80];
    
    BRCBoxInputView *inputView3 = [[BRCBoxInputView alloc] initWithInputLength:15];
    inputView3.boxStyle = style;
    inputView3.selectedBoxStyle = selectedStyle;
    inputView3.tag = 100;
    inputView3.keyboardType = UIKeyboardTypeDefault;
    inputView3.boxViewClass = [BRCGiftBoxView class];
    inputView3.showCaret = NO;
    inputView3.delegate = self;
    [self addTestView:inputView3 withTitle:@"key.component.test.style.02" height:80];
}

#pragma mark - BRCBoxInputViewDelegate

- (void)didSelectInputBox:(BRCGiftBoxView *)boxView withIndex:(NSInteger)index inInputView:(BRCBoxInputView *)inputView {
    if (inputView.tag == 100) {
        boxView.animationView.hidden = NO;
        [boxView.animationView setAnimationNamed:@"gift"];
        [boxView.animationView play];
    }
}

- (void)didUnSelectInputBox:(BRCGiftBoxView *)boxView withIndex:(NSInteger)index inInputView:(BRCBoxInputView *)inputView {
    if (inputView.tag == 100) {
        if (index == inputView.currentInputIndex - 1) {
            boxView.animationView.hidden = NO;
            [boxView.animationView setAnimationNamed:@"celebrateCeneter"];
            [boxView.animationView play];
        } else {
            boxView.animationView.hidden = YES;
            [boxView.animationView stop];
        }
    }
}

- (void)addTestView:(UIView *)testView withTitle:(NSString *)title height:(CGFloat)height{
    [self addLabelWithText:title withTopSpace:10];
    [self addSubView:testView topSpace:10 width:UIScreen.mainScreen.bounds.size.width - [self leftPadding] * 2 height:height isCenter:NO isRight:NO];
}

- (BOOL)isAutoHandlerKeyBoard {
    return YES;
}

@end
