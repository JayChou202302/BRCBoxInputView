//
//  BRCBoxInputViewConst.h
//  BRCBoxInputView
//
//  Created by sunzhixiong on 2024/8/6.
//

#ifndef BRCBoxInputViewConst_h
#define BRCBoxInputViewConst_h

typedef NS_ENUM(NSInteger, BRCBoxAlignment) {
    BRCBoxAlignmentLeft = 0,
    BRCBoxAlignmentCenter = 2,
    BRCBoxAlignmentRight = 1
};

typedef NS_ENUM(NSInteger, BRCBoxMenuActionType) {
    BRCBoxMenuActionTypeCopy = 1,
    BRCBoxMenuActionTypeDelete,
    BRCBoxMenuActionTypePaste,
    BRCBoxMenuActionTypeCut,
};

typedef NS_ENUM(NSUInteger, BRCBoxFocusScrollPosition) {
    BRCBoxFocusScrollPositionLeft = 1 << 3,
    BRCBoxFocusScrollPositionRight = 1 << 5,
    BRCBoxFocusScrollPositionCenter = 1 << 4
};

@class BRCBoxInputView,BRCBoxStyle,BRCBoxView;

/**
 * 输入框视图的协议
 * The protocol for box view
 * @discussion 当你需要高度自定义自己的输入视图的时候
 * 你需要保证你的类继承该协议，同时对协议中的方法进行实现，
 * 下面的方法都是非必需实现的方法，你可以自行根据需要进行实现
 *
 * @discussion When you need to highly customize
 * your input view,You need to ensure that your
 * class inherits the protocol and implements the
 * methods in the protocol.The following methods
 * are not simple to implement. You can implement 
 * them according to your needs.
 */
@protocol BRCBoxViewProtocol
@optional
@property (nonatomic, assign, readonly) BOOL isNotEmpty;
@property (nonatomic, assign, readonly) BOOL isBoxSelected;
- (void)setSecureTextEntry:(BOOL)secureTextEntry withDuration:(CGFloat)duration delay:(CGFloat)delay;
- (void)didSelectInputBox;
- (void)didUnSelectInputBox;
- (void)setBoxText:(NSString *)text;
- (void)setBoxPlaceHolder:(NSString *)placeHolder;
- (void)setBoxStyle:(BRCBoxStyle *)boxStyle;
@end

@protocol BRCBoxInputViewDelegate <NSObject>

@optional

/**
 * 编辑按钮事件的回调
 * CallBack For MenuAction
 */
- (void)copyText:(NSString *)text inInputView:(BRCBoxInputView *)inputView NS_SWIFT_NAME(copyText(text:_:));
- (void)pasteText:(NSString *)text inInputView:(BRCBoxInputView *)inputView NS_SWIFT_NAME(pasteText(text:_:));
- (void)cutText:(NSString *)text inInputView:(BRCBoxInputView *)inputView NS_SWIFT_NAME(cutText(text:_:));
- (void)deleteText:(NSString *)text inInputView:(BRCBoxInputView *)inputView NS_SWIFT_NAME(deleteText(text:_:));

/**
 * 输入框的样式
 * The Style For Boxs
 * @discussion 当你有对不同输入框有不同的样式需求的时候
 * 你可以实现该方法，通过判断 `boxView` 的状态给到不同的样式
 *
 * @discussion When you have different style
 * requirements for different input boxes You can
 * implement this method and give different styles
 * by judging the status of `boxView`
 */
- (BRCBoxStyle *)boxStyleWithIndex:(NSInteger)index withBoxView:(BRCBoxView *)boxView inInputView:(BRCBoxInputView *)inputView NS_SWIFT_NAME(boxStyleWithIndex(_:_:_:));

/**
 * 输入框的每一个自定义的输入视图
 * The BoxView For InputViews
 */
- (UIView<BRCBoxViewProtocol> *)boxWithIndex:(NSInteger)index inInputView:(BRCBoxInputView *)inputView NS_SWIFT_NAME(boxWithIndex(_:_:));

/**
 * 响应者的回调
 * Call Back For Responder
 */
- (void)didBecomeFirstResponderWithView:(BRCBoxInputView *)inputView NS_SWIFT_NAME(didBecomeFirstResponder(_:));
- (void)didResignFirstResponderWithView:(BRCBoxInputView *)inputView NS_SWIFT_NAME(didResignFirstResponder(_:));

/**
 * 输入框显示的回调
 * The Display CallBack For Boxs
 */
- (void)willDisplayBox:(BRCBoxView *)boxView withIndex:(NSInteger)index inInputView:(BRCBoxInputView *)inputView NS_SWIFT_NAME(willDisplayBox(_:_:_:));
- (void)didEndDisplayBox:(BRCBoxView *)boxView withIndex:(NSInteger)index inInputView:(BRCBoxInputView *)inputView NS_SWIFT_NAME(didEndDisplayBox(_:_:_:));

/**
 * 选中/非选中输入框事件的回调
 * Callback for selected/unselected input box events
 */
- (void)willSelectInputBox:(BRCBoxView *)boxView withIndex:(NSInteger)index inInputView:(BRCBoxInputView *)inputView NS_SWIFT_NAME(willSelectInputBox(_:_:_:));
- (void)didSelectInputBox:(BRCBoxView *)boxView withIndex:(NSInteger)index inInputView:(BRCBoxInputView *)inputView NS_SWIFT_NAME(didSelectInputBox(_:_:_:));
- (void)willUnSelectInputBox:(BRCBoxView *)boxView withIndex:(NSInteger)index inInputView:(BRCBoxInputView *)inputView NS_SWIFT_NAME(willUnSelectInputBox(_:_:_:));
- (void)didUnSelectInputBox:(BRCBoxView *)boxView withIndex:(NSInteger)index inInputView:(BRCBoxInputView *)inputView NS_SWIFT_NAME(didUnSelectInputBox(_:_:_:));
- (BOOL)boxInputViewShouldReturn:(BRCBoxInputView *)inputView NS_SWIFT_NAME(boxInputViewShouldReturn(_:));


/**
 * 文本改变事件回调
 * Callback for textchange
 */
- (void)boxTextWillChange:(BRCBoxInputView *)inputView;
- (void)boxTextDidChange:(BRCBoxInputView *)inputView;

@end

#endif /* BRCBoxInputViewConst_h */
