//
//  BRCBoxInputViewTestViewController.m
//  BRCBoxInput
//
//  Created by sunzhixiong on 2024/5/10.
//

#import "BRCVerifyCodeViewTestViewController.h"
#import <BRCBoxInputView/BRCBoxInputView.h>
#import <SDWebImage/SDWebImage.h>
#import <YYKit/UIView+YYAdd.h>
#import <Masonry/Masonry.h>
#import <YYKit/UIScrollView+YYAdd.h>
#import <YYKit/UIBarButtonItem+YYAdd.h>
#import <YYKit/NSString+YYAdd.h>
#import <YYKit/YYCGUtilities.h>
#import "LOTAnimationView.h"
#import "BRCToast.h"

@interface BRCVerifyCodeViewTestViewController () <BRCBoxInputViewDelegate>

@property (nonatomic, assign) CGPoint originOffset;
@property (nonatomic, assign) BOOL isOpenEye;
@property (nonatomic, strong) UIView *lastView;
@property (nonatomic, strong) NSMutableArray<BRCBoxInputView *> *inputArray;

@end

@implementation BRCVerifyCodeViewTestViewController

- (void)setUpViews {
    if ([self.componentTitle isNotBlank]) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 1;
        titleLabel.text = self.componentTitle;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:25.0 weight:UIFontWeightBold];
        [self.view addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.leading.equalTo(self.view);
        }];
        self.lastView = titleLabel;
    }
    if ([self.componentDescription isNotBlank]) {
        UILabel *descriptionLabel = [[UILabel alloc] init];
        descriptionLabel.numberOfLines = 0;
        descriptionLabel.textAlignment = NSTextAlignmentLeft;
        descriptionLabel.text = self.componentDescription;
        descriptionLabel.textColor = [UIColor grayColor];
        descriptionLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
        [self.view addSubview:descriptionLabel];
        [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lastView.mas_bottom).offset(10);
            make.leading.equalTo(self.view);
            make.trailing.equalTo(self.view);
            make.width.equalTo(@(kScreenWidth - self.leftPadding * 2));
        }];
        self.lastView = descriptionLabel;
    }
    if ([self.componentFunctions count] > 0) {
        [self.componentFunctions enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isNotBlank]) {
                UILabel *label = [self createFunctionLabel:[NSString stringWithFormat:@"%ld.%@",idx+1,obj]];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.lastView.mas_bottom).offset(5);
                    make.leading.equalTo(self.view);
                }];
                self.lastView = label;
            }
        }];
    }
    
    _isOpenEye = YES;
    _inputArray = [NSMutableArray array];
    [self setNavBar];
    // Do any additional setup after loading the view.
    BRCBoxInputView *view = [[BRCBoxInputView alloc] initWithInputLength:5];
    [_inputArray addObject:view];
    [self addTestView:view withTitle:@"1.示例1" height:80 isFitWidth:NO];
    
    BRCBoxInputView *view2 = [[BRCBoxInputView alloc] initWithInputLength:5];
    view2.placeHolder = @"你很棒";
    [_inputArray addObject:view2];
    [self addTestView:view2 withTitle:@"2.带有占位符" height:80 isFitWidth:NO];
    

    BRCBoxInputView *view3 = [[BRCBoxInputView alloc] initWithInputLength:8];
    view3.autoDismissKeyBoardWhenFinishInput = YES;
    view3.autoFillBoxContainer = NO;
    view3.secureTextEntry = YES;
    [_inputArray addObject:view3];
    [self addTestView:view3 withTitle:@"3.加密输入" height:80 isFitWidth:NO];
    
    BRCBoxInputView *view4 = [[BRCBoxInputView alloc] initWithInputLength:8];
    view4.placeHolder = @"你很棒";
    view4.autoFillBoxContainer = NO;
    BRCBoxStyle *style4 = [BRCBoxStyle lineBoxStyle];
    BRCBoxStyle *selectStyle4 = [BRCBoxStyle selectLineBoxStyle];
    [view4 setBoxStyle:style4];
    [view4 setSelectBoxStyle:selectStyle4];
    [_inputArray addObject:view4];
    [self addTestView:view4 withTitle:@"4.自定义视图" height:80 isFitWidth:NO];
    
    BRCBoxInputView *view4_2 = [[BRCBoxInputView alloc] initWithInputLength:5];
    view4_2.alignment =  BRCBoxAlignmentRight;
    view4_2.showCaret = NO;
    view4_2.autoDismissKeyBoardWhenFinishInput = YES;
    view4_2.autoFillBoxContainer = NO;
    BRCBoxStyle *style4_2 = [BRCBoxStyle defaultStyle];
    style4_2.boxSize = CGSizeMake(60, 60);
    style4_2.customView = ^UIView * _Nonnull(BRCBoxView * _Nonnull boxView) {
        LOTAnimationView *animationView = [LOTAnimationView animationNamed:@"celebrateCeneter"];
        animationView.tag = 100;
        animationView.alpha = 0;
        animationView.contentMode = UIViewContentModeScaleAspectFit;
        animationView.frame = boxView.bounds;
        animationView.loopAnimation = NO;
        return animationView;
    };
    [view4_2 setBoxStyle:style4_2];
    
    BRCBoxStyle *selectStyle4_2 = [BRCBoxStyle defaultSelectStyle];
    selectStyle4_2.customView = ^UIView * _Nonnull(BRCBoxView * _Nonnull boxView) {
        LOTAnimationView *animationView = [LOTAnimationView animationNamed:@"gift"];
        animationView.tag = 208;
        animationView.alpha = 0;
        animationView.contentMode = UIViewContentModeScaleAspectFit;
        animationView.frame = boxView.bounds;
        animationView.loopAnimation = YES;
        animationView.autoReverseAnimation = YES;
        return animationView;
    };
    selectStyle4_2.boxSize = CGSizeMake(60, 60);
    view4_2.inputDelegate = self;
    [view4_2 setSelectBoxStyle:selectStyle4_2];
    [_inputArray addObject:view4_2];
    [self addTestView:view4_2 withTitle:@"5.带回调事件" height:80 isFitWidth:NO];
    
    UILabel *label = [[UILabel alloc] init];
    label.tag = 992;
    label.text = @"输入文本";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view);
        make.bottom.equalTo(view4_2.mas_top).offset(-5);
    }];
    
    BRCBoxInputView *view5 = [[BRCBoxInputView alloc] initWithInputLength:6];
    BRCBoxStyle *style = [BRCBoxStyle defaultStyle];
    style.borderWidth = 0;
    style.backgroundColor = [UIColor blueColor];
    style.labelColor = [UIColor whiteColor];
    style.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    style.shadowOffset = CGSizeMake(0, 10);
    style.shadowRadius = 10.0;
    style.secretView = ^UIView * _Nonnull{
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = 100;
        [imageView sd_setImageWithURL:[NSURL URLWithString:@"https://ak-d.tripcdn.com/images/0AS6b1200090fx7s7F635.png"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        return imageView;
    };
    BRCBoxStyle *selectStyle = [BRCBoxStyle defaultSelectStyle];
    selectStyle.backgroundColor = [UIColor whiteColor];
    selectStyle.secretView = ^UIView * _Nonnull{
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = 101;
        [imageView sd_setImageWithURL:[NSURL URLWithString:@"https://ak-d.tripcdn.com/images/0AS5f120008whj34f2145.png"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        return imageView;
    };
    [view5 setBoxStyle:style];
    [view5 setSelectBoxStyle:selectStyle];
    [_inputArray addObject:view5];
    [self addTestView:view5 withTitle:@"6.自定义加密输入" height:80 isFitWidth:NO];
    
    BRCBoxInputView *view6 = [[BRCBoxInputView alloc] initWithInputLength:5];
    view6.keyboardType = UIKeyboardTypeDefault;
    view6.textContentType = nil;
    [_inputArray addObject:view6];
    [self addTestView:view6 withTitle:@"7.自定义键盘输入" height:80 isFitWidth:NO];
    
    BRCBoxInputView *view7 = [[BRCBoxInputView alloc] initWithInputLength:5];
    view7.autoFillBoxContainer = NO;
    view7.isRTL = YES;
    view7.alignment = BRCBoxAlignmentLeft;
    [_inputArray addObject:view7];
    [self addTestView:view7 withTitle:@"8.适配阿拉伯样式" height:80 isFitWidth:NO];
}

- (void)setNavBar {
    UIImage *image = [UIImage systemImageNamed:_isOpenEye ? @"eye" : @"eye.slash"];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(handleOpenEye)];
    buttonItem.tintColor = [UIColor blackColor];
    [self.navigationItem setRightBarButtonItem:buttonItem animated:YES];
}

- (void)handleOpenEye {
    _isOpenEye = !_isOpenEye;
    [self.inputArray enumerateObjectsUsingBlock:^(BRCBoxInputView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.secureTextEntry = !_isOpenEye;
    }];
    [self setNavBar];
}

#pragma mark - BRCBoxInputViewDelegate

- (void)pasteText:(NSString *)text inputView:(nonnull BRCBoxInputView *)inputView{
    [BRCToast show:@"粘贴成功"];
}

- (void)copyText:(NSString *)text inputView:(nonnull BRCBoxInputView *)inputView{
    [BRCToast show:@"粘贴成功"];
}

- (void)deleteText:(NSString *)text inputView:(nonnull BRCBoxInputView *)inputView{
    [BRCToast show:@"删除成功"];
}

- (void)cutText:(NSString *)text inputView:(nonnull BRCBoxInputView *)inputView{
    [BRCToast show:@"剪切成功"];
}

- (void)textWillChange:(BRCBoxInputView *)textInput {
//    [BRCToast show:@"文本即将改变"];
}

- (void)textDidChange:(BRCBoxInputView *)textInput {
//    [BRCToast show:@"文本已经改变"];
    UILabel *label = [self.view viewWithTag:992];
    label.text = textInput.inputText;
}

- (void)unSelectInputBox:(BRCBoxView *)boxView withIndex:(NSInteger)index inputView:(nonnull BRCBoxInputView *)inputView{
    LOTAnimationView *animationView = [boxView viewWithTag:100];
    if ([animationView isKindOfClass:[LOTAnimationView class]] && inputView.inputText.length >= index + 1) {
        animationView.animationProgress = 0;
        animationView.alpha = 1;
        [animationView play];
        NSLog(@"animationViewPlay = %@",@(index));
    }
}

- (void)selectInputBox:(BRCBoxView *)boxView withIndex:(NSInteger)index inputView:(nonnull BRCBoxInputView *)inputView{
    LOTAnimationView *animationView = [boxView viewWithTag:208];
    if ([animationView isKindOfClass:[LOTAnimationView class]] && inputView.currentInputIndex == index) {
        animationView.alpha = 1;
        [animationView play];
        NSLog(@"animationViewPlay = %@",@(index));
    }
}

#pragma mark - debug

- (NSString *)componentTitle {
    return @"BRCBoxInputView";
}

- (NSString *)componentDescription {
    return @"一个易用的验证码输入组件";
}

- (NSArray *)componentFunctions {
    return @[
        @"基于 UIKeyInput 协议",
        @"支持占位符、阴影等多种样式",
        @"支持自定义加密输入",
        @"支持复制、粘贴、删除、拷贝的功能",
        @"支持阿拉伯布局"
    ];
}

- (BOOL)autoKeyBoardDismiss {
    return YES;
}

- (void)loadView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentInset = UIEdgeInsetsMake(0, self.leftPadding,80, -self.leftPadding);
    [scrollView setAlwaysBounceVertical:YES];
    self.view = scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];
    [self.lastView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.lessThanOrEqualTo(self.view);
    }];
}


- (void)addTestView:(UIView *)testView
          withTitle:(NSString *)title
             height:(CGFloat)height
         isFitWidth:(BOOL)isFitWidth{
    [self addTestView:testView withTitle:title height:height isFitWidth:isFitWidth space:10];
}

- (void)addTestView:(UIView *)testView
          withTitle:(NSString *)title
             height:(CGFloat)height
              width:(CGFloat)width
              space:(CGFloat)space {
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    [self addSubView:label space:space height:0];
    [self addSubView:testView space:10 height:height width:width];
}

- (void)addTestView:(UIView *)testView
          withTitle:(NSString *)title
             height:(CGFloat)height
         isFitWidth:(BOOL)isFitWidth
              space:(CGFloat)space {
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    [self addSubView:label space:space height:0];
    if (testView) {
        [self addSubView:testView space:10 height:height isFitWidth:isFitWidth];
    }
}

- (void)addSubView:(UIView *)view space:(CGFloat)space height:(CGFloat)height {
    [self addSubView:view space:space height:height isFitWidth:NO];
}

- (void)addSubView:(UIView *)view
             space:(CGFloat)space
            height:(CGFloat)height
             width:(CGFloat)width {
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.lastView) {
            make.top.equalTo(self.lastView.mas_bottom).offset(space);
        } else {
            make.top.equalTo(self.view).offset(space);
        }
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(width));
        if (height != 0) {
            make.height.equalTo(@(height));
        }
    }];
    self.lastView = view;
}

- (void)addSubView:(UIView *)view
             space:(CGFloat)space
            height:(CGFloat)height
        isFitWidth:(BOOL)isFitWidth{
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.lastView) {
            make.top.equalTo(self.lastView.mas_bottom).offset(space);
        } else {
            make.top.equalTo(self.view).offset(space);
        }
        make.leading.equalTo(self.view);
        if (!isFitWidth) {
            make.trailing.equalTo(self.view);
        }
        if (height != 0) {
            make.height.equalTo(@(height));
        }
    }];
    self.lastView = view;
}

- (UILabel *)createFunctionLabel:(NSString *)text {
    UILabel *functionLabel = [[UILabel alloc] init];
    functionLabel.numberOfLines = 1;
    functionLabel.text = text;
    functionLabel.textColor = [UIColor systemGray2Color];
    functionLabel.font = [UIFont systemFontOfSize:16.0];
    [self.view addSubview:functionLabel];
    return functionLabel;
}

- (CGFloat)leftPadding {
    return 15;
}

@end
