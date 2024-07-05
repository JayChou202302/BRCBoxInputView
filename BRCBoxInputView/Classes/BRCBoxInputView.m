//
//  BRCVerifyCodeView.m
//  ClothStore
//
//  Created by sunzhixiong on 2023/12/2.
//

#import "BRCBoxInputView.h"
#import "BRCTextInput.h"

#define kBRCBoxViewOriginTag 0x9982

@implementation BRCBoxStyle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _backgroundColor = [UIColor whiteColor];
        _borderColor = [UIColor blackColor];
        _borderWidth = 1.0;
        _cornerRadius = 5.0;
        _labelFont = [UIFont boldSystemFontOfSize:18.0];
        _labelColor = [UIColor blackColor];
        _boxSize = CGSizeMake(60, 60);
        _placeHolderFont = [UIFont systemFontOfSize:13.0];
        _placeHolderColor = [UIColor grayColor];
        _secretView = nil;
        _secretDisplayDelay = 0.2;
        _shadowColor = nil;
        _shadowOffset = CGSizeZero;
        _shadowRadius = 0;
        _customView = nil;
    }
    return self;
}

+ (instancetype)defaultStyle {
    return [BRCBoxStyle new];
}

+ (instancetype)defaultSelectStyle {
    BRCBoxStyle *style = [BRCBoxStyle defaultStyle];
    style.borderColor = [UIColor systemRedColor];
    style.boxSize = CGSizeMake(60, 60);
    return style;
}

+ (instancetype)lineBoxStyle {
    BRCBoxStyle *style = [BRCBoxStyle defaultStyle];
    style.borderWidth = 0;
    style.backgroundColor = [UIColor clearColor];
    style.cornerRadius = 0;
    style.customView = ^UIView * _Nonnull(BRCBoxView * _Nonnull boxView) {
        UIView *lineView = [self createLineViewWithTag:boxView.isNotEmpty ? 202 : 200];
        lineView.frame = CGRectMake(0, boxView.frame.size.height - 5, boxView.frame.size.width, 5);
        lineView.backgroundColor = boxView.isNotEmpty ? [UIColor blackColor] : [UIColor systemGray6Color];
        return lineView;
    };
    return style;
}

+ (instancetype)selectLineBoxStyle {
    BRCBoxStyle *style = [BRCBoxStyle lineBoxStyle];
    style.customView = ^UIView * _Nonnull(BRCBoxView * _Nonnull boxView) {
        UIView *lineView = [self createLineViewWithTag:201];
        lineView.frame = CGRectMake(0, boxView.frame.size.height - 8, boxView.frame.size.width, 8);
        lineView.backgroundColor = [UIColor systemPinkColor];
        return lineView;
    };
    return style;
}

+ (UIView *)createLineViewWithTag:(NSInteger)tag {
    UIView *lineView = [UIView new];
    lineView.tag = tag;
    lineView.layer.cornerRadius = 2.0;
    lineView.clipsToBounds = YES;
    return lineView;
}

#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    BRCBoxStyle *style = [[self.class allocWithZone:zone] init];
    style.backgroundColor = self.backgroundColor;
    style.borderColor = self.borderColor;
    style.borderWidth = self.borderWidth;
    style.labelFont = self.labelFont;
    style.labelColor = self.labelColor;
    style.placeHolderFont = self.placeHolderFont;
    style.placeHolderColor = self.placeHolderColor;
    style.secretView = self.secretView;
    style.secretDisplayDelay = self.secretDisplayDelay;
    style.cornerRadius = self.cornerRadius;
    style.boxSize = self.boxSize;
    style.shadowColor = self.shadowColor;
    style.shadowOffset = self.shadowOffset;
    style.shadowRadius = self.shadowRadius;
    style.customView = self.customView;
    return style;
}

@end

@interface BRCBoxView () {
    BOOL _isSelect;
    BOOL _textIsPlaceHolder;
    BOOL _isSecret;
}
@property (nonatomic, strong) UIView  *customView;
@property (nonatomic, strong) UIView  *shadowView;
@property (nonatomic, strong) UIView  *backgroundView;
@property (nonatomic, strong) UIView  *secretView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) BRCBoxStyle *style;
@end

@implementation BRCBoxView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isSecret = NO;
        _isSelect = NO;
        _textIsPlaceHolder = NO;
        _backgroundView = [UIView new];
        _shadowView = [UIView new];
        [self addSubview:self.shadowView];
        [self addSubview:self.backgroundView];
        [self.backgroundView addSubview:self.label];
    }
    return self;
}

#pragma mark - display

- (void)setSecret:(BOOL)secret {
    [self setSecret:secret animated:YES];
}

- (void)setSecret:(BOOL)secret animated:(BOOL)animated {
    if (_isSecret == secret) {
        return;
    }
    _isSecret = secret;
    if (secret) {
        [self showSecretView:animated];
    } else {
        [self hideSecretView];
    }
}

- (void)showSecretView:(BOOL)isAnimated {
    if (![self.secretView isKindOfClass:[UIView class]]) {
        return;
    }
    if (![self isNotEmpty]) {
        return;
    }
    [UIView animateWithDuration:isAnimated ? 0.2 : 0 delay:_style.secretDisplayDelay options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.secretView.alpha = 1;
        self.label.alpha = 0;
    } completion:nil];
}

- (void)hideSecretView{
    if (![self.secretView isKindOfClass:[UIView class]]) {
        return;
    }
    self.secretView.alpha = 0;
    self.label.alpha = 1;
}

#pragma mark - style

- (void)setStyle:(BRCBoxStyle *)style {
    _style = style;
    _isSelect = NO;
    [self _setStyle:style];
}

- (void)setSelectStyle:(BRCBoxStyle *)style {
    _style = style;
    _isSelect = YES;
    [self _setStyle:style];
}

- (void)_setSecretViewStyle {
    if (_style.secretView) {
        UIView *secretView = _style.secretView();
        if ([secretView isKindOfClass:[UIView class]] &&
            (_secretView == nil ||
             _secretView.tag != secretView.tag)) {
            [_secretView removeFromSuperview];
            _secretView = secretView;
            _secretView.alpha = 0;
            [self.backgroundView addSubview:_secretView];
            [self _updateSecretViewFrame];
        }
    }
}

- (void)_setCustomViewStyle {
    if (_style.customView) {
        UIView *customView = _style.customView(self);
        if ([customView isKindOfClass:[UIView class]] &&
            (_customView == nil ||
             _customView.tag != customView.tag)) {
            [_customView removeFromSuperview];
            _customView = customView;
            [self.backgroundView addSubview:_customView];
        }
    }
}

- (void)_setStyle:(BRCBoxStyle *)style {
    self.backgroundView.backgroundColor = style.backgroundColor;
    self.backgroundView.layer.cornerRadius = style.cornerRadius;
    self.backgroundView.clipsToBounds = style.cornerRadius > 0;
    self.backgroundView.layer.borderWidth = style.borderWidth;
    self.backgroundView.layer.borderColor = [style.borderColor CGColor];
    if ([style.shadowColor isKindOfClass:[UIColor class]]) {
        self.shadowView.backgroundColor = [UIColor whiteColor];
        self.shadowView.layer.shadowColor = [style.shadowColor CGColor];
        self.shadowView.layer.shadowOffset = style.shadowOffset;
        self.shadowView.layer.shadowRadius = style.shadowRadius;
        self.shadowView.layer.shadowOpacity = 1;
    }
    [self _setSecretViewStyle];
    [self _setCustomViewStyle];
}

#pragma mark - text

- (void)setText:(NSString *)text {
    _textIsPlaceHolder = NO;
    self.label.textColor = self.style.labelColor;
    self.label.font = self.style.labelFont;
    _label.text = text;
    [self _setSecretViewStyle];
    [self _setCustomViewStyle];
}

- (void)setPlaceHolderText:(NSString *)placeHolder {
    _textIsPlaceHolder = YES;
    self.label.textColor = self.style.placeHolderColor;
    self.label.font = self.style.placeHolderFont;
    _label.text = placeHolder;
    [self _setSecretViewStyle];
    [self _setCustomViewStyle];
}

#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];
    [self _updateFrame];
}

- (void)_updateFrame {
    [UIView animateWithDuration:0.1f animations:^{
        self.label.frame = self.bounds;
        self.backgroundView.frame = self.bounds;
        self.shadowView.frame = CGRectInset(self.bounds, 5, 5);
        [self _updateCustomViewFrame];
    }];
    [self _updateSecretViewFrame];
}

- (void)_updateCustomViewFrame {
    if ([self.customView isKindOfClass:[UIView class]] && self.style.customView) {
        UIView *customView = self.style.customView(self);
        if (!CGRectEqualToRect(self.customView.frame, customView.frame)) {
            self.customView.frame = customView.frame;
        }
    }
}

- (void)_updateSecretViewFrame {
    if ([self.secretView isKindOfClass:[UIView class]]) {
        CGFloat width = MIN(_secretView.frame.size.width, self.frame.size.width);
        CGFloat height = MIN(_secretView.frame.size.height, self.frame.size.height);
        if (width == 0) {
            width = self.frame.size.width / 2;
        }
        if (height == 0) {
            height = self.frame.size.height / 2;
        }
        CGFloat x = (self.frame.size.width - width) / 2;
        CGFloat y = (self.frame.size.height - height) / 2;
        _secretView.frame = CGRectMake(x, y, width, height);
    }
}

#pragma mark - props

- (UILabel *)label {
    if (!_label) {
        _label = UILabel.new;
        _label.backgroundColor = [UIColor clearColor];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (BOOL)isSelect {
    return _isSelect;
}

- (BOOL)isNotEmpty {
    return [_label.text isKindOfClass:[NSString class]] &&
    _label.text.length > 0 &&
    !_textIsPlaceHolder;
}

@end

@interface BRCBoxInputView () {
    BRCTextRange *_selectedTextRange;
    BRCTextRange *_markedTextRange;
    BRCBoxStyle  *_selectBoxStyle;
    UIView       *_textInputView;
    NSUInteger   _inputMaxLength;
    BOOL         _isShowCaret;
    BOOL         _secureTextEntry;
    BOOL         _menuable;
    NSDictionary<NSAttributedStringKey, id> *_markedTextStyle;
    NSMutableArray<BRCBoxStyle *>           *_boxStyles;
    __weak id<UITextInputTokenizer>         _tokenizer;
};

@property (nonatomic, strong) UIScrollView     *scrollView;
@property (nonatomic, strong) UIView           *caretView;
@property (nonatomic, strong) UIView           *boxContainerView;
@property (nonatomic, strong) NSString         *markedText;
@property (nonatomic, copy)   dispatch_block_t workBlock;
@end

@implementation BRCBoxInputView

#pragma mark - init

+ (instancetype)boxInputWithLength:(NSUInteger)length {
    return [[BRCBoxInputView alloc] initWithInputLength:length];
}

- (instancetype)initWithInputLength:(NSUInteger)length {
    self = [super init];
    if (self) {
        _inputMaxLength = length;
        [self _initDefaults];
        [self _initMenuAction];
        [self _initGesture];
        [self _initBoxs];
        [self _addObservers];
        [self _initSubViews];
        [self _initCaretConfig];
    }
    return self;
}

- (void)dealloc
{
    [self _removeObservers];
}

- (void)_initBoxs {
    _boxStyles = [NSMutableArray array];
    for (NSInteger i = 0; i < _inputMaxLength; i++) {
        [_boxStyles addObject:[BRCBoxStyle defaultStyle]];
    }
    _selectBoxStyle = [BRCBoxStyle defaultSelectStyle];
    _boxSpace = 10;
}

- (void)_initDefaults {
    _isRTL = NO;
    __weak __typeof__(self) weakSelf = self;
    _onClickInputViewBlock = ^{
        [weakSelf toggleFirstResponder];
    };
    _alignment = BRCBoxAlignmentCenter;
    _menuable = YES;
    _placeHolder = nil;
    _autoDismissKeyBoardWhenFinishInput = NO;
    _autoFillBoxContainer = YES;
    _selectedTextRange = [BRCTextRange defaultRange];
    _markedTextRange = nil;
    _markedTextStyle = nil;
    _selectTransitionDuration = 0.2;
    _secureTextEntry = NO;
    _keyboardType = UIKeyboardTypeNumberPad;
    _textContentType = UITextContentTypeOneTimeCode;
}

- (void)_initCaretConfig {
    _showCaret = YES;
    _isShowCaret = YES;
    _blinkDuration = 0.5;
    _caretMaxOpacity = 1.0;
    _caretMinOpacity = 0.2;
    _caretWidth = 1;
    _caretHeight = 0;
}

- (void)_initSubViews {
    _textInputView = self.scrollView;
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.boxContainerView];
    for (NSInteger i = 0; i < _inputMaxLength; i++) {
        BRCBoxView *boxView = [[BRCBoxView alloc] init];
        boxView.tag = kBRCBoxViewOriginTag + i;
        [boxView setStyle:[BRCBoxStyle defaultStyle]];
        [self.boxContainerView addSubview:boxView];
    }
    [self.scrollView addSubview:self.caretView];
}

- (void)_initGesture {
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)]];
}

- (void)_initMenuAction {
    _copyable = YES;
    _pasteable = YES;
    _cutable = YES;
    _deleteable = YES;
}

#pragma mark - gesture

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (self.onClickInputViewBlock) self.onClickInputViewBlock();
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (!_menuable) return;
    if ((self.copyable || self.pasteable || self.cutable || self.deleteable) &&
        gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        [[UIMenuController sharedMenuController] showMenuFromView:self rect:self.bounds];
    }
}

#pragma mark - menu

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copy:))   return self.copyable;
    if (action == @selector(paste:))  return self.pasteable;
    if (action == @selector(cut:))    return self.cutable;
    if (action == @selector(delete:)) return self.deleteable;;
    return NO;
}

- (void)copy:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [self setInputText:pasteboard.string];
    if (_inputDelegate && [_inputDelegate respondsToSelector:@selector(copyText: inputView:)]) {
        [_inputDelegate copyText:pasteboard.string inputView:self];
    }
}

- (void)paste:(id)sender {
    if (_inputDelegate && [_inputDelegate respondsToSelector:@selector(pasteText: inputView:)]) {
        [_inputDelegate pasteText:_inputText inputView:self];
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.inputText ?: @"";
}

- (void)cut:(id)sender {
    if (_inputDelegate && [_inputDelegate respondsToSelector:@selector(cutText: inputView:)]) {
        [_inputDelegate cutText:_inputText inputView:self];
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.inputText ?: @"";
    [self setInputText:@""];
}

- (void)delete:(id)sender {
    if (_inputDelegate && [_inputDelegate respondsToSelector:@selector(deleteText: inputView:)]) {
        [_inputDelegate deleteText:_inputText inputView:self];
    }
    [self setInputText:@""];
}

#pragma mark - public

- (void)toggleFirstResponder {
    if ([self isFirstResponder]) [self resignFirstResponder];
    else [self becomeFirstResponder];
}

- (void)setMenuable:(BOOL)menuable {
    _menuable = menuable;
}

- (void)setInputText:(NSString *)inputText {
    _inputText = nil;
    [self insertText:inputText];
}

#pragma mark - private

- (void)_setBoxViewTextWithIndex:(NSInteger)index {
    BRCBoxView *inputBoxView = [self findInputBoxWithIndex:index];
    if (![inputBoxView isKindOfClass:[BRCBoxView class]]) {
        return;
    }
    NSString *text = @"";
    if (index < _inputText.length) {
        unichar character = [_inputText characterAtIndex:index];
        text = [NSString stringWithFormat:@"%C",character];
        [inputBoxView setText:text];
        if (_secureTextEntry) {
            [inputBoxView showSecretView:YES];
        }
    } else if ([self.placeHolder isKindOfClass:[NSString class]] &&
                index < self.placeHolder.length){
         unichar character = [self.placeHolder characterAtIndex:index];
         text = [NSString stringWithFormat:@"%C",character];
         [inputBoxView setPlaceHolderText:text];
         [inputBoxView hideSecretView];
     } else {
        [inputBoxView setText:text];
        [inputBoxView hideSecretView];
    }
}

#pragma mark - style

- (void)setSelectBoxStyle:(BRCBoxStyle *)selectStyle {
    _selectBoxStyle = selectStyle;
    [self _updateStyles];
}

- (void)setBoxStyle:(BRCBoxStyle *)style {
    if (style == nil) {
        return;
    }
    [_boxStyles removeAllObjects];
    for (NSInteger i = 0; i < _inputMaxLength; i++) {
        [_boxStyles addObject:style];
    }
    [self _updateStyles];
}

- (void)setBoxStyle:(BRCBoxStyle *)style forIndex:(NSUInteger)index {
    if (style == nil || index > _inputMaxLength) {
        return;
    }
    [_boxStyles replaceObjectAtIndex:index withObject:style];
    [self _updateStyles];
}

- (void)setBoxStyles:(NSArray<BRCBoxStyle *> *)styles {
    if (![styles isKindOfClass:[NSArray class]]) {
        return;
    }
    _boxStyles = [NSMutableArray arrayWithArray:styles];
    [self _updateStyles];
}

- (void)_updateBoxWithIndex:(NSInteger)index {
    BRCBoxView *boxView = [self findInputBoxWithIndex:index];
    BRCBoxStyle *style = [BRCBoxStyle defaultStyle];
    if (index < _boxStyles.count) {
        style = _boxStyles[index];
    }
    [self _updateStyleWithBox:boxView style:style];
}

- (void)_updateSelectStyleWithBox:(BRCBoxView *)boxView style:(BRCBoxStyle *)style {
    if (!CGSizeEqualToSize(boxView.frame.size, _selectBoxStyle.boxSize)) {
        // 两者 Size 不一样，需要更新layout
        [self _updateLayout];
    }
    [boxView setSelectStyle:_selectBoxStyle];
}

- (void)_updateStyleWithBox:(BRCBoxView *)boxView style:(BRCBoxStyle *)style {
    if ([style isKindOfClass:[BRCBoxStyle class]]) {
        [boxView setStyle:style];
    }
}

- (void)_updateStyles {
    [_boxStyles enumerateObjectsUsingBlock:^(BRCBoxStyle * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BRCBoxView *box = [self findInputBoxWithIndex:idx];
        [box setSecret:self.secureTextEntry animated:NO];
        if ([box isKindOfClass:[BRCBoxView class]]) {
            if (idx == [self currentInputIndex] && [self isFirstResponder]) {
                [self _updateSelectStyleWithBox:box style:obj];
            } else {
                [self _updateStyleWithBox:box style:obj];
            }
        }
    }];
}

- (void)_updateLastBox {
    if ([self currentInputIndex] == _inputMaxLength - 1) {
        BRCBoxView *lastBox = [self findInputBoxWithIndex:[self currentInputIndex]];
        if ([lastBox isNotEmpty] && [self isSecureTextEntry]) {
            [lastBox showSecretView:NO];
        }
        if ([self isFirstResponder]) {
            [lastBox setSelectStyle:_selectBoxStyle];
        } else {
            [lastBox setStyle:_boxStyles.lastObject];
        }
        [lastBox setText:lastBox.label.text];
    }
}

#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];
    [self _updateLayout];
}

- (CGFloat)getAutoFillContainerBoxWidth {
    CGFloat boxCount = _inputMaxLength;
    return (self.frame.size.width - (boxCount + 1) * _boxSpace) / boxCount;
}

- (CGFloat)boxStandardHeightWithIndex:(NSInteger)index {
    BRCBoxStyle *style = [BRCBoxStyle defaultStyle];
    if (index < _boxStyles.count) {
        style = _boxStyles[index];
    }
    CGFloat boxStandardHeight = MIN(self.frame.size.height,style.boxSize.height);
    if (index == [self currentInputIndex] && self.isFirstResponder) {
        boxStandardHeight = MIN(self.frame.size.height, _selectBoxStyle.boxSize.height);
    }
    return boxStandardHeight;
}

- (CGFloat)boxStandardWidthWithIndex:(NSInteger)index {
    BRCBoxStyle *style = [BRCBoxStyle defaultStyle];
    if (index < _boxStyles.count) {
        style = _boxStyles[index];
    }
    CGFloat boxStandardWidth = _autoFillBoxContainer ? [self
                                                        getAutoFillContainerBoxWidth] :  style.boxSize.width;
    if (index == [self currentInputIndex] &&
        self.isFirstResponder &&
        _selectBoxStyle.boxSize.width != style.boxSize.width) {
        boxStandardWidth = _selectBoxStyle.boxSize.width;
    }
    return boxStandardWidth;
}

- (void)_updateLayout {
    CGFloat left = _boxSpace;
    for (NSInteger i = 0; i < _inputMaxLength; i++) {
        CGFloat boxStandardHeight = [self boxStandardHeightWithIndex:i];
        CGFloat boxStandardWidth = [self boxStandardWidthWithIndex:i];
        CGFloat box_y = (self.frame.size.height - boxStandardHeight) / 2;
        BRCBoxView *boxView = [self.scrollView viewWithTag:kBRCBoxViewOriginTag + i];
        if ([boxView isKindOfClass:[BRCBoxView class]]) {
            [self _setBoxViewTextWithIndex:i];
            if (CGRectEqualToRect(boxView.frame, CGRectZero)) {
                boxView.frame = CGRectMake(left, box_y, boxStandardWidth, boxStandardHeight);
            } else {
                [self animateWithBlock:^{
                    boxView.frame = CGRectMake(left, box_y, boxStandardWidth, boxStandardHeight);
                }];
            }
            left += boxStandardWidth;
            left += _boxSpace;
        }
    }
    self.boxContainerView.frame = CGRectMake(0, 0, left, self.frame.size.height);
    if (left <= self.frame.size.width) {
        if ([self _boxAlignment] == BRCBoxAlignmentCenter) {
            self.boxContainerView.center = self.scrollView.center;
        } else if ([self _boxAlignment] == BRCBoxAlignmentRight){
            self.boxContainerView.frame = CGRectMake(self.frame.size.width - left, 0, left, self.frame.size.height);
        }
    }
    self.scrollView.alwaysBounceHorizontal = left > self.scrollView.frame.size.width;
    [self.scrollView setScrollEnabled:left > self.scrollView.frame.size.width];
    self.scrollView.contentSize = CGSizeMake(MAX(left, self.frame.size.width), self.frame.size.height);
    self.scrollView.frame = self.bounds;
    if (self.caretView.frame.size.height == 0) {
        CGRect oldFrame = self.caretView.frame;
        BRCBoxView *currentInputBox = [self currentInputBox];
        _caretHeight = MAX(currentInputBox.frame.size.height / 2, 5);
        self.caretView.frame = CGRectMake(oldFrame.origin.x,
                                          oldFrame.origin.y,
                                          oldFrame.size.width,
                                          _caretHeight);
    }
}

#pragma mark - observer

- (void)_addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppWillEnterForegroundNot:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)_removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIApplicationWillEnterForegroundNotification];
}

#pragma mark - handler

- (void)handleAppWillEnterForegroundNot:(NSNotification *)notify {
    [self displayCaretViewAnimation:_isShowCaret];
}

#pragma mark - inputBox

- (BRCBoxView *)findInputBoxWithIndex:(NSInteger)index {
    if (index < _inputMaxLength) {
        return [self.scrollView viewWithTag:kBRCBoxViewOriginTag + index];
    }
    return nil;
}

- (BRCBoxView *)currentInputBox {
    return [self findInputBoxWithIndex:[self currentInputIndex]];
}

- (BOOL)shouldDisplayCaretView {
    BOOL shouldDisplayCaretView = self.showCaret && _isShowCaret && self.caretView.alpha == 0 && _inputText.length < _inputMaxLength;
    if ([self.placeHolder isKindOfClass:[NSString class]] && self.placeHolder.length > 0) {
        return [self currentInputIndex] > self.placeHolder.length - 1 && shouldDisplayCaretView;
    }
    return shouldDisplayCaretView;
}

- (void)_updateInputContent {
    if ([_inputText isKindOfClass:[NSString class]]) {
        if (_inputText.length >= _inputMaxLength) {
            _inputText = [_inputText substringToIndex:_inputMaxLength];
            if (_autoDismissKeyBoardWhenFinishInput) {
                [self resignFirstResponder];
            } else {
                [self hideCaretView];
            }
        } else {
            _isShowCaret = YES;
            [self displayCaretViewAnimation:YES];
        }
        
        [self _updateStyles];
        
        BRCBoxView *fristEmptyContentBoxView = nil;
        for (NSInteger i = 0; i < _inputMaxLength; i ++) {
            [self _setBoxViewTextWithIndex:i];
            if (i >= _inputText.length && fristEmptyContentBoxView == nil) {
                fristEmptyContentBoxView = [self findInputBoxWithIndex:i];
            }
        }
        
        [self moveCaretViewToBoxView:fristEmptyContentBoxView];
    }
}

- (void)moveCaretViewToBoxView:(UIView *)boxView {
    if ([boxView isKindOfClass:[UIView class]]) {
        [self.scrollView scrollRectToVisible:CGRectInset(boxView.frame, 0, 0) animated:YES];
        CGRect rect = [boxView convertRect:boxView.bounds toView:self.scrollView];
        CGFloat caret_y = (rect.size.height - self->_caretHeight) / 2 + rect.origin.y;
        CGFloat caret_x = (rect.size.width - self->_caretWidth) / 2 + rect.origin.x;
        self.caretView.frame = CGRectMake(caret_x, caret_y,self->_caretWidth, self->_caretHeight);
        [self displayCaretViewAnimation:YES];
    }
}

- (void)showCaretView {
    _isShowCaret = YES;
    BRCBoxView *boxView = [self currentInputBox];
    if ([boxView isKindOfClass:[BRCBoxView class]]) {
        [self moveCaretViewToBoxView:boxView];
        [self displayCaretViewAnimation:YES];
    }
    [self _updateStyles];
    [self _updateLastBox];
    [self selectBoxCallBackWithIndex:[self currentInputIndex] isSelect:YES];
}

- (void)hideCaretView {
    _isShowCaret = NO;
    [self displayCaretViewAnimation:NO];
    [self _updateLayout];
    [self _updateStyles];
    [self _updateLastBox];
}

- (void)displayCaretViewAnimation:(BOOL)isShow {
    if (isShow && [self shouldDisplayCaretView]) {
        // show
        if (![self.caretView.layer.animationKeys containsObject:@"blinkAnimation"]) {
            [self.caretView.layer addAnimation:[self createBlinkAnimation] forKey:@"blinkAnimation"];
        }
    } else {
        // hide
        [self.caretView.layer removeAnimationForKey:@"blinkAnimation"];
        self.caretView.alpha = 0;
    }
}

#pragma mark - UITextInput

@synthesize selectedTextRange = _selectedTextRange;
@synthesize markedTextRange = _markedTextRange;
@synthesize markedTextStyle = _markedTextStyle;
@synthesize inputDelegate = _inputDelegate;
@synthesize tokenizer = _tokenizer;
@synthesize textInputView = _textInputView;
@synthesize secureTextEntry = _secureTextEntry;
@synthesize textContentType = _textContentType;
@synthesize keyboardType = _keyboardType;

- (void)setSecureTextEntry:(BOOL)secureTextEntry {
    _secureTextEntry = secureTextEntry;
    NSMutableArray *array = [NSMutableArray array];
    [_boxStyles enumerateObjectsUsingBlock:^(BRCBoxStyle * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BRCBoxStyle *style = [BRCBoxStyle defaultStyle];
        if ([obj isKindOfClass:[BRCBoxStyle class]]) {
            style = obj;
            if (style.secretView == nil) {
                style.secretView = ^UIView * _Nonnull{
                    return [self createDefaultSecretImageView];
                };
            }
        }
        [array addObject:style];
    }];
    [_boxStyles removeAllObjects];
    _boxStyles = [array mutableCopy];
    [self _updateStyles];
}

- (BRCTextPosition *)beginningOfDocument {
    return [[BRCTextPosition alloc] init];
}

- (BRCTextPosition *)endOfDocument {
    return [[BRCTextPosition alloc] initWithOffset:self.inputText.length affinity:BRCTextAffinityForward];
}

- (UITextStorageDirection)selectionAffinity {
    if (_selectedTextRange.end.affinity == BRCTextAffinityBackward) {
        return UITextStorageDirectionBackward;
    }
    return UITextStorageDirectionForward;
}

- (BRCTextRange *)textRangeFromPosition:(BRCTextPosition *)fromPosition toPosition:(BRCTextPosition *)toPosition {
    return [[BRCTextRange alloc] initWithStartPosition:fromPosition endPosition:toPosition];
}

- (BRCTextPosition *)positionFromPosition:(BRCTextPosition *)position offset:(NSInteger)offset {
    if (position.affinity == BRCTextAffinityForward) {
        return [[BRCTextPosition alloc] initWithOffset:position.offset + offset affinity:BRCTextAffinityForward];
    } else {
        return [[BRCTextPosition alloc] initWithOffset:position.offset - offset affinity:BRCTextAffinityBackward];
    }
}

- (BRCTextPosition *)positionFromPosition:(BRCTextPosition *)position inDirection:(UITextLayoutDirection)direction offset:(NSInteger)offset {
    if (position.affinity == BRCTextAffinityForward) {
        return [[BRCTextPosition alloc] initWithOffset:position.offset + offset affinity:BRCTextAffinityForward];
    } else {
        return [[BRCTextPosition alloc] initWithOffset:position.offset - offset affinity:BRCTextAffinityBackward];
    }
}

- (NSComparisonResult)comparePosition:(BRCTextPosition *)position toPosition:(BRCTextPosition *)other {
    return [position compare:other];
}

- (NSInteger)offsetFromPosition:(BRCTextPosition *)from toPosition:(BRCTextPosition *)toPosition {
    if (from.affinity == toPosition.affinity) {
        if (from.affinity == BRCTextAffinityForward) {
            return from.offset - toPosition.offset;
        } else {
            return toPosition.offset - from.offset;
        }
    } else {
        return from.offset + toPosition.offset;
    }
}

- (BRCTextPosition *)positionWithinRange:(BRCTextRange *)range farthestInDirection:(UITextLayoutDirection)direction {
    NSRange vaildRange = range.vaildRange;
    if (direction == UITextLayoutDirectionLeft ||
        direction == UITextLayoutDirectionUp) {
        return [BRCTextPosition positionWithOffset:vaildRange.location];
    } else {
        return [BRCTextPosition positionWithOffset:vaildRange.location + vaildRange.length affinity:BRCTextAffinityBackward];
    }
}

- (BRCTextRange *)characterRangeByExtendingPosition:(BRCTextPosition *)position inDirection:(UITextLayoutDirection)direction {
    return [[BRCTextRange alloc] initWithStartPosition:position offset:1];
}

- (BRCTextPosition *)closestPositionToPoint:(CGPoint)point {
    return [[BRCTextPosition alloc] initWithOffset:[self findClosestBoxWithPointX:point.x] affinity:BRCTextAffinityForward];
}

- (BRCTextPosition *)closestPositionToPoint:(CGPoint)point withinRange:(BRCTextRange *)range {
    BRCTextPosition *start = range.start;
    BRCTextPosition *end = range.end;
    NSInteger i = [self findClosestBoxWithPointX:point.x];
    if (labs(start.offset - i) < labs(end.offset - i)) {
        return start;
    }
    return end;
}

- (BRCTextRange *)characterRangeAtPoint:(CGPoint)point {
    NSInteger i = [self findClosestBoxWithPointX:point.x];
    BRCTextPosition *start = [[BRCTextPosition alloc] initWithOffset:i-1 affinity:BRCTextAffinityForward];
    BRCTextPosition *end = [[BRCTextPosition alloc] initWithOffset:i affinity:BRCTextAffinityForward];
    return [[BRCTextRange alloc] initWithStartPosition:start endPosition:end];
}

- (void)setMarkedText:(NSString *)markedText
        selectedRange:(NSRange)selectedRange {
    if ([markedText isKindOfClass:[NSString class]]) {
        _markedText = markedText;
        if ([_inputText isKindOfClass:[NSString class]]) {
            _inputText = [_inputText stringByAppendingString:_markedText];
        } else {
            _inputText = markedText;
        }
    }
    _selectedTextRange = [[BRCTextRange alloc] initWithRange:selectedRange];
    [self _updateInputContent];
}

- (void)unmarkText {
    _markedText = @"";
    _selectedTextRange = nil;
}

- (NSString *)textInRange:(BRCTextRange *)range {
    if ([self hasText] &&
        [range isKindOfClass:[BRCTextRange class]] &&
        [range isVaild] &&
        range.end.offset <= _inputText.length) {
        NSRange textRange = NSMakeRange(range.start.offset, range.end.offset - range.start.offset);
        return [_inputText substringWithRange:textRange];
    }
    return @"";
}

- (void)replaceRange:(BRCTextRange *)range
            withText:(NSString *)text {
    if ([text isKindOfClass:[NSString class]] &&
        [range isKindOfClass:[BRCTextRange class]] &&
        [range isVaild]) {
        if (range.end.offset <= _inputText.length) {
            NSRange textRange = NSMakeRange(range.start.offset, range.end.offset - range.start.offset);
            _inputText = [_inputText stringByReplacingCharactersInRange:textRange withString:text];
        } else {
            if (range.start.offset <= _inputText.length) {
                NSRange replaceRange = NSMakeRange(range.start.offset, _inputText.length - range.start.offset);
                NSString *replaceText = [text substringToIndex:_inputText.length - range.start.offset];
                _inputText = [_inputText stringByReplacingCharactersInRange:replaceRange withString:replaceText];
                NSRange appendRange = NSMakeRange(_inputText.length - range.start.offset + 1, text.length);
                NSString *appendText = [text substringWithRange:appendRange];
                _inputText = [_inputText stringByAppendingString:appendText];
            } else {
                _inputText = [_inputText stringByAppendingString:text];
            }
        }
    }
}

- (NSWritingDirection)baseWritingDirectionForPosition:(BRCTextPosition *)position inDirection:(UITextStorageDirection)direction {return NSWritingDirectionNatural;}
- (void)setBaseWritingDirection:(NSWritingDirection)writingDirection forRange:(UITextRange *)range {}
- (CGRect)firstRectForRange:(BRCTextRange *)range {return CGRectZero;}
- (CGRect)caretRectForPosition:(BRCTextPosition *)position {return CGRectZero;}
- (NSArray<UITextSelectionRect *> *)selectionRectsForRange:(BRCTextRange *)range {return @[];}

#pragma mark - UIKeyInput

- (BOOL)hasText {
    return [_inputText isKindOfClass:[NSString class]] &&
    _inputText.length > 0;
}

- (void)excuteUpdateText:(void (^)(void))updateBlock {
    if (self.inputDelegate && [self.inputDelegate respondsToSelector:@selector(textWillChange:)]) {
        [self.inputDelegate textWillChange:self];
    }
    NSString *oldInputText = self.inputText;
    if (updateBlock) updateBlock();
    [self singleExecute:^{
        [self _updateInputContent];
        [self diffWithInputText:self.inputText old:oldInputText];
    }];
    if (self.inputDelegate && [self.inputDelegate respondsToSelector:@selector(textDidChange:)]) {
        [self.inputDelegate textDidChange:self];
    }
}

- (void)insertText:(NSString *)text {
    if (![text isEqualToString:@""] && ![self isNotBlankString:text]) {
        return;
    }
    [self excuteUpdateText:^{
        if ([self.inputText isKindOfClass:[NSString class]]) {
            self->_inputText = [self.inputText stringByAppendingString:text];
        } else {
            self->_inputText = text;
        }
    }];
}

- (void)deleteBackward {
    [self excuteUpdateText:^{
        if ([self hasText]) {
            self->_inputText = [self.inputText substringWithRange:NSMakeRange(0, self.inputText.length - 1)];
        }
    }];
}

#pragma mark - responder

- (BOOL)canBecomeFocused {
    return YES;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    BOOL becomeFirstResponder = [super becomeFirstResponder];
    [self showCaretView];
    return becomeFirstResponder;
}

- (BOOL)resignFirstResponder {
    BOOL resignFirstResponder = [super resignFirstResponder];
    [self hideCaretView];
    return resignFirstResponder;
}

#pragma mark - props

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeNone;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.clipsToBounds = NO;
    }
    return _scrollView;
}

- (UIView *)caretView {
    if (!_caretView) {
        _caretView = [[UIView alloc] init];
        _caretView.backgroundColor = [UIColor systemPinkColor];
        _caretView.alpha = 0;
    }
    return _caretView;
}

- (UIView *)boxContainerView {
    if (!_boxContainerView) {
        _boxContainerView = UIView.new;
    }
    return _boxContainerView;
}

- (BRCBoxAlignment)_boxAlignment {
    if (self.isRTL) {
        if (_alignment == BRCBoxAlignmentLeft) {
            return BRCBoxAlignmentRight;
        } else if (_alignment == BRCBoxAlignmentRight) {
            return BRCBoxAlignmentLeft;
        }
    }
    return _alignment;
}

- (UIImageView *)createDefaultSecretImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.tag = 101;
    [imageView setImage:[UIImage systemImageNamed:@"lock.fill"]];
    imageView.tintColor = [UIColor blackColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
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

- (NSUInteger)currentInputIndex {
    NSUInteger index = 0;
    if ([_inputText isKindOfClass:[NSString class]]) {
        index = _inputText.length;
        if (_inputText.length == _inputMaxLength) {
            index -= 1;
        }
    }
    return index;
}

- (NSUInteger)inputMaxLength {
    return _inputMaxLength;
}

#pragma mark - util

- (void)animateWithBlock:(void (^)(void))block {
    [UIView animateWithDuration:_selectTransitionDuration animations:block];
}

- (void)singleExecute:(void (^)(void))block {
    if (self.workBlock) {
        dispatch_block_cancel(self.workBlock);
    }
    
    self.workBlock = dispatch_block_create(0, ^{
        if (block) block();
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), self.workBlock);
}

- (void)selectBoxCallBackWithIndex:(NSInteger)index isSelect:(BOOL)isSelect{
    BRCBoxView *boxView = [self findInputBoxWithIndex:index];
    if (self.inputDelegate && [boxView isKindOfClass:[BRCBoxView class]]) {
        if (isSelect && [self.inputDelegate respondsToSelector:@selector(selectInputBox:withIndex:inputView:)]) {
            [self.inputDelegate selectInputBox:boxView withIndex:index inputView:self];
        } else if ([self.inputDelegate respondsToSelector:@selector(unSelectInputBox:withIndex:inputView:)] ) {
            [self.inputDelegate unSelectInputBox:boxView withIndex:index inputView:self];
        }
    }
}

- (NSInteger)findClosestBoxWithPointX:(CGFloat)pointX {
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < _inputMaxLength; i++) {
        BRCBoxView *box = [self findInputBoxWithIndex:i];
        if ([box isKindOfClass:[BRCBoxView class]]) {
            [array addObject:@(fabs(box.frame.origin.x - pointX))];
        } else {
            [array addObject:@(fabs(0 - pointX))];
        }
    }
    NSNumber *closeObject = [array sortedArrayUsingComparator:^NSComparisonResult(NSNumber *_Nonnull obj1, NSNumber *_Nonnull obj2) {
        return [obj1 compare:obj2];
    }].firstObject;
    return [array indexOfObject:closeObject];
}

- (BOOL)isNotBlankString:(NSString *)string {
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < string.length; ++i) {
        unichar c = [string characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}

- (void)diffWithInputText:(NSString *)newInputText old:(NSString *)oldInputText{
    NSInteger oldInputIndex = 0;
    NSInteger newInputIndex = 0;
    if ([newInputText isKindOfClass:[NSString class]]) {
        newInputIndex = newInputText.length;
    }
    if ([oldInputText isKindOfClass:[NSString class]]) {
        oldInputIndex = oldInputText.length;
    }
    [self selectBoxCallBackWithIndex:newInputIndex isSelect:YES];
    for (NSInteger i = MIN(oldInputIndex, newInputIndex); i < MAX(oldInputIndex, newInputIndex); i++) {
        [self selectBoxCallBackWithIndex:i isSelect:NO];
    }
}

@end
