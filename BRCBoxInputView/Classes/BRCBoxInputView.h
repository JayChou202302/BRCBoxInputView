//
//  BRCBoxInputView.h
//  BRCBoxInputView
//
//  Created by sunzhixiong on 2023/12/2.
//
#import <UIKit/UIKit.h>
#import "BRCBoxInputViewConst.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 输入框的样式
 * The Style For Box
 */
@interface BRCBoxStyle : NSObject

@property (nonatomic, assign) CGSize          boxSize;
@property (nonatomic, assign) CGFloat         boxCornerRadius;
@property (nonatomic, assign) CGFloat         boxBorderWidth;
@property (nonatomic, assign) CGFloat         boxShadowRadius;
@property (nonatomic, assign) CGSize          boxShadowOffset;
@property (nonatomic, assign) CGSize          boxSecretImageSize;
@property (nonatomic, copy, nullable)   UIColor         *boxBackgroundColor;
@property (nonatomic, copy, nullable)   UIColor         *boxBorderColor;
@property (nonatomic, copy, nullable)   UIColor         *boxShadowColor;
@property (nonatomic, copy, nullable)   UIColor         *boxSecretImageColor;
@property (nonatomic, copy, nullable)   UIImage         *boxSecretImage;
@property (nonatomic, copy, nullable)   NSDictionary<NSAttributedStringKey,id>    *textAttributedDict;
@property (nonatomic, copy, nullable)   NSDictionary<NSAttributedStringKey,id>    *placeHolderAttributedDict;

+ (instancetype)defaultStyle;
+ (instancetype)defaultSelectedStyle;

@end

/**
 * 输入框基础视图
 * The BaseView For Box
 * @discussion 建议自定义视图的时候 继承该类 当然你
 * 也可以选择继承 `UICollectionViewCell` 但是必须
 * 要继承 `BRCBoxViewProtocol` 来实现一些功能
 *
 * @discussion It is recommended to inherit
 * this class when customizing the view. Of
 * course you You can also choose to inherit
 * `UICollectionViewCell` but must To inherit
 * `BRCBoxViewProtocol` to implement some functions
 */
@interface BRCBoxView : UICollectionViewCell <BRCBoxViewProtocol>
@property (nonatomic, assign) BOOL         isPlaceHolderText;
@property (nonatomic, strong) UILabel      *boxLabel;
@property (nonatomic, strong) UIImageView  *secretImageView;
@end

@interface BRCBoxInputView : UIView <UITextInput>

@property (nonatomic, weak)   id<BRCBoxInputViewDelegate>   delegate;
@property (nonatomic, assign) BOOL                          showCaret;
@property (nonatomic, assign) CGFloat                       boxSpace;
@property (nonatomic, assign) CGSize                        boxSize;
@property (nonatomic, assign) CGFloat                       caretWidth;
@property (nonatomic, assign) CGFloat                       caretHeight;
@property (nonatomic, assign) CGFloat                       caretMaxOpacity;
@property (nonatomic, assign) CGFloat                       caretMinOpacity;
@property (nonatomic, assign) NSTimeInterval                blinkDuration;
@property (nonatomic, assign) UIEdgeInsets                  contentInsets;
@property (nonatomic, strong) UIColor                       *caretTintColor;
@property (nonatomic, strong) BRCBoxStyle                   *boxStyle;
@property (nonatomic, strong) BRCBoxStyle                   *selectedBoxStyle;

/**
 * `UIMenuController` 可操作类型
 *  The MenuActions For UIMenuController
 *  defalt is `@[
 *  `@(BRCBoxMenuActionTypeDelete),
 *  `@(BRCBoxMenuActionTypeCut)`,
 *  `@(BRCBoxMenuActionTypePaste),
 *  `@(BRCBoxMenuActionTypeCopy)
 *  ]`
 *
 *  @discussion 你需要使用 `BRCBoxMenuActionType`
 *  枚举类型中的值来进行设置
 *
 *  @discussion You should use `BRCBoxMenuActionType`
 *  to set this array
 */
@property (nonatomic, strong) NSArray                        *menuActions;

/**
 * `UIMenuController` 弹出方向
 *  The Direction For `UIMenuController`
 *  default is `UIMenuControllerArrowDown`
 */
@property (nonatomic, assign) UIMenuControllerArrowDirection menuDirection;

/**
 * 输入框的最大输入长度
 * The Max InputLength For View
 * default is `5`
 * @discussion 当你在初始化后再设置改属性时，
 * 会导致视图的重绘制，所以请不要频繁设置改属性
 * 同时我们建议使用 `-initWithInputLength:`
 * 方法来设置改属性
 *
 * @discussion When you reset the properties
 * after initialization,It may cause redrawing
 * of the view, so please do not frequently
 * set the change attribute We also recommend
 * using ` - initWithInputLength:` Method to
 * set and modify attributes
 */
@property (nonatomic, assign) NSUInteger inputMaxLength;

/**
 * 输入框视图的 Class 类型
 * The BoxView Class
 * default is `BRCBoxView.Class`
 * @discussion 当你需要高度定制你的输入框视图的
 * 时候，你可以创建一个自定义的 BoxView，同时设置
 * 改属性为你自定义视图的Class
 *
 * @discussion When you need to highly 
 * customize your input box view At the same
 * time, you can create a custom BoxView and set it up
 * Change the attribute to the Class of your custom view
 */
@property (nonatomic, assign) Class boxViewClass;

/**
 * 输入的正则限制
 * Regular input restrictions
 * default is `nil`
 * @discussion 你可以使用该属性来完成对
 * 输入框内容的自定义限制
 *
 * @discussion You can use this attribute
 * to complete the task Custom limit
 * for input box content
 */
@property (nonatomic, strong) NSString *inputPattern;

/**
 * 加密输入时的渐出过渡时长
 * Gradual transition duration during encrypted input
 * default is `0.2`
 */
@property (nonatomic, assign) NSTimeInterval secureTransitionDuration;

/**
 * 加密输入时的加密视图延时时常
 * The delay of encrypted views during input encryption is often high
 * default is `0.2`
 */
@property (nonatomic, assign) NSTimeInterval secureDelayDuration;

/**
 * 输入框视图的对齐方式
 * The Alignment For InputView
 * default is `BRCBoxAlignmentCenter`
 */
@property (nonatomic, assign) BRCBoxAlignment alignment;

/**
 * 是否完成输入时自动消失键盘
 * Whether to automatically disappear the keyboard when typing is completed
 * default is `NO`
 */
@property (nonatomic, assign) BOOL autoDismissKeyBoardWhenFinishInput;

/**
 * 是否根据最大长度自动填满整个输入框视图(无需设置BoxSize)
 * Whether to automatically fill the entire input box view based on the maximum length (no need to set BoxSize)
 * default is `NO`
 */
@property (nonatomic, assign) BOOL autoFillBoxContainer;

/**
 * 占位符
 * The PlaceHolder For InputView
 * default is `nil`
 */
@property (nonatomic, strong) NSString *placeHolder;

/**
 * 点击视图的回调
 * CallBack For Click InputView
 * default is `[self toggleFirstResponder]`
 */
@property (nonatomic, copy) void (^onClickInputViewBlock)(void);

/**
 * 输入框的输入文本
 * The InputText For InputView
 */
@property (nonatomic, strong, nullable) NSString *text;

/**
 * 输入框当前所在的位置
 * The InputIndex For InputView
 */
@property (nonatomic, assign, readonly) NSUInteger currentInputIndex;

#pragma mark - reload

/**
 * 刷新视图
 * Reload Input View
 * @discussion 当你设置了某些属性但是发现没有生效
 * 的时候，可以调用该方法来完成视图的重绘和刷新
 * 建议不要频繁调用
 *
 * @discussion When you set certain properties
 * but find that they are not effective
 * When, this method can be called to complete
 * the redrawing and refreshing of the view
 * Suggest not calling frequently
 */
- (void)reloadView;
- (void)reloadBoxWithIndex:(NSInteger)index;

#pragma mark - init

- (instancetype)initWithInputLength:(NSUInteger)length;
+ (instancetype)boxInputWithLength:(NSUInteger)length;

#pragma mark - display

- (void)toggleFirstResponder;
- (void)hideMenu;
- (void)showMenu;


@end


NS_ASSUME_NONNULL_END
