//
//  ViewController.m
//  BRCBoxInputView_OC
//
//  Created by sunzhixiong on 2024/8/5.
//
#import "BRCMainTestViewController.h"
#import <BRCBoxInputView/BRCBoxInputView.h>
#import <BRCFastTest/UIImageView+WebCache.h>
#import <BRCFastTest/UIView+YYAdd.h>
#import <BRCFastTest/Masonry.h>
#import <BRCFastTest/UIScrollView+YYAdd.h>
#import <BRCFastTest/UIBarButtonItem+YYAdd.h>
#import <BRCFastTest/NSString+YYAdd.h>
#import <BRCFastTest/YYCGUtilities.h>
#import <BRCFastTest/UIColor+BRCFastTest.h>
#import <BRCFastTest/YYKitMacro.h>
#import <FLEX/FLEXMacros.h>
#import "LOTAnimationView.h"
#import "BRCToast.h"

#define kSafeAreaBottomSpcing [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom
 
#define kStatusAndNavigationBarHeight 100

@interface BRCMainTestViewController () 
<BRCBoxInputViewDelegate,UITextInputDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) NSString *inputpattern;
@property (nonatomic, assign) BOOL showCaret;
@property (nonatomic, assign) NSTimeInterval blinkDuration;

@property (nonatomic, assign) UIMenuControllerArrowDirection menuDirection;
@property (nonatomic, assign) BRCBoxAlignment alignment;

@property (nonatomic, assign) CGFloat caretWidth;
@property (nonatomic, assign) CGFloat caretHeight;
@property (nonatomic, assign) CGFloat caretMaxOpacity;
@property (nonatomic, assign) CGFloat caretMinOpacity;
@property (nonatomic, assign) CGFloat boxSpace;
@property (nonatomic, assign) CGFloat boxWidth;
@property (nonatomic, assign) CGFloat boxHeight;
@property (nonatomic, assign) NSInteger inputMaxLength;

@property (nonatomic, assign) UIKeyboardType keyBoardType;

@property (nonatomic, assign) BOOL secureTextEntry;
@property (nonatomic, assign) BOOL isRTL;
@property (nonatomic, assign) BOOL autoDismissKeyBoardWhenFinishInput;
@property (nonatomic, assign) BOOL autoFillBoxContainer;

@end

@implementation BRCMainTestViewController

- (void)viewDidLoad {
    self.isNavigationBarChangeAlphaWhenScrolled = YES;
    self.isAutoHandlerKeyBoard = YES;
    [super viewDidLoad];
    self.title = [self componentTitle];
}

- (void)setUpViews {
    [super setUpViews];
    [self addTestInputView];
}

- (void)addTestInputView {
    self.showCaret = YES;
    self.autoFillBoxContainer = YES;
    self.autoDismissKeyBoardWhenFinishInput = YES;
    self.blinkDuration = 0.5;
    self.caretMaxOpacity = 1.0;
    self.caretMinOpacity = 0.2;
    self.caretWidth = 1;
    self.caretHeight = 10;
    self.boxWidth = 60;
    self.boxHeight = 60;
    self.boxSpace = 5;
    self.inputMaxLength = 5;
    self.alignment = BRCBoxAlignmentLeft;
    self.isRTL = NO;
    self.keyBoardType = UIKeyboardTypeNumberPad;
    self.secureTextEntry = NO;
    weakify(self);
    [self addEnumControlWithItems:@[
        @"NO",
        @"YES"
    ] withTitle:@"secureTextEntry" chageBlock:^(UISegmentedControl * _Nonnull control) {
        strongify(self);
        self.secureTextEntry = control.selectedSegmentIndex;
        [self updateBoxInputView];
    }];
    [self addEnumControlWithItems:@[@"YES",@"NO"] withTitle:@"autoFillBoxContainer" chageBlock:^(UISegmentedControl * _Nonnull control) {
        strongify(self);
        self.autoFillBoxContainer = 1 - control.selectedSegmentIndex;
        [self updateBoxInputView];
    }];
    [self addEnumControlWithItems:@[@"YES",@"NO"] withTitle:@"autoDismissKeyBoardWhenFinishInput" chageBlock:^(UISegmentedControl * _Nonnull control) {
        strongify(self);
        self.autoDismissKeyBoardWhenFinishInput = 1- control.selectedSegmentIndex;
        [self updateBoxInputView];
    }];
    [self addEnumControlWithItems:@[
        @"Left",
        @"Right",
        @"Center"
    ] withTitle:@"alignment" chageBlock:^(UISegmentedControl * _Nonnull control) {
        strongify(self);
        self.alignment = control.selectedSegmentIndex;
        [self updateBoxInputView];
    }];
    [self addEnumControlWithItems:@[
        @"Default",
        @"Up",
        @"Down",
        @"Left",
        @"Right"
    ] withTitle:@"menuDirection" chageBlock:^(UISegmentedControl * _Nonnull control) {
        strongify(self);
        self.menuDirection = control.selectedSegmentIndex;
        [self updateBoxInputView];
    }];
    [self addEnumControlWithItems:@[
        @"Number",
        @"Normal"
    ] withTitle:@"keyBoardType" chageBlock:^(UISegmentedControl * _Nonnull control) {
        strongify(self);
        if (control.selectedSegmentIndex == 0) {
            self.keyBoardType = UIKeyboardTypeNumberPad;
        } else {
            self.keyBoardType = UIKeyboardTypeDefault;
        }
        [self updateBoxInputView];
    }];
    [self addEnumControlWithItems:@[
        @"None",
        @"Only Number",
        @"Only Letter"
    ] withTitle:@"inputpattern" chageBlock:^(UISegmentedControl * _Nonnull control) {
        strongify(self);
        if (control.selectedSegmentIndex == 0) {
            self.inputpattern = nil;
        } else if (control.selectedSegmentIndex == 1) {
            self.inputpattern = @"^[0-9]+$";
        } else {
            self.inputpattern = @"^[a-zA-Z]+$";
        }
        [self updateBoxInputView];
    }];
    [self addEnumControlWithItems:@[@"NO",@"YES"] withTitle:@"showCaret" chageBlock:^(UISegmentedControl * _Nonnull control) {
        strongify(self);
        self.showCaret = control.selectedSegmentIndex;
        [self updateBoxInputView];
    }];
    [self addEnumControlWithItems:@[@"NO",@"YES"] withTitle:@"isRTL" chageBlock:^(UISegmentedControl * _Nonnull control) {
        strongify(self);
        self.isRTL = control.selectedSegmentIndex;
        [self updateBoxInputView];
    }];
    [self addEnumControlWithItems:@[@"YES",@"NO"] withTitle:@"showCaret" chageBlock:^(UISegmentedControl * _Nonnull control) {
        strongify(self);
        self.showCaret = 1 - control.selectedSegmentIndex;
        [self updateBoxInputView];
    }];
    [self addSliderControlWithTitle:@"inputMaxLength" desc:@"key.component.test.box.inputlength" valueArray:@[@(1),@(100)] chageBlock:^(UISlider * _Nonnull control) {
        strongify(self);
        self.inputMaxLength = control.value;
        [self updateBoxInputView];
    }];
    [self addSliderControlWithTitle:@"boxSpace" desc:@"key.component.test.box.space" valueArray:@[@(1),@(100)] chageBlock:^(UISlider * _Nonnull control) {
        strongify(self);
        self.boxSpace = ceil(control.value);
        [self updateBoxInputView];
    }];
    [self addSliderControlWithTitle:@"boxWidth" desc:@"key.component.test.box.width" valueArray:@[@(1),@(100)] chageBlock:^(UISlider * _Nonnull control) {
        strongify(self);
        self.boxWidth = ceil(control.value);
        [self updateBoxInputView];
    }];
    [self addSliderControlWithTitle:@"boxHeight" desc:@"key.component.test.box.height" valueArray:@[@(1),@(100)] chageBlock:^(UISlider * _Nonnull control) {
        strongify(self);
        self.boxHeight = ceil(control.value);
        [self updateBoxInputView];
    }];
    [self addSliderControlWithTitle:@"blinkDuration" desc:@"key.component.test.caret.blinkduration" valueArray:@[@(0),@(1)] chageBlock:^(UISlider * _Nonnull control) {
        strongify(self);
        self.blinkDuration = control.value;
        [self updateBoxInputView];
    }];
    [self addSliderControlWithTitle:@"caretMinOpacity" desc:@"key.component.test.caret.minopacity" valueArray:@[@(0),@(1)] chageBlock:^(UISlider * _Nonnull control) {
        strongify(self);
        self.caretMinOpacity = control.value;
        [self updateBoxInputView];
    }];
    [self addSliderControlWithTitle:@"caretMaxOpacity" desc:@"key.component.test.caret.maxopacity" valueArray:@[@(0),@(1)] chageBlock:^(UISlider * _Nonnull control) {
        strongify(self);
        self.caretMaxOpacity = control.value;
        [self updateBoxInputView];
    }];
    [self addSliderControlWithTitle:@"caretWidth" desc:@"key.component.test.caret.width" valueArray:@[@(0),@(3)] chageBlock:^(UISlider * _Nonnull control) {
        strongify(self);
        self.caretWidth = ceil(control.value);
        [self updateBoxInputView];
    }];
    [self addSliderControlWithTitle:@"caretHeight" desc:@"key.component.test.caret.height" valueArray:@[@(1),@(100)] chageBlock:^(UISlider * _Nonnull control) {
        strongify(self);
        self.caretHeight = ceil(control.value);
        [self updateBoxInputView];
    }];
    BRCBoxInputView *view = [[BRCBoxInputView alloc] initWithInputLength:self.inputMaxLength];
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
    [view setBoxStyle:style];
    [view setSelectedBoxStyle:selectedStyle];
    view.tag = 100;
    view.inputDelegate = self;
    view.delegate = self;
    [self addTestView:view withTitle:@"key.component.test.example" height:80 isFitWidth:NO];
}

- (void)updateBoxInputView {
    BRCBoxInputView *view = [self.view viewWithTag:100];
    if ([view isKindOfClass:[BRCBoxInputView class]]) {
        view.caretHeight = self.caretHeight;
        view.caretWidth = self.caretWidth;
        view.caretMaxOpacity = self.caretMaxOpacity;
        view.caretMinOpacity = self.caretMinOpacity;
        view.boxSpace = self.boxSpace;
        view.boxSize = CGSizeMake(self.boxWidth, self.boxHeight);
        view.inputMaxLength = self.inputMaxLength;
        view.showCaret = self.showCaret;
        view.blinkDuration = self.blinkDuration;
        view.autoDismissKeyBoardWhenFinishInput = self.autoDismissKeyBoardWhenFinishInput;
        view.autoFillBoxContainer = self.autoFillBoxContainer;
        view.alignment = self.alignment;
        view.returnKeyType = UIReturnKeyDone;
        view.keyboardType = self.keyBoardType;
        view.menuDirection = self.menuDirection;
        view.inputPattern = self.inputpattern;
        view.secureTextEntry = self.secureTextEntry;
        if (self.isRTL) {
            view.transform = CGAffineTransformMakeScale(-1, 1);
        } else {
            view.transform = CGAffineTransformIdentity;
        }
        
        [view reloadView];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - BRCBoxInputViewDelegate

- (void)pasteText:(NSString *)text inInputView:(nonnull BRCBoxInputView *)inputView{
    [BRCToast show:@"key.paste.text.success"];
}

- (void)copyText:(NSString *)text inInputView:(nonnull BRCBoxInputView *)inputView{
    [BRCToast show:@"key.copy.text.success"];
}

- (void)deleteText:(NSString *)text inInputView:(nonnull BRCBoxInputView *)inputView{
    [BRCToast show:@"key.delete.text.success"];
}

- (void)cutText:(NSString *)text inInputView:(nonnull BRCBoxInputView *)inputView{
    [BRCToast show:@"key.cut.text.success"];
}

- (void)textWillChange:(BRCBoxInputView *)textInput {
    NSLog(@"textWillChange");
}

- (void)textDidChange:(BRCBoxInputView *)textInput {
    UILabel *label = [self.view viewWithTag:992];
    label.text = textInput.text;
}

- (void)didUnSelectInputBox:(BRCBoxView *)boxView withIndex:(NSInteger)index inInputView:(BRCBoxInputView *)inputView {
    if (inputView.tag == 100) {
        boxView.secretImageView.image = nil;
        [boxView.secretImageView sd_setImageWithURL:[NSURL URLWithString:@"https://ak-d.tripcdn.com/images/0AS6b1200090fx7s7F635.png"]];
    }
}

- (void)didSelectInputBox:(BRCBoxView *)boxView withIndex:(NSInteger)index inInputView:(BRCBoxInputView *)inputView {
    if (inputView.tag == 100) {
        boxView.secretImageView.image = nil;
        [boxView.secretImageView sd_setImageWithURL:[NSURL URLWithString:@"https://ak-d.tripcdn.com/images/0AS5f120008whj34f2145.png"]];
    }
}

- (void)didBecomeFirstResponderWithView:(BRCBoxInputView *)inputView {
    [self scrollToFirstResponder];
}

- (BOOL)boxInputViewShouldReturn:(BRCBoxInputView *)inputView {
    return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    [[UIMenuController sharedMenuController] hideMenu];
}


#pragma mark - debug

- (NSString *)componentTitle {
    return @"BRCBoxInputView";
}

- (NSString *)componentDescription {
    return @"key.component.description";
}

- (NSArray *)componentFunctions {
    return @[
        @"key.component.functions.01",
        @"key.component.functions.02",
        @"key.component.functions.03",
        @"key.component.functions.04"
    ];
}

- (CGFloat)leftPadding {
    return 15;
}


@end
