//
//  BRCBoxInputView.m
//  BRCBoxInputView
//
//  Created by sunzhixiong on 2023/12/2.
//

#import "BRCBoxInputView.h"
#import <objc/message.h>

static NSString *const kBRCBoxCollectionViewCellID = @"BRCBoxCollectionViewCellID";
static NSString *const kBRCCustomBoxCollectionViewCellID = @"BRCCustomBoxCollectionViewCellID";

NSArray<NSLayoutConstraint *> *createEdgeConstraints(UIView *view, UIView *containerView) {
    NSLayoutConstraint *leadingConstraint = [view.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor];
    NSLayoutConstraint *trailingConstraint = [view.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor];
    NSLayoutConstraint *topConstraint = [view.topAnchor constraintEqualToAnchor:containerView.topAnchor];
    NSLayoutConstraint *bottomConstraint = [view.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor];
    return @[leadingConstraint, trailingConstraint, topConstraint, bottomConstraint];
}

#define NoWarningPerformSelector(Stuff) \
do { \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
    Stuff; \
    _Pragma("clang diagnostic pop") \
} while (0);

@interface BRCTextPosition : UITextPosition<NSCopying>
@property (nonatomic, assign, readonly) NSInteger offset;
- (instancetype)initWithOffset:(NSInteger)offset;
@end

@implementation BRCTextPosition
- (instancetype)initWithOffset:(NSInteger)offset {
    self = [super init];
    if (self) { _offset = MAX(0, offset); }
    return self;
}
- (id)copyWithZone:(NSZone *)zone { return [[BRCTextPosition alloc] initWithOffset:self.offset];}
@end

@interface BRCTextRange : UITextRange<NSCopying>
@property (nonatomic, readonly) BRCTextPosition *start;
@property (nonatomic, readonly) BRCTextPosition *end;
@end

@interface BRCTextRange() {BRCTextPosition *_start,*_end;}
@end

@implementation BRCTextRange
- (instancetype)initWithStartPosition:(BRCTextPosition *)start
                          endPosition:(BRCTextPosition *)end {
    self = [super init];
    if (self) { _start = start; _end = end;}
    return self;
}
- (BRCTextPosition *)start { return _start;}
- (BRCTextPosition *)end { return _end;}
- (id)copyWithZone:(NSZone *)zone { return [[BRCTextRange alloc] initWithStartPosition:self.start endPosition:self.end]; }
@end


@protocol BRCBoxFlowLayoutDelegate <NSObject>
- (CGSize)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
   sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface BRCBoxFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *cache;
@property (nonatomic, weak)   id<BRCBoxFlowLayoutDelegate> delegate;
@end

@implementation BRCBoxFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _contentWidth = 0;
        _cache = [NSMutableArray array];
    }
    return self;
}

- (void)prepareLayout {
    [self.cache removeAllObjects];
    self.contentWidth = 0;
    if ([self.collectionView numberOfSections] == 0) return;
    CGFloat offsetX = 0;
    for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:0]; item++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        if ([self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
           CGSize size = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
            self.contentWidth += size.width + self.minimumInteritemSpacing;
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = CGRectMake(offsetX, (self.collectionView.frame.size.height - size.height) / 2 , size.width, size.height);
            offsetX += size.width + self.minimumInteritemSpacing;
            [self.cache addObject:attributes];
        }
    }
}

- (CGSize)collectionViewContentSize { return CGSizeMake(self.contentWidth, self.collectionView.frame.size.height); }

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<UICollectionViewLayoutAttributes *> *layoutAttributes = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attributes in self.cache) {
        if (CGRectIntersectsRect(attributes.frame, rect)) { [layoutAttributes addObject:attributes];}
    }
    return layoutAttributes;
}

@end

@implementation BRCBoxStyle

+ (instancetype)defaultStyle {
    BRCBoxStyle *style = [BRCBoxStyle new];
    style.boxSize = CGSizeMake(60, 60);
    style.boxCornerRadius = 4;
    style.boxBorderWidth = 1.0;
    style.boxBorderColor = [UIColor blackColor];
    style.boxShadowRadius = 0;
    style.boxShadowOffset = CGSizeZero;
    style.boxBackgroundColor = [UIColor clearColor];
    style.boxShadowColor = [UIColor clearColor];
    style.textFont = [UIFont boldSystemFontOfSize:14.0];
    style.textColor = [UIColor blackColor];
    style.textFont = [UIFont systemFontOfSize:14.0];
    style.placeHolderColor = [UIColor systemGrayColor];
    style.textAttributedDict = @{};
    style.placeHolderAttributedDict = @{};
    style.boxSecretImage = [UIImage systemImageNamed:@"lock.fill"];
    style.boxSecretImageColor = [UIColor blackColor];
    style.boxSecretImageSize = CGSizeZero;
    return style;
}

+ (instancetype)defaultSelectedStyle {
    BRCBoxStyle *style = [BRCBoxStyle defaultStyle];
    style.boxBorderColor = [UIColor systemRedColor];
    return style;
}

- (BOOL)safeEqual:(id)obj1 obj2:(id)obj2 {
    if (obj1 != nil && obj2 != nil) return [obj1 isEqual:obj2];
    return YES;
}

- (BOOL)isEqual:(id)other
{
    if ([other isKindOfClass:[BRCBoxStyle class]]) {
        BRCBoxStyle *otherStyle = (BRCBoxStyle *)other;
        return CGSizeEqualToSize(otherStyle.boxSize, self.boxSize) && CGSizeEqualToSize(otherStyle.boxShadowOffset, self.boxShadowOffset) && CGSizeEqualToSize(otherStyle.boxSecretImageSize, self.boxSecretImageSize) && otherStyle.boxCornerRadius == self.boxCornerRadius && otherStyle.boxBorderWidth == self.boxBorderWidth &&
            otherStyle.boxShadowRadius == self.boxShadowRadius &&
            [self safeEqual:self.textColor obj2:otherStyle.textColor] &&
            [self safeEqual:self.textFont obj2:otherStyle.textFont] &&
            [self safeEqual:self.placeHolderFont obj2:otherStyle.placeHolderFont] &&
            [self safeEqual:self.placeHolderColor obj2:otherStyle.placeHolderColor] &&
            [self safeEqual:self.textAttributedDict obj2:otherStyle.textAttributedDict] &&
            [self safeEqual:self.placeHolderAttributedDict obj2:otherStyle.placeHolderAttributedDict] &&
            [self safeEqual:self.boxBackgroundColor obj2:otherStyle.boxBackgroundColor] &&
            [self safeEqual:self.boxBorderColor obj2:otherStyle.boxBorderColor] &&
            [self safeEqual:self.boxShadowColor obj2:otherStyle.boxShadowColor] &&
            [self safeEqual:self.boxSecretImageColor obj2:otherStyle.boxSecretImageColor] &&
            [self safeEqual:self.boxSecretImage obj2:otherStyle.boxSecretImage];
    }
    return NO;
}

@end

/// v1.2.0 For SwiftUI
@interface BRCCustomBoxView : UICollectionViewCell<BRCBoxViewProtocol>
@property (nonatomic, strong) UIView<BRCBoxViewProtocol> *mainView;
@end

@implementation BRCCustomBoxView

- (void)setMainView:(UIView<BRCBoxViewProtocol> *)mainView {
    if (![self.mainView isEqual:mainView] && [mainView isKindOfClass:[UIView class]]) {
        [self.mainView removeFromSuperview];
        _mainView = mainView;
        [self.contentView addSubview:self.mainView];
        self.mainView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:createEdgeConstraints(self.mainView, self.contentView)];
    }
}

- (BOOL)isNotEmpty { return [self.mainView performSelector:@selector(isNotEmpty)];}
- (BOOL)isBoxSelected { return [self.mainView performSelector:@selector(isBoxSelected)];}
- (void)setSecureTextEntry:(BOOL)secureTextEntry withDuration:(CGFloat)duration delay:(CGFloat)delay  { [self.mainView setSecureTextEntry:secureTextEntry withDuration:duration delay:delay];
}
- (void)didSelectInputBox { [self.mainView didSelectInputBox]; }
- (void)didUnSelectInputBox { [self.mainView didUnSelectInputBox];}
- (void)setBoxText:(NSString *)text { [self.mainView setBoxText:text]; }
- (void)setBoxPlaceHolder:(NSString *)placeHolder { [self.mainView setBoxPlaceHolder:placeHolder]; }
- (void)setBoxStyle:(BRCBoxStyle *)boxStyle { [self.mainView setBoxStyle:boxStyle]; }

@end

@interface BRCBoxView ()
@property (nonatomic, assign) BOOL               secureTextEntry;
@property (nonatomic, assign) NSTimeInterval     secureTransitionDuration;
@property (nonatomic, assign) NSTimeInterval     secureDelay;
@property (nonatomic, strong) BRCBoxStyle        *boxStyle;
@property (nonatomic, strong) NSLayoutConstraint *imageWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *imageHeightConstraint;
@end

@implementation BRCBoxView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _secureDelay = 0.2;
        _secureTransitionDuration = 0.2;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    [self.contentView addSubview:self.boxLabel];
    [self addConstraintsToView:self.boxLabel withConstraints:createEdgeConstraints(self.boxLabel, self.contentView)];
    [self.contentView addSubview:self.secretImageView];
    [self addConstraintsToView:self.secretImageView withConstraints:[self imageViewConstraints]];
}

- (void)addConstraintsToView:(UIView *)view
             withConstraints:(NSArray<__kindof NSLayoutConstraint *> *)constraints {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:constraints];
}

- (NSArray<__kindof NSLayoutConstraint *> *)imageViewConstraints {
    self.imageWidthConstraint = [self.secretImageView.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor multiplier:0.5];
    self.imageHeightConstraint = [self.secretImageView.heightAnchor constraintEqualToAnchor:self.contentView.heightAnchor multiplier:0.5];
    return @[
        [self.secretImageView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
        [self.secretImageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        self.imageWidthConstraint,
        self.imageHeightConstraint,
    ];
}

#pragma mark - BRCBoxViewProtocol

- (void)setBoxText:(NSString *)text {
    _isPlaceHolderText = NO;
    [self updateLabelTextWithText:text];
    [self updateSecureTextEntryIconState];
}

- (void)setBoxPlaceHolder:(NSString *)placeHolder {
    _isPlaceHolderText = YES;
    [self updateLabelTextWithText:placeHolder];
    [self updateSecureTextEntryIconState];
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry withDuration:(CGFloat)duration delay:(CGFloat)delay{
    _secureTransitionDuration = duration;
    _secureDelay = delay;
    _secureTextEntry = secureTextEntry;
    [self updateSecureTextEntryIconState];
}

- (void)setBoxStyle:(BRCBoxStyle *)boxStyle {
    if (boxStyle != nil && _boxStyle != nil && [boxStyle isEqual:_boxStyle]) return;
    _boxStyle = boxStyle;
    if (boxStyle == nil) return;
    self.layer.cornerRadius = boxStyle.boxCornerRadius;
    self.layer.borderWidth = boxStyle.boxBorderWidth;
    self.layer.borderColor = boxStyle.boxBorderColor.CGColor;
    self.layer.shadowColor = boxStyle.boxShadowColor.CGColor;
    self.backgroundColor = boxStyle.boxBackgroundColor;
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = boxStyle.boxShadowRadius;
    self.layer.shadowOffset = boxStyle.boxShadowOffset;
    self.secretImageView.image = boxStyle.boxSecretImage;
    self.secretImageView.tintColor = boxStyle.boxSecretImageColor;
    [self updateLabelTextWithText:self.boxLabel.attributedText.string];
    if (CGSizeEqualToSize(boxStyle.boxSecretImageSize, self.secretImageView.frame.size)) {
        [NSLayoutConstraint deactivateConstraints:@[self.imageHeightConstraint,self.imageWidthConstraint]];
        if (CGSizeEqualToSize(boxStyle.boxSecretImageSize, CGSizeZero)) {
            self.imageWidthConstraint = [self.secretImageView.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor multiplier:0.5];
            self.imageHeightConstraint = [self.secretImageView.heightAnchor constraintEqualToAnchor:self.contentView.heightAnchor multiplier:0.5];
        } else {
            self.imageWidthConstraint = [self.secretImageView.widthAnchor constraintEqualToConstant:boxStyle.boxSecretImageSize.width];
            self.imageHeightConstraint = [self.secretImageView.heightAnchor constraintEqualToConstant:boxStyle.boxSecretImageSize.height];
        }
        [NSLayoutConstraint activateConstraints:@[self.imageHeightConstraint,self.imageWidthConstraint]];
        [self setNeedsLayout];
    }
}

- (void)didSelectInputBox { self.selected = YES; }
- (void)didUnSelectInputBox { self.selected = NO; }

#pragma mark - secureTextEntryState

- (void)updateSecureTextEntryIconState {
    if ([self isNotEmpty] && self.secureTextEntry == YES) {
        [self showSecureTextEntryIcon:YES];
    } else {
        [self hideSecureTextEntryIcon];
    }
}

- (void)showSecureTextEntryIcon:(BOOL)isAnimated {
    [UIView animateWithDuration:isAnimated ? self.secureTransitionDuration : 0 delay:self.secureDelay options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.boxLabel.alpha = 0;
        self.secretImageView.alpha = 1;
    } completion:nil];
}

- (void)hideSecureTextEntryIcon{
    self.boxLabel.alpha = 1;
    self.secretImageView.alpha = 0;
}

- (void)updateLabelTextWithText:(NSString *)text{
    NSDictionary *attributedDict = self.isPlaceHolderText ? self.boxStyle.placeHolderAttributedDict : self.boxStyle.textAttributedDict;
    if (attributedDict.allKeys.count <= 0) {
        attributedDict = @{
            NSFontAttributeName : self.boxStyle.textFont ?: [UIFont systemFontOfSize:13.0],
            NSForegroundColorAttributeName : self.boxStyle.textColor ?: [UIColor blackColor]
        };
    }
    _boxLabel.attributedText = [self getAttributedStr:text withAttributedDict:attributedDict];
}

#pragma mark - getter

- (NSAttributedString *)getAttributedStr:(NSString *)str withAttributedDict:(NSDictionary *)dict{
    return [[NSAttributedString alloc] initWithString:[str isKindOfClass:[NSString class]] ? str : @"" attributes:[dict isKindOfClass:[NSDictionary class]] ? dict : @{}];
}

- (BOOL)isNotEmpty {
    return self.isPlaceHolderText == NO && [self.boxLabel.text isKindOfClass:[NSString class]] && self.boxLabel.text.length > 0;
}

- (BOOL)isBoxSelected { return self.isSelected;}

#pragma mark - props

- (UILabel *)boxLabel {
    if (!_boxLabel) {
        _boxLabel = [UILabel new];
        _boxLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _boxLabel;
}

- (UIImageView *)secretImageView {
    if (!_secretImageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        _secretImageView = imageView;
        _secretImageView.alpha = 0;
    }
    return _secretImageView;
}

#pragma mark - theme

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    if ([self.boxStyle isKindOfClass:[BRCBoxStyle class]]) {
        self.layer.borderColor = self.boxStyle.boxBorderColor.CGColor;
        self.layer.shadowColor = self.boxStyle.boxShadowColor.CGColor;
    }
}

@end

@interface BRCBoxInputView () 
<
UICollectionViewDelegate,
UICollectionViewDataSource,
BRCBoxFlowLayoutDelegate
>
{
    BRCTextRange                            *_selectedTextRange;
    BRCTextRange                            *_markedTextRange;
    UIView                                  *_textInputView;
    NSDictionary<NSAttributedStringKey, id> *_markedTextStyle;
    __weak id<UITextInputDelegate>          _inputDelegate;
    __weak id<UITextInputTokenizer>         _tokenizer;
    BOOL                                    _secureTextEntry;
    UIKeyboardType                          _keyboardType;
    UIReturnKeyType                         _returnKeyType;
    UITextContentType                       _textContentType;
};

@property (nonatomic, copy)   dispatch_block_t  workBlock;
@property (nonatomic, strong) NSString          *inputText;
@property (nonatomic, strong) UIView            *caretView;
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) BRCBoxFlowLayout  *flowLayout;
@property (nonatomic, strong) NSMutableArray    *activeConstraints;
@property (nonatomic, assign) CGFloat           autoFillContainerBoxWidth;
@property (nonatomic, assign) NSUInteger        currentSelectIndex;
@property (nonatomic, strong, readonly) UIPasteboard     *pasteboard;
@property (nonatomic, assign, readonly) BRCBoxAlignment  boxAlignment;
@property (nonatomic, assign, readonly) BOOL             isMenuActionsVaild;
@property (nonatomic, assign, readonly) CGFloat          collectionViewContainerWidth;
@property (nonatomic, assign, readonly) UICollectionViewScrollPosition scrollPosition;

@end

@implementation BRCBoxInputView

@synthesize selectedTextRange = _selectedTextRange;
@synthesize markedTextRange = _markedTextRange;
@synthesize markedTextStyle = _markedTextStyle;
@synthesize inputDelegate = _inputDelegate;
@synthesize tokenizer = _tokenizer;
@synthesize textInputView = _textInputView;
@synthesize secureTextEntry = _secureTextEntry;
@synthesize textContentType = _textContentType;
@synthesize keyboardType = _keyboardType;
@synthesize returnKeyType = _returnKeyType;

#pragma mark - init

- (instancetype)init{
    self = [super init];
    if (self) { _inputMaxLength = 5; [self setUpViews];}
    return self;
}

+ (instancetype)boxInputWithLength:(NSUInteger)length {
    return [[BRCBoxInputView alloc] initWithInputLength:length];
}

- (instancetype)initWithInputLength:(NSUInteger)length {
    self = [super init];
    if (self) { _inputMaxLength = length;[self setUpViews];}
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIApplicationWillEnterForegroundNotification];
}

- (void)setUpViews {
    [self commonInit];
    [self initSubViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppWillEnterForegroundNot:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)commonInit {
    _onFinishInput = nil;
    _focusScrollPosition = BRCBoxFocusScrollPositionCenter;
    _boxViewClass = [BRCBoxView class];
    _menuDirection = UIMenuControllerArrowDown;
    _contentInsets = UIEdgeInsetsZero;
    _autoFillContainerBoxWidth = -1;
    _autoFillBoxContainer = NO;
    _boxSpace = 10;
    _boxStyle = [BRCBoxStyle defaultStyle];
    _selectedBoxStyle = [BRCBoxStyle defaultSelectedStyle];
    _caretTintColor = [UIColor systemPinkColor];
    __weak __typeof__(self) weakSelf = self;
    _onClickInputViewBlock = ^{
        [weakSelf hideMenu];
        [weakSelf toggleFirstResponder];
    };
    _alignment = BRCBoxAlignmentCenter;
    _placeHolder = nil;
    _selectedTextRange = nil;
    _markedTextRange = nil;
    _markedTextStyle = nil;
    _autoDismissKeyBoardWhenFinishInput = NO;
    _secureTextEntry = NO;
    _secureTransitionDuration = 0.2;
    _secureDelayDuration = 0.2;
    _keyboardType = UIKeyboardTypeNumberPad;
    _textContentType = UITextContentTypeOneTimeCode;
    _showCaret = YES;
    _blinkDuration = 0.5;
    _caretMaxOpacity = 1.0;
    _caretMinOpacity = 0.2;
    _caretWidth = 1;
    _caretHeight = 0;
    _menuActions = @[
        @(BRCBoxMenuActionTypeDelete),
        @(BRCBoxMenuActionTypeCut),
        @(BRCBoxMenuActionTypePaste),
        @(BRCBoxMenuActionTypeCopy)
    ];
    _boxSize = CGSizeMake(60, 60);
}

- (void)initSubViews {
    _textInputView = self.collectionView;
    [self addSubview:self.collectionView];
    [self.collectionView addSubview:self.caretView];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self refreshCollectionViewLayout];
}

#pragma mark - actions

- (void)handleAppWillEnterForegroundNot:(NSNotification *)notify { [self showCaretView]; }

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer { if (self.onClickInputViewBlock) self.onClickInputViewBlock(); }

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (self.isMenuActionsVaild &&
        gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.26 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showMenu];
        });
    }
}

#pragma mark - menu action

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    BRCBoxMenuActionType type = -1;
    if (action == @selector(copy:))   type = BRCBoxMenuActionTypeCopy;
    if (action == @selector(paste:))  type = BRCBoxMenuActionTypePaste;
    if (action == @selector(cut:))    type = BRCBoxMenuActionTypeCut;
    if (action == @selector(delete:)) type = BRCBoxMenuActionTypeDelete;;
    return [self isMenuActionsContainActionType:type];
}

- (void)copy:(id)sender {
    [self setText:self.pasteboard.string];
    [self sendMenuDelegateEventWithSEL:@selector(copyText: inInputView:) withText:self.pasteboard.string];
}

- (void)paste:(id)sender {
    [self sendMenuDelegateEventWithSEL:@selector(pasteText: inInputView:) withText:self.inputText];
    self.pasteboard.string = self.inputText ?: @"";
}

- (void)cut:(id)sender {
    [self sendMenuDelegateEventWithSEL:@selector(cutText: inInputView:) withText:self.inputText];
    self.pasteboard.string = self.inputText ?: @"";
    [self setText:@""];
}

- (void)delete:(id)sender {
    [self sendMenuDelegateEventWithSEL:@selector(deleteText: inInputView:) withText:self.inputText];
    [self setText:@""];
}

#pragma mark - public

- (void)toggleFirstResponder {
    if ([self isFirstResponder]) [self resignFirstResponder];
    else [self becomeFirstResponder];
}

- (void)setText:(NSString *)text {
    if ([_inputText isKindOfClass:[NSString class]] && [_inputText isEqualToString:text]) return;
    _inputText = nil;
    [self insertText:text];
}

- (void)hideMenu { [[UIMenuController sharedMenuController] hideMenuFromView:self]; }

- (void)showMenu {
    [UIMenuController sharedMenuController].arrowDirection = self.menuDirection;
    [[UIMenuController sharedMenuController] showMenuFromView:self rect:self.bounds];
}

- (void)reloadView {
    [self.collectionView reloadData];
    [self refreshCollectionViewLayout];
}

- (void)reloadBoxWithIndex:(NSInteger)index {
    if (index < self.inputMaxLength) { [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]]; }
}

#pragma mark - private

- (BOOL)shouldDisplayCaretView {
    BOOL shouldDisplayCaretView = self.showCaret && self.isFirstResponder && self.inputText.length < self.inputMaxLength;
    if ([self.placeHolder isKindOfClass:[NSString class]] && self.placeHolder.length > 0) {
        return self.currentInputIndex > self.placeHolder.length - 1 && shouldDisplayCaretView;
    }
    return shouldDisplayCaretView;
}

- (void)updateInputContent {
    if (![self.inputText isKindOfClass:[NSString class]]) return;
    [self hideCaretView];
    if (self.inputText.length >= self.inputMaxLength) {
        self.inputText = [self.inputText substringToIndex:self.inputMaxLength];
        if (self.autoDismissKeyBoardWhenFinishInput) [self resignFirstResponder];
        [self sendViewDelegetEventWithSEL:@selector(didFinishInput:)];
        if (self.onFinishInput) { self.onFinishInput(self.text); }
    }
    for (NSInteger i = 0; i < self.inputMaxLength; i ++) {
        [self updateBoxTextWithIndex:i];
        [self updateBoxSelectStateWithIndex:i isSelect:i == self.currentSelectIndex];
    }
    [self moveCaretViewToCurrentBoxView];
}

- (void)moveCaretViewToCurrentBoxView {
    if (!self.isFirstResponder) return;
    if (self.currentInputIndex <= [self.collectionView numberOfItemsInSection:0]) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentSelectIndex inSection:0] atScrollPosition:self.scrollPosition animated:YES];
    }
    UICollectionViewCell<BRCBoxViewProtocol> *boxView = [self boxViewWithIndex:self.currentSelectIndex];
    if ([boxView isKindOfClass:[UIView class]]) {
        self.caretView.frame = CGRectMake(0, 0,self.caretWidth, self.caretHeight);
        self.caretView.center = boxView.center;
        self.caretView.backgroundColor = self.caretTintColor;
        [self showCaretView];
    }
}

- (void)showCaretView {
    if (![self shouldDisplayCaretView]) return;
    self.caretView.hidden = NO;
    [self.caretView.layer removeAnimationForKey:@"blinkAnimation"];
    [self.caretView.layer addAnimation:[self createBlinkAnimation] forKey:@"blinkAnimation"];
}

- (void)hideCaretView {
    [self.caretView.layer removeAnimationForKey:@"blinkAnimation"];
    self.caretView.hidden = YES;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView 
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath { return [self boxSizeForIndex:indexPath.item]; }

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self sendBoxActionDelegateEventWithSEL:@selector(willDisplayBox:withIndex:inInputView:) withIndex:indexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self sendBoxActionDelegateEventWithSEL:@selector(didEndDisplayBox:withIndex:inInputView:) withIndex:indexPath.item];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView { return 1; }

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section { return self.inputMaxLength; }

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell<BRCBoxViewProtocol> *cell;
    if ([self isDelegateRespondsToSelector:@selector(boxWithIndex:inInputView:)]) {
        UIView<BRCBoxViewProtocol> *contentView = (UIView<BRCBoxViewProtocol> *)[self.delegate boxWithIndex:indexPath.item inInputView:self];
        if ([contentView isKindOfClass:[UIView class]] ) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBRCCustomBoxCollectionViewCellID forIndexPath:indexPath];
            if ([cell isKindOfClass:[BRCCustomBoxView class]]) {
                [(BRCCustomBoxView *)cell setMainView:contentView];}
        }
    }
    if (cell == nil) {
       cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBRCBoxCollectionViewCellID forIndexPath:indexPath];
    }
    BOOL isSelected = indexPath.item == self.currentSelectIndex && self.isFirstResponder;
    [self updateBoxSelectStateWithView:cell withIndex:indexPath.item isSelect:isSelected];
    [self updateBoxTextWithView:cell withIndex:indexPath.item];
    [self updateBoxSecureTextEntryWithView:cell];
    if ([self isBoxViewConformsProtocol:cell responderSelector:@selector(setBoxStyle:)]) {
        [cell setBoxStyle:[self boxStyleForIndex:indexPath.item]];
    }
    return cell;
}

#pragma mark - UITextInput / UIKeyInput

- (BOOL)hasText {
    return [self.inputText isKindOfClass:[NSString class]] && self.inputText.length > 0;
}

- (BRCTextPosition *)beginningOfDocument {
    return [[BRCTextPosition alloc] init];
}

- (BRCTextPosition *)endOfDocument {
    return [[BRCTextPosition alloc] initWithOffset:[self.inputText isKindOfClass:[NSString class]] ? self.inputText.length : 0];
}

- (void)insertText:(NSString *)text {
    if ([text isEqualToString:@"\n"] && [self isDelegateRespondsToSelector:@selector(boxInputViewShouldReturn:)] && [self.delegate boxInputViewShouldReturn:self]) {
        [self resignFirstResponder];
    }
    if (![text isEqualToString:@""] && ![self isVaildString:text]) return;
    [self excuteUpdateText:^{
        if ([self.inputText isKindOfClass:[NSString class]]) {
            self.inputText = [self.inputText stringByAppendingString:text];
        } else {
            self.inputText = text;
        }
    }];
}

- (void)deleteBackward {
    [self excuteUpdateText:^{
        if ([self hasText]) self.inputText = [self.inputText substringWithRange:NSMakeRange(0, self.inputText.length - 1)];
    }];
}

#pragma mark - responder

- (BOOL)becomeFirstResponder {
    BOOL becomeFirstResponder = [super becomeFirstResponder];
    [self sendViewDelegetEventWithSEL:@selector(didBecomeFirstResponderWithView:)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateBoxSelectStateWithIndex:self.currentSelectIndex isSelect:YES];
        [self moveCaretViewToCurrentBoxView];
    });
    return becomeFirstResponder;
}

- (BOOL)resignFirstResponder {
    BOOL resignFirstResponder = [super resignFirstResponder];
    [self sendViewDelegetEventWithSEL:@selector(didResignFirstResponderWithView:)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateBoxSelectStateWithIndex:self.currentSelectIndex isSelect:NO];
        [self hideCaretView];
    });
    return resignFirstResponder;
}

#pragma mark - update

- (void)updateBoxSelectStateWithIndex:(NSInteger)index isSelect:(BOOL)isSelect{
    [self updateBoxSelectStateWithView:[self boxViewWithIndex:index] withIndex:index isSelect:isSelect];
}

- (void)updateBoxSelectStateWithView:(UIView *)boxView withIndex:(NSInteger)index isSelect:(BOOL)isSelect {
    SEL delegetEventSEL = isSelect ? @selector(willSelectInputBox:withIndex:inInputView:) : @selector(willUnSelectInputBox:withIndex:inInputView:);
    [self sendBoxActionDelegateEventWithSEL:delegetEventSEL withIndex:index];
    if ([self isBoxViewConformsProtocol:boxView responderSelector:@selector(setBoxStyle:)]) {
        NoWarningPerformSelector([boxView performSelector:@selector(setBoxStyle:) withObject:[self boxStyleForIndex:index]])
    }
    SEL boxSelector = isSelect ? @selector(didSelectInputBox) : @selector(didUnSelectInputBox);
    if ([self isBoxViewConformsProtocol:boxView responderSelector:boxSelector]) {
        NoWarningPerformSelector([boxView performSelector:boxSelector])
    }
    delegetEventSEL = isSelect ? @selector(didSelectInputBox:withIndex:inInputView:) : @selector(didUnSelectInputBox:withIndex:inInputView:);
    [self sendBoxActionDelegateEventWithSEL:delegetEventSEL withIndex:index];
}

- (void)updateBoxTextWithIndex:(NSInteger)index {
    [self updateBoxTextWithView:[self boxViewWithIndex:index] withIndex:index];
}

- (void)updateBoxTextWithView:(id<BRCBoxViewProtocol,NSObject>)boxView withIndex:(NSInteger)index{
    if (![boxView isKindOfClass:[UIView class]]) return;
    if ([boxView conformsToProtocol:@protocol(BRCBoxViewProtocol)]) {
        NSString *boxText = @"";
        SEL selector = @selector(setBoxText:);
        if (index < self.currentInputIndex) {
            boxText = [self getCharacterAtIndex:index withString:self.inputText];
        } else if ([self.placeHolder isKindOfClass:[NSString class]] &&
                   index < self.placeHolder.length) {
            boxText = [self getCharacterAtIndex:index withString:self.placeHolder];
            selector = @selector(setBoxPlaceHolder:);
            [self hideCaretView];
        }
        if ([boxView respondsToSelector:selector]) NoWarningPerformSelector([boxView performSelector:selector withObject:boxText]);
    }
}

- (void)updateBoxSecureTextEntryWithIndex:(NSInteger)index {
    [self updateBoxSecureTextEntryWithView:[self boxViewWithIndex:index]];
}

- (void)updateBoxSecureTextEntryWithView:(id<BRCBoxViewProtocol>)boxView {
    if ([self isBoxViewConformsProtocol:boxView responderSelector:@selector(setSecureTextEntry: withDuration:delay:)]) {
        [boxView setSecureTextEntry:self.secureTextEntry withDuration:self.secureTransitionDuration delay:self.secureDelayDuration];
    }
}

#pragma mark - util

- (void)excuteUpdateText:(void (^)(void))updateBlock {
    [self sendViewDelegetEventWithSEL:@selector(boxTextWillChange:)];
    if (updateBlock) updateBlock();
    [self singleExecute:^{
        [self updateInputContent];
        [self sendViewDelegetEventWithSEL:@selector(boxTextDidChange:)];
    }];
}

- (void)singleExecute:(void (^)(void))block {
    if (self.workBlock) { dispatch_block_cancel(self.workBlock); }
    self.workBlock = dispatch_block_create(0, ^{ if (block) block(); });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), self.workBlock);
}

- (BOOL)matchesString:(NSString *)string withPattern:(NSString *)pattern {
    if (![string isKindOfClass:[NSString class]] || ![pattern isKindOfClass:[NSString class]]) return NO;
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    if (error) return NO;
    NSRange range = NSMakeRange(0, [string length]);
    NSTextCheckingResult *match = [regex firstMatchInString:string options:0 range:range];
    return match != nil;
}

- (BOOL)isNotBlankString:(NSString *)string { return [self matchesString:string withPattern:@"\\S"]; }

- (BOOL)isVaildString:(NSString *)string {
    BOOL isNotBlank = [self isNotBlankString:string];
    if ([self isNotBlankString:self.inputPattern]) return isNotBlank && [self matchesString:string withPattern:self.inputPattern];
    return isNotBlank;
}

- (CABasicAnimation *)createBlinkAnimation {
    CABasicAnimation *blinkAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    blinkAnimation.fromValue = @(_caretMaxOpacity);
    blinkAnimation.toValue = @(_caretMinOpacity);
    blinkAnimation.duration = _blinkDuration;
    blinkAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    blinkAnimation.autoreverses = YES;
    blinkAnimation.repeatCount = HUGE_VALF;
    return blinkAnimation;
}

- (BOOL)isDelegateRespondsToSelector:(SEL)selector {
    return selector != NULL && self.delegate &&
    [self.delegate respondsToSelector:selector];
}

- (void)sendViewDelegetEventWithSEL:(SEL)selector {
    if ([self isDelegateRespondsToSelector:selector]) {
        NoWarningPerformSelector([self.delegate performSelector:selector withObject:self]);
    }
}

- (void)sendMenuDelegateEventWithSEL:(SEL)selector withText:(NSString *)text{
    if ([self isDelegateRespondsToSelector:selector]) {
        NoWarningPerformSelector([self.delegate performSelector:selector withObject:text withObject:self]);
    }
}

- (void)sendBoxActionDelegateEventWithSEL:(SEL)selector withIndex:(NSInteger)index {
    if ([self isDelegateRespondsToSelector:selector]) {
        void (*objcMsgSend)(id, SEL, id, NSInteger, id) = (void *)objc_msgSend;
        objcMsgSend(self.delegate, selector, [self boxViewWithIndex:index], index, self);
    }
}

- (BOOL)isMenuActionsContainActionType:(BRCBoxMenuActionType)type {
    if (self.isMenuActionsVaild) return [self.menuActions containsObject:@(type)];
    return NO;
}

- (BOOL)isBoxViewConformsProtocol:(id)boxView responderSelector:(SEL)selector{
    return [boxView conformsToProtocol:@protocol(BRCBoxViewProtocol)] &&
    [boxView respondsToSelector:selector];
}

- (NSString *)getCharacterAtIndex:(NSInteger)index withString:(NSString *)string {
    if ([string isKindOfClass:[NSString class]] && index < string.length) return [NSString stringWithFormat:@"%C",[string characterAtIndex:index]];
    return @"";
}

- (void)refreshCollectionViewLayout {
    CGFloat containerWidth = self.collectionViewContainerWidth;
    if (self.collectionView.contentSize.width == containerWidth) return;
    [NSLayoutConstraint deactivateConstraints:self.activeConstraints];
    self.activeConstraints = [NSMutableArray array];
    [self.activeConstraints addObjectsFromArray:@[
        [self.collectionView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
    if (containerWidth > self.frame.size.width) {
        [self.activeConstraints addObjectsFromArray:@[
            [self.collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [self.collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        ]];
    } else {
        NSLayoutConstraint *alignmentConstraint = nil;
        NSString *valueName = @"";
        if (self.boxAlignment == BRCBoxAlignmentLeft) valueName = @"leadingAnchor";
        else if (self.boxAlignment == BRCBoxAlignmentRight)  valueName = @"trailingAnchor";
        else valueName = @"centerXAnchor";
        alignmentConstraint = [[self.collectionView valueForKey:valueName] constraintEqualToAnchor:[self valueForKey:valueName]];
        [self.activeConstraints addObject:alignmentConstraint];
        [self.activeConstraints addObject:[self.collectionView.widthAnchor constraintEqualToConstant:containerWidth]];
    }
    [NSLayoutConstraint activateConstraints:self.activeConstraints];
}

#pragma mark - getter

- (BRCBoxStyle *)boxStyleForIndex:(NSInteger)index {
    BRCBoxStyle *style = (index == self.currentSelectIndex) && self.isFirstResponder ? self.selectedBoxStyle : self.boxStyle;
    if ([self isDelegateRespondsToSelector:@selector(boxStyleWithIndex:withBoxView:inInputView:)]) {
        BRCBoxStyle *delegateStyle = [self.delegate boxStyleWithIndex:index withBoxView:(BRCBoxView *)[self boxViewWithIndex:index] inInputView:self];
        if ([delegateStyle isKindOfClass:[BRCBoxStyle class]]) style = delegateStyle;
    }
    return style;
}

- (CGSize)boxSizeForIndex:(NSInteger)index {
    CGSize boxSize = self.boxSize;
    if ([self isDelegateRespondsToSelector:@selector(boxStyleWithIndex:withBoxView:inInputView:)]) {
        boxSize = [self boxStyleForIndex:index].boxSize;
    }
    CGFloat autoFillContainerBoxWidth = self.autoFillContainerBoxWidth;
    CGFloat width = (self.autoFillBoxContainer && autoFillContainerBoxWidth >= 0) ? self.autoFillContainerBoxWidth : boxSize.width;
    return CGSizeMake(width, MIN(self.frame.size.height, boxSize.height));
}

- (CGFloat)collectionViewContainerWidth {
    CGFloat width = 0;
    for (NSInteger i = 0; i < self.inputMaxLength; i++) {
        width += [self boxSizeForIndex:i].width + self.boxSpace;
    }
    return width;
}

- (BOOL)isFill {
    if (![self.text isKindOfClass:[NSString class]]) return NO;
    return self.text.length == self.inputMaxLength;
}

- (BOOL)isMenuActionsVaild {
    return [self.menuActions isKindOfClass:[NSArray class]] &&
    self.menuActions.count > 0;
}

- (NSUInteger)currentInputIndex {
    if (![self.inputText isKindOfClass:[NSString class]]) return 0;
    return _inputText.length;
}

- (NSUInteger)currentSelectIndex {
    if (self.currentInputIndex == self.inputMaxLength) return self.inputMaxLength - 1;
    return self.currentInputIndex;
}

- (CGFloat)autoFillContainerBoxWidth {
    if (_autoFillContainerBoxWidth <= 0) {
        _autoFillContainerBoxWidth = (self.frame.size.width - (self.inputMaxLength + 1) * self.boxSpace) / self.inputMaxLength;
    }
    return _autoFillContainerBoxWidth;
}

- (UICollectionViewCell<BRCBoxViewProtocol> *)boxViewWithIndex:(NSInteger)index{
    return (UICollectionViewCell<BRCBoxViewProtocol> *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
}

- (NSString *)text { return [_inputText isKindOfClass:[NSString class]] ? _inputText : @""; }
- (UIPasteboard *)pasteboard { return [UIPasteboard generalPasteboard]; }
- (BRCBoxAlignment)boxAlignment { return _alignment; }
- (CGFloat)caretWidth { return MIN(self.frame.size.width, _caretWidth); }
- (CGFloat)caretHeight { if (_caretHeight <= 0) { return MAX(self.frame.size.height / 3, 8); }
    return MIN(self.frame.size.height, _caretHeight);
}
- (UICollectionViewScrollPosition)scrollPosition { if (self.inputMaxLength == self.text.length) return UICollectionViewScrollPositionRight;
    return (UICollectionViewScrollPosition)self.focusScrollPosition; }

#pragma mark - setter

- (void)setSecureTextEntry:(BOOL)secureTextEntry {
    _secureTextEntry = secureTextEntry;
    for (NSInteger i = 0; i < self.inputMaxLength; i++) {
        [self updateBoxSecureTextEntryWithIndex:i];
    }
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    _contentInsets = contentInsets;
    [self.collectionView setContentInset:contentInsets];
}

- (void)setBoxSize:(CGSize)boxSize {
    _boxSize = boxSize;
    if (!CGSizeEqualToSize(boxSize, CGSizeZero)) { self.autoFillBoxContainer = NO; }
}

- (void)setBoxSpace:(CGFloat)boxSpace {
    _boxSpace = boxSpace;
    self.flowLayout.minimumInteritemSpacing = self.boxSpace;
}

- (void)setAlignment:(BRCBoxAlignment)alignment {
    _alignment = alignment;
    [self refreshCollectionViewLayout];
}

- (void)setBoxViewClass:(Class)boxViewClass {
    _boxViewClass = boxViewClass;
    [self.collectionView registerClass:boxViewClass forCellWithReuseIdentifier:kBRCBoxCollectionViewCellID];
}

- (void)setInputMaxLength:(NSUInteger)inputMaxLength {
    if (_inputMaxLength != inputMaxLength) { _inputMaxLength = inputMaxLength; [self.collectionView reloadData]; }
}

#pragma mark - props

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _flowLayout = [[BRCBoxFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumInteritemSpacing = self.boxSpace;
        _flowLayout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeNone;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.clipsToBounds = NO;
        [_collectionView registerClass:_boxViewClass forCellWithReuseIdentifier:kBRCBoxCollectionViewCellID];
        [_collectionView registerClass:[BRCCustomBoxView class] forCellWithReuseIdentifier:kBRCCustomBoxCollectionViewCellID];
        [_collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _collectionView;
}

- (UIView *)caretView {
    if (!_caretView) {
        _caretView = [[UIView alloc] init];
        _caretView.backgroundColor = self.caretTintColor;
        _caretView.hidden = YES;
    }
    return _caretView;
}

#pragma mark - Optional

- (BOOL)canBecomeFocused { return YES; }
- (BOOL)canBecomeFirstResponder { return YES; }
- (void)setMarkedText:(NSString *)markedText
        selectedRange:(NSRange)selectedRange { [self insertText:markedText]; }
- (NSString *)textInRange:(BRCTextRange *)range {return @"";}
- (void)replaceRange:(BRCTextRange *)range withText:(NSString *)text {};
- (void)unmarkText {};
- (NSComparisonResult)comparePosition:(BRCTextPosition *)position toPosition:(BRCTextPosition *)other {return NSOrderedSame;}
- (NSInteger)offsetFromPosition:(BRCTextPosition *)from toPosition:(BRCTextPosition *)toPosition {return 0;}
- (BRCTextRange *)characterRangeByExtendingPosition:(BRCTextPosition *)position inDirection:(UITextLayoutDirection)direction {return [BRCTextRange new];}
- (BRCTextRange *)characterRangeAtPoint:(CGPoint)point {return [BRCTextRange new];}
- (BRCTextPosition *)closestPositionToPoint:(CGPoint)point {return [BRCTextPosition new];}
- (BRCTextPosition *)closestPositionToPoint:(CGPoint)point withinRange:(BRCTextRange *)range {return [BRCTextPosition new];}
- (BRCTextPosition *)positionWithinRange:(BRCTextRange *)range farthestInDirection:(UITextLayoutDirection)direction {return [BRCTextPosition new];}
- (BRCTextRange *)textRangeFromPosition:(BRCTextPosition *)fromPosition toPosition:(BRCTextPosition *)toPosition { return [BRCTextRange new];}
- (BRCTextPosition *)positionFromPosition:(BRCTextPosition *)position offset:(NSInteger)offset {return [BRCTextPosition new];}
- (BRCTextPosition *)positionFromPosition:(BRCTextPosition *)position inDirection:(UITextLayoutDirection)direction offset:(NSInteger)offset {return [BRCTextPosition new];}
- (CGRect)firstRectForRange:(BRCTextRange *)range {return CGRectZero;}
- (CGRect)caretRectForPosition:(BRCTextPosition *)position {return CGRectZero;}
- (NSArray<UITextSelectionRect *> *)selectionRectsForRange:(BRCTextRange *)range {return @[];}

@end
