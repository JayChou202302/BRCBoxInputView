//
//  BRCVerifyCodeView.h
//  ClothStore
//
//  Created by sunzhixiong on 2023/12/2.
//
/**
 * BRCBoxInputView is a customizable input view that conforms to the UITextInput protocol.
 * It provides various options for text input customization, including keyboard appearance,
 * text autocorrection, smart quotes, and more. The view also supports custom caret styles,
 * box alignment, and input length constraints. Additionally, it offers the ability to handle
 * menu actions like copy, paste, cut, and delete, and includes features for handling the
 * first responder status and custom input events. BRCBoxInputView is designed to offer a
 * flexible and user-friendly text input experience, suitable for a wide range of applications.
 */

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class BRCBoxView,BRCBoxInputView;

typedef NS_ENUM(NSInteger, BRCBoxAlignment) {
    BRCBoxAlignmentLeft,      // Align box to the left
    BRCBoxAlignmentCenter,    // Align box to the center
    BRCBoxAlignmentRight      // Align box to the right
};

@protocol BRCBoxInputViewDelegate <UITextInputDelegate>

@optional
- (void)copyText:(NSString *)text inputView:(BRCBoxInputView *)inputView;    // Called when text is copied
- (void)pasteText:(NSString *)text inputView:(BRCBoxInputView *)inputView;   // Called when text is pasted
- (void)cutText:(NSString *)text inputView:(BRCBoxInputView *)inputView;     // Called when text is cut
- (void)deleteText:(NSString *)text inputView:(BRCBoxInputView *)inputView;  // Called when text is deleted

@optional
- (void)selectInputBox:(BRCBoxView *)boxView withIndex:(NSInteger)index inputView:(BRCBoxInputView *)inputView;   // Called when an input box is selected
- (void)unSelectInputBox:(BRCBoxView *)boxView withIndex:(NSInteger)index inputView:(BRCBoxInputView *)inputView; // Called when an input box is unselected

@end

@interface BRCBoxStyle : NSObject<NSCopying>

/**
 * Background color of the box
 * default is `[UIColor whiteColor]`
 */
@property (nonatomic, strong) UIColor *backgroundColor;

/**
 * Border color of the box
 * default is `[UIColor blackColor]`
 */
@property (nonatomic, assign) UIColor *borderColor;

/**
 * Font of the label
 * default is  `[UIFont boldSystemFontOfSize:18.0]`
 */
@property (nonatomic, strong) UIFont  *labelFont;

/**
 * Color of the label
 * default is `[UIColor blackColor]`
 */
@property (nonatomic, strong) UIColor *labelColor;

/**
 * Font of the placeholder
 * default is `[UIFont systemFontOfSize:13.0]`
 */
@property (nonatomic, strong) UIFont  *placeHolderFont;

/**
 * Color of the placeholder
 * default is `[UIColor grayColor]`
 */
@property (nonatomic, strong) UIColor *placeHolderColor;

/**
 * Shadow color of the box
 * default is `nil`
 */
@property (nonatomic, strong) UIColor *shadowColor;

/**
 * Radius of the shadow
 * default is `0`
 */
@property (nonatomic, assign) CGFloat shadowRadius;

/**
 * Offset of the shadow
 * default is `CGSizeZero`
 */
@property (nonatomic, assign) CGSize  shadowOffset;

/**
 * Delay before displaying the secret view
 * default is `0.2`
 */
@property (nonatomic, assign) NSTimeInterval secretDisplayDelay;

/**
 * Width of the border
 * default is `1.0`
 */
@property (nonatomic, assign) CGFloat borderWidth;

/**
 * Radius of the corners
 * default is `5.0`
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 * Size of the box
 * default is `CGSizeMake(60, 60)`
 */
@property (nonatomic, assign) CGSize  boxSize;

/**
 * Block returning a custom secret view
 * default is `nil`
 */
@property (nonatomic, copy, nullable) UIView *(^secretView)(void);

/**
 * Block returning a custom view
 * default is `nil`
 */
@property (nonatomic, copy, nullable) UIView *(^customView)(BRCBoxView *boxView);

+ (instancetype)defaultStyle;          // Default style of the box
+ (instancetype)defaultSelectStyle;    // Default style when the box is selected
+ (instancetype)lineBoxStyle;          // Line style of the box
+ (instancetype)selectLineBoxStyle;    // Line style when the box is selected

@end

@interface BRCBoxView : UIView

/**
 * Indicates whether the box is selected
 * default is `NO`
 */
@property (nonatomic, assign, readonly) BOOL isSelect;

/**
 * Indicates whether the box is not empty
 * default is `NO`
 */
@property (nonatomic, assign, readonly) BOOL isNotEmpty;

@end

@interface BRCBoxInputView : UIView <UITextInput>

#pragma mark - UITextInput

/**
 * The delegate for handling input events
 * default is `nil`
 */
@property (nonatomic, weak) id<BRCBoxInputViewDelegate> inputDelegate;

#pragma mark - UITextInputTraits

/**
 * Controls whether text should be auto-capitalized
 * default is `UITextAutocapitalizationTypeNone`
 */
@property(nonatomic) UITextAutocapitalizationType autocapitalizationType;

/**
 * Controls whether text should be auto-corrected
 * default is `UITextAutocorrectionTypeDefault`
 */
@property(nonatomic) UITextAutocorrectionType autocorrectionType;

/**
 * Controls whether text should be spell-checked
 * default is `UITextSpellCheckingTypeDefault`
 */
@property(nonatomic) UITextSpellCheckingType spellCheckingType;

/**
 * Controls whether smart quotes should be used
 * default is `UITextSmartQuotesTypeDefault`
 */
@property(nonatomic) UITextSmartQuotesType smartQuotesType;

/**
 * Controls whether smart dashes should be used
 * default is `UITextSmartDashesTypeDefault`
 */
@property(nonatomic) UITextSmartDashesType smartDashesType;

/**
 * Controls whether smart insert/delete should be used
 * default is `UITextSmartInsertDeleteTypeDefault`
 */
@property(nonatomic) UITextSmartInsertDeleteType smartInsertDeleteType;

/**
 * The type of keyboard to display
 * default is `UIKeyboardTypeDefault`
 */
@property(nonatomic) UIKeyboardType keyboardType;

/**
 * The appearance style of the keyboard
 * default is `UIKeyboardAppearanceDefault`
 */
@property(nonatomic) UIKeyboardAppearance keyboardAppearance;

/**
 * The return key type for the keyboard
 * default is `UIReturnKeyDefault`
 */
@property(nonatomic) UIReturnKeyType returnKeyType;

/**
 * Controls whether the return key is automatically enabled
 * default is `NO`
 */
@property(nonatomic) BOOL enablesReturnKeyAutomatically;

/**
 * The type of content the text input represents
 * default is `nil`
 */
@property(null_unspecified,nonatomic,copy) UITextContentType textContentType;

/**
 * The password rules for the text input
 * default is `nil`
 */
@property(nullable,nonatomic,copy) UITextInputPasswordRules *passwordRules;

#pragma mark - UIMenu

/**
 * Controls whether text can be copied
 * default is `YES`
 */
@property (nonatomic, assign) BOOL copyable;

/**
 * Controls whether text can be pasted
 * default is `YES`
 */
@property (nonatomic, assign) BOOL pasteable;

/**
 * Controls whether text can be cut
 * default is `YES`
 */
@property (nonatomic, assign) BOOL cutable;

/**
 * Controls whether text can be deleted
 * default is `YES`
 */
@property (nonatomic, assign) BOOL deleteable;

/**
 * Sets whether the text menu is enabled
 * @param menuable A Boolean value that determines whether the menu is enabled
 */
- (void)setMenuable:(BOOL)menuable;

#pragma mark - CaretStyle

/**
 * Controls whether the caret is shown
 * default is `YES`
 */
@property (nonatomic, assign) BOOL showCaret;

/**
 * The width of the caret
 * default is `1.0`
 */
@property (nonatomic, assign) CGFloat caretWidth;

/**
 * The height of the caret
 * default is the height of the text
 */
@property (nonatomic, assign) CGFloat caretHeight;

/**
 * The maximum opacity of the caret
 * default is `1.0`
 */
@property (nonatomic, assign) CGFloat caretMaxOpacity;

/**
 * The minimum opacity of the caret
 * default is `0.2`
 */
@property (nonatomic, assign) CGFloat caretMinOpacity;

/**
 * The duration of the caret blink animation
 * default is `0.5`
 */
@property (nonatomic, assign) NSTimeInterval blinkDuration;

#pragma mark - BoxStyle

/**
 * The space between boxes
 * default is `10.0`
 */
@property (nonatomic, assign) CGFloat boxSpace;

/**
 * The duration of the select transition animation
 * default is `0.2`
 */
@property (nonatomic, assign) NSTimeInterval selectTransitionDuration;

/**
 * The alignment of the boxes
 * default is `BRCBoxAlignmentCenter`
 */
@property (nonatomic, assign) BRCBoxAlignment alignment;

/**
 * Controls whether the keyboard is automatically dismissed when input is finished
 * default is `NO`
 */
@property (nonatomic, assign) BOOL autoDismissKeyBoardWhenFinishInput;

/**
 * Controls whether the box container is automatically filled
 * default is `YES`
 */
@property (nonatomic, assign) BOOL autoFillBoxContainer;

/**
 * Controls whether the text input is in right-to-left mode
 * default is `NO`
 */
@property (nonatomic, assign) BOOL isRTL;

/**
 * The placeholder text for the input
 * default is `nil`
 */
@property (nonatomic, strong) NSString *placeHolder;

/**
 * The current input text
 * default is `nil`
 */
@property (nonatomic, strong, nullable) NSString *inputText;

/**
 * The current input index
 * read-only
 */
@property (nonatomic, assign, readonly) NSUInteger currentInputIndex;

/**
 * The maximum length of the input
 * read-only
 */
@property (nonatomic, assign, readonly) NSUInteger inputMaxLength;

/**
 * A block that is called when the input view is clicked
 * default is `[self toggleFirstResponder]`
 */
@property (nonatomic, copy) void (^onClickInputViewBlock)(void);

/**
 * Sets the style for the box
 * @param style The style to set
 */
- (void)setBoxStyle:(BRCBoxStyle *)style;

/**
 * Sets the style for the box at a specific index
 * @param style The style to set
 * @param index The index of the box to style
 */
- (void)setBoxStyle:(BRCBoxStyle *)style forIndex:(NSUInteger)index;

/**
 * Sets the style for the selected box
 * @param selectStyle The style to set for the selected box
 */
- (void)setSelectBoxStyle:(BRCBoxStyle *)selectStyle;

/**
 * Toggles the first responder status
 */
- (void)toggleFirstResponder;

#pragma mark - init

/**
 * Initializes the input view with a specified length
 * @param length The length of the input
 * @return An initialized input view
 */
- (instancetype)initWithInputLength:(NSUInteger)length;

/**
 * Creates a new input view with a specified length
 * @param length The length of the input
 * @return A new input view
 */
+ (instancetype)boxInputWithLength:(NSUInteger)length;

@end


NS_ASSUME_NONNULL_END
