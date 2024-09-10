//
//  BRCBoxInputViewWrapper.swift
//  BRCBoxInputView
//
//  Created by sunzhixiong on 2024/8/15.
//

import SwiftUI
import UIKit

// MARK: Public

public protocol BRCBoxProtocol  {
    var isNotEmpty: Bool { get }
    var isBoxSelected: Bool { get }
    func setSecureTextEntry(_ secureTextEntry: Bool, withDuration duration: CGFloat, delay: CGFloat)
    func didSelectInputBox()
    func didUnSelectInputBox()
    func setBoxText(_ text: String)
    func setBoxPlaceHolder(_ placeHolder: String)
    func setBoxStyle(_ boxStyle: BRCBoxStyle)
}

public extension BRCBoxProtocol {
    var isNotEmpty: Bool { return false }
    var isBoxSelected: Bool { return false }
    func setSecureTextEntry(_ secureTextEntry: Bool, withDuration duration: CGFloat, delay: CGFloat) { }
    func didSelectInputBox() { }
    func didUnSelectInputBox() { }
    func setBoxText(_ text: String) { }
    func setBoxPlaceHolder(_ placeHolder: String) {}
    func setBoxStyle(_ boxStyle: BRCBoxStyle) {}
}

public struct BRCBox : View,BRCBoxProtocol {
    public var body: some View {
        Text("BRCBox")
    }
}

public struct BRCBoxInput<BRCBoxContent:View & BRCBoxProtocol> : UIViewRepresentable{
    public typealias Context = UIViewRepresentableContext<Self>
    public typealias UIViewType = BRCBoxInputView
    var delegate : BRCBoxInputDelegateObject = BRCBoxInputDelegateObject()
    var boxView  : ((Int,Bool,CGSize) -> BRCBoxContent)?
    @Binding var params : BRCBoxInputParameters
    @Binding public var isFocus : Bool
    @Binding public var text : String
    
    public init(text: Binding<String>,isFocus: Binding<Bool>) {
        self._text = text
        self._isFocus = isFocus;
        self._params = Binding.constant(BRCBoxInputParameters())
    }
    
    private func setUpDelegate() {
        delegate.boxViewWithIndex = { index,isSelect,boxSize in
            if (self.boxView != nil) {
                let view : BRCBoxContent  = self.boxView!(index,isSelect,boxSize);
                let uiView = BRCCustomSwiftUIBoxView<BRCBoxContent>(swiftUIView: view);
                return uiView;
            }
            return nil;
        }
        delegate.boxInputViewShouldReturn = {
            return isFocus;
        };
        delegate.boxStyleWithIndex = { index,isSelect in
            return params.boxStyleWithIndex?(index,isSelect)
        }
        delegate.boxTextDidChangeSubject = { newText in
            DispatchQueue.main.async {
                text = newText;
            }
        }
        delegate.copyTextSubject = { copyText in
            params.didCopyTextFromPasteboard?(copyText)
        }
        delegate.deleteTextSubject = { deleteText in
            params.didDeleteTextFromPasteboard?(deleteText)
        }
        delegate.pasteTextSubject = { pasteText in
            params.didPasteTextFromPasteboard?(pasteText)
        }
        delegate.cutTextSubject = { cutText in
            params.didCutTextFromPasteboard?(cutText)
        }
        delegate.didChangeFocusStateSubject = { isFirstResponder in
            DispatchQueue.main.async {
                isFocus = isFirstResponder;
            }
        }
        delegate.willDisplayBoxSubject = { index in
            params.willDisplayBoxBlock?(index)
        }
        delegate.didEndDisplayBoxSubject = { index in
            params.didEndDisplayBoxBlock?(index)
        }
        delegate.willSelectInputBoxSubject = { index in
            params.willSelectBoxBlock?(index)
        }
        delegate.willUnSelectInputBoxSubject = { index in
            params.willUnSelectBoxBlock?(index)
        }
        delegate.didSelectInputBoxSubject = { index in
            params.didSelectBoxBlock?(index)
        }
        delegate.didUnSelectInputBoxSubject = { index in
            params.didUnSelectBoxBlock?(index)
        }
    }
    
    public func makeUIView(context: Context) -> BRCBoxInputView {
        let boxInputView = BRCBoxInputView(inputLength: params.inputMaxLength);
        boxInputView.delegate = delegate;
        setUpDelegate()
        return boxInputView;
    }
    
    func isNeedUpdateView(_ view : BRCBoxInputView) -> Bool {
        // 一切涉及到内部 CollectionView 的属性发生改变都需要update
        if (view.inputMaxLength != params.inputMaxLength) {return true;}
        if (view.boxSpace != params.boxSpace) {return true;}
        if (view.boxSize != params.boxSize)   {return true;}
        if (view.boxStyle != params.boxStyle)   {return true;}
        if (view.selectedBoxStyle != params.selectedBoxStyle)  {return true;}
        if (view.contentInsets != params.contentInsets) {return true;}
        if (view.autoFillBoxContainer != params.autoFillBoxContainer) {return true;}
        if (view.alignment != params.alignment)  {return true;}
        if (view.placeHolder != params.placeHolder)  {return true;}
        return false;
    }
    
    public func updateUIView(_ uiView: BRCBoxInputView, context: Context) {
        let isNeedUpdateView = isNeedUpdateView(uiView);
        uiView.text = text;
        uiView.inputMaxLength = params.inputMaxLength;
        uiView.boxStyle = params.boxStyle;
        uiView.selectedBoxStyle = params.selectedBoxStyle;
        uiView.showCaret = params.showCaret;
        uiView.boxSpace = params.boxSpace;
        uiView.boxSize = params.boxSize;
        uiView.menuDirection = params.menuDirection;
        uiView.contentInsets = params.contentInsets;
        uiView.autoFillBoxContainer = params.autoFillBoxContainer;
        uiView.caretTintColor = params.caretTintColor;
        if (params.onClickInputViewBlock != nil) {
            uiView.onClickInputViewBlock = params.onClickInputViewBlock!;
        }
        uiView.alignment = params.alignment;
        uiView.placeHolder = params.placeHolder ?? "";
        uiView.autoDismissKeyBoardWhenFinishInput = params.autoDismissKeyBoardWhenFinishInput;
        uiView.secureTransitionDuration = params.secureTransitionDuration;
        uiView.secureDelayDuration = params.secureDelayDuration;
        uiView.blinkDuration = params.blinkDuration;
        uiView.caretMaxOpacity = params.caretMaxOpacity;
        uiView.caretMinOpacity = params.caretMinOpacity;
        uiView.caretWidth = params.caretWidth;
        uiView.caretHeight = params.caretHeight;
        uiView.menuActions = params.menuActions;
        uiView.keyboardType = params.keyboardType;
        uiView.textContentType = params.textContentType;
        uiView.isSecureTextEntry = params.secureTextEntry;
        uiView.returnKeyType = params.returnKeyType;
        uiView.focusScrollPosition = params.focusScrollPosition;
        DispatchQueue.main.async {
            if (isFocus) {
                uiView.becomeFirstResponder();
            } else {
                uiView.resignFirstResponder();
            }
            if (isNeedUpdateView) {
                uiView.reload();
            }
        }

    }
}

public struct BRCBoxInputParameters {
    var inputPattern                       : String?;
    var placeHolder                        : String?;
    var boxStyle                           : BRCBoxStyle = BRCBoxStyle.default();
    var selectedBoxStyle                   : BRCBoxStyle = BRCBoxStyle.defaultSelected();
    var alignment                          : BRCBoxAlignment = .center;
    var focusScrollPosition                : BRCBoxFocusScrollPosition = .center;
    var autoDismissKeyBoardWhenFinishInput : Bool = false;
    var secureTextEntry                    : Bool = false;
    var isDismissKeyBoardWhenClickReturn   : Bool = false;
    var autoFillBoxContainer               : Bool = false;
    var showCaret                          : Bool = true;
    var inputMaxLength                     : UInt = 6;
    var boxSpace                           : CGFloat = 10.0;
    var secureTransitionDuration           : CGFloat = 0.2;
    var secureDelayDuration                : CGFloat = 0.2;
    var blinkDuration                      : CGFloat = 0.5;
    var caretMaxOpacity                    : CGFloat = 1.0;
    var caretMinOpacity                    : CGFloat = 0.2;
    var caretWidth                         : CGFloat = 1;
    var caretHeight                        : CGFloat = 0;
    var boxSize                            : CGSize = .init(width: 60, height: 60);
    var menuDirection                      : UIMenuController.ArrowDirection = .down;
    var contentInsets                      : UIEdgeInsets = .zero;
    var caretTintColor                     : UIColor = .systemPink;
    var keyboardType                       : UIKeyboardType = .numberPad;
    var textContentType                    : UITextContentType = .oneTimeCode;
    var returnKeyType                      : UIReturnKeyType = .default;
    var menuActions                        : [NSNumber] = [
        .init(integerLiteral: BRCBoxMenuActionType.delete.rawValue),
        .init(integerLiteral: BRCBoxMenuActionType.cut.rawValue),
        .init(integerLiteral: BRCBoxMenuActionType.paste.rawValue),
        .init(integerLiteral: BRCBoxMenuActionType.copy.rawValue)
    ]
    var boxStyleWithIndex                  : ((UInt,Bool) -> BRCBoxStyle)?
    var onClickInputViewBlock              : (() -> Void)?;
    var didCopyTextFromPasteboard          : ((String) -> Void)?;
    var didPasteTextFromPasteboard         : ((String) -> Void)?;
    var didCutTextFromPasteboard           : ((String) -> Void)?;
    var didDeleteTextFromPasteboard        : ((String) -> Void)?;
    var willDisplayBoxBlock                : ((Int) -> Void)?;
    var didEndDisplayBoxBlock              : ((Int) -> Void)?;
    var didSelectBoxBlock                  : ((Int) -> Void)?;
    var didUnSelectBoxBlock                : ((Int) -> Void)?;
    var willSelectBoxBlock                 : ((Int) -> Void)?;
    var willUnSelectBoxBlock               : ((Int) -> Void)?;
}

public extension BRCBoxInput {
    private func updateParams(_ block : ((inout BRCBoxInputParameters) -> Void)) -> some View {
        var input = self;
        var params = input.params;
        block(&params);
        input._params = Binding.constant(params);
        return input;
    }
    /// Set the input box length / 输入框长度
    func inputLength(_ length : UInt) -> some View{
        return updateParams { params in
            params.inputMaxLength = length;
        };
    }

    /// Set the style for the Nth input box / 第N个输入框的样式
    func boxStyleWithIndex(_ block : @escaping ((UInt,Bool) -> BRCBoxStyle)) -> some View {
        return updateParams { params in
            params.boxStyleWithIndex = block;
        };
    }

    /// Set the style for the input box in normal state / 输入框正常状态下的样式
    func boxNormalStyle(_ style : @escaping (BRCBoxStyle) -> (BRCBoxStyle) ) -> some View {
        return updateParams { params in
            params.boxStyle = style(params.boxStyle);
        };
    }

    /// Set the style for the input box in selected state / 输入框选中状态下的样式
    func boxSelectedStyle(_ style : @escaping (BRCBoxStyle) -> (BRCBoxStyle)) -> some View {
        return updateParams { params in
            params.selectedBoxStyle = style(params.selectedBoxStyle);
        };
    }

    /// Whether to show the caret / 是否展示光标
    func isShowCaret(_ isShow : Bool) -> some View {
        return updateParams { params in
            params.showCaret = isShow;
        };
    }

    /// Set the size of the input box / 输入框的大小
    func boxSize(_ size : CGSize) -> some View {
        return updateParams { params in
            params.boxSize = size;
        }
    }

    /// Set the spacing between input boxes / 输入框的间距
    func boxSpace(_ space : CGFloat) -> some View {
        return updateParams { params in
            params.boxSpace = space;
        }
    }

    /// Set the direction of `UIMenuController` pop-up button / 设置 `UIMenuController` 弹出按钮的方向
    func menuDirection(_ direction : UIMenuController.ArrowDirection) -> some View {
        return updateParams { params in
            params.menuDirection = direction;
        }
    }

    /// Set the content insets / 内间距
    func contentInsets(_ contentInsets : UIEdgeInsets) -> some View {
        return updateParams { params in
            params.contentInsets = contentInsets;
        }
    }

    /// 是否自适应输入框大小来填满整个视图 / Whether to auto-fill the input box container
    func autoFillBoxContainer(_ isAutoFill : Bool) -> some View {
        return updateParams { params in
            params.autoFillBoxContainer = isAutoFill;
        }
    }

    /// Set the caret tint color / 光标的颜色
    func caretTintColor(_ color : UIColor) -> some View {
        return updateParams { params in
            params.caretTintColor = color
        }
    }

    /// Set the callback for when the input box is clicked / 点击输入框的回调
    func onClickInputViewBlock(_ block : @escaping (() -> Void)) -> some View {
        return updateParams { params in
            params.onClickInputViewBlock = block;
        }
    }

    /// Set the alignment of the input box / 输入框的对齐样式
    func alignment(_ alignment : BRCBoxAlignment) -> some View {
        return updateParams { params in
            params.alignment = alignment;
        }
    }

    /// Set the placeholder of the input box / 输入框的占位符
    func placeHolder(_ placeHolder : String) -> some View {
        return updateParams { params in
            params.placeHolder = placeHolder;
        }
    }

    /// Whether to automatically dismiss the keyboard when input is finished / 是否在完成输入的时候自动关闭键盘
    func autoDismissKeyBoardWhenFinishInput(_ isAuto : Bool) -> some View {
        return updateParams { params in
            params.autoDismissKeyBoardWhenFinishInput = isAuto;
        }
    }

    /// Whether to enable secure text entry / 是否加密输入
    func secureTextEntry(_ secureTextEntry : Bool) -> some View {
        return updateParams { params in
            params.secureTextEntry = secureTextEntry;
        }
    }

    /// Set the duration of the secure text entry transition / 加密输入的动画过渡时长
    func secureTransitionDuration(_ duration : CGFloat) -> some View {
        return updateParams { params in
            params.secureTransitionDuration = duration;
        }
    }

    /// Set the delay duration for displaying the secure view / 加密视图显示的延后时长
    func secureDelayDuration(_ duration : CGFloat) -> some View {
        return updateParams { params in
            params.secureDelayDuration = duration;
        }
    }

    /// Set the keyboard type for the input view / 输入视图的键盘样式
    func keyboardType(_ type : UIKeyboardType) -> some View {
        return updateParams { params in
            params.keyboardType = type;
        }
    }

    /// Set the content type for the input view / 输入视图的内容样式
    func textContentType(_ type : UITextContentType) -> some View {
        return updateParams { params in
            params.textContentType = type;
        }
    }

    /// Set the blink duration of the caret animation / 光标的渐显的动画时长
    func blinkDuration(_ duration : CGFloat) -> some View {
        return updateParams { params in
            params.blinkDuration = duration;
        }
    }

    /// Set the maximum opacity for the caret animation / 光标渐显动画最大透明度
    func caretMaxOpacity(_ opacity : CGFloat) -> some View {
        return updateParams { params in
            params.caretMaxOpacity = opacity;
        }
    }

    /// Set the minimum opacity for the caret animation / 光标渐显动画最小透明度
    func caretMinOpacity(_ opacity : CGFloat) -> some View {
        return updateParams { params in
            params.caretMinOpacity = opacity;
        }
    }

    /// Set the width of the caret / 光标宽度
    func caretWidth(_ width : CGFloat) -> some View {
        return updateParams { params in
            params.caretWidth = width;
        }
    }

    /// Set the height of the caret / 光标高度
    func caretHeight(_ height : CGFloat) -> some View {
        return updateParams { params in
            params.caretHeight = height;
        }
    }

    /// Set the actions that `UIMenuController` can respond to / `UIMenuController` 可响应的操作
    func menuActions(_ actions : [BRCBoxMenuActionType]) -> some View {
        return updateParams { params in
            params.menuActions = actions.map({ actionType in
                return NSNumber.init(integerLiteral: actionType.rawValue)
            });
        }
    }

    /// Set the scroll position to focus on the input box / 是否点击 `Return` 关闭键盘
    func isDismissKeyBoardWhenClickReturn(_ isDismiss : Bool) -> some View {
        return updateParams { params in
            params.isDismissKeyBoardWhenClickReturn = isDismiss;
        }
    }

    /// Set the scroll position to focus on the input box / 滑动到聚焦输入框的位置
    func focusScrollPosition(_ position : BRCBoxFocusScrollPosition) -> some View {
        return updateParams { params in
            params.focusScrollPosition = position;
        }
    }

    /// Set the `Return` key style for the input view / 输入视图键盘的 `Return` 样式
    func returnKeyType(_ keyType : UIReturnKeyType) -> some View {
        return updateParams { params in
            params.returnKeyType = keyType;
        }
    }

    /// Set the callback for when an input box is about to be displayed / 即将展示某个输入框
    func willDisplayBox(_ block : @escaping (Int) -> ()) -> some View {
        return updateParams { params in
            params.willDisplayBoxBlock = block;
        }
    }

    /// Set the callback for when an input box has finished displaying / 即将结束展示某个输入框
    func didEndDisplayBox(_ block : @escaping (Int) -> ()) -> some View {
        return updateParams { params in
            params.didEndDisplayBoxBlock = block;
        }
    }

    /// Set the callback for when an input box is selected / 选中某个输入框
    func didSelectBox(_ block : @escaping (Int) -> ()) -> some View {
        return updateParams { params in
            params.didSelectBoxBlock = block;
        }
    }

    /// Set the callback for when an input box is deselected / 取消选中某个输入框
    func didUnSelectBox(_ block : @escaping (Int) -> ()) -> some View {
        return updateParams { params in
            params.didUnSelectBoxBlock = block;
        }
    }

    /// Set the callback for when an input box is about to be selected / 即将选中某个输入框
    func willSelectBox(_ block : @escaping (Int) -> ()) -> some View {
        return updateParams { params in
            params.willSelectBoxBlock = block;
        }
    }

    /// Set the callback for when an input box is about to be deselected / 即将取消选中某个输入框
    func willUnSelectBox(_ block : @escaping (Int) -> ()) -> some View {
        return updateParams { params in
            params.willUnSelectBoxBlock = block;
        }
    }

    /// Customize the input box view / 自定义输入框视图
    func customBoxView(@ViewBuilder view : @escaping ((Int,Bool,CGSize) -> BRCBoxContent)) -> BRCBoxInput {
        var input = self;
        input.boxView = view;
        return input;
    }

    /// Set the callback for copying text from the pasteboard / 从粘贴板复制某段文本
    func didCopyTextFromPasteboard(_ block : @escaping (String) -> ()) -> some View {
        return updateParams { params in
            params.didCopyTextFromPasteboard = block;
        }
    }

    /// Set the callback for pasting text from the pasteboard/ 从粘贴板粘贴某段文本
    func didPasteTextFromPasteboard(_ block : @escaping (String) -> ()) -> some View {
        return updateParams { params in
            params.didPasteTextFromPasteboard = block;
        }
    }

    /// Set the callback for cutting text from the pasteboard / 从粘贴板剪切某段文本
    func didCutTextFromPasteboard(_ block : @escaping (String) -> ()) -> some View {
        return updateParams { params in
            params.didCutTextFromPasteboard = block;
        }
    }

    /// Set the callback for deleting text from the pasteboard / 从粘贴板删除某段文本
    func didDeleteTextFromPasteboard(_ block : @escaping (String) -> ()) -> some View {
        return updateParams { params in
            params.didDeleteTextFromPasteboard = block;
        }
    }
    
    /// Regular input restrictions / 输入的正则限制
    func inputPattern(_ string : String) -> some View {
        return updateParams { params in
            params.inputPattern = string;
        }
    }
}

public extension BRCBoxStyle {
    
    private func updateParams(_ block : ((inout BRCBoxStyle) -> Void)) -> BRCBoxStyle {
        var style = self;
        block(&style);
        return style;
    }
    
    func boxSize(_ boxSize : CGSize) -> BRCBoxStyle {
        return updateParams { style in
            style.boxSize = boxSize;
        }
    }
    
    func boxCornerRadius(_ radius : CGFloat) -> BRCBoxStyle {
        return updateParams { style in
            style.boxCornerRadius = radius;
        }
    }
    
    func boxBorderWidth(_ width : CGFloat) -> BRCBoxStyle {
        return updateParams { style in
            style.boxBorderWidth = width;
        }
    }
    
    func boxShadowRadius(_ radius : CGFloat) -> BRCBoxStyle {
        return updateParams { style in
            style.boxShadowRadius = radius;
        }
    }
    
    func boxShadowOffset(_ offset : CGSize) -> BRCBoxStyle {
        return updateParams { style in
            style.boxShadowOffset = offset;
        }
    }
    
    func boxSecretImageSize(_ size : CGSize) -> BRCBoxStyle {
        return updateParams { style in
            style.boxSecretImageSize = size;
        }
    }
    
    func boxBackgroundColor(_ color : UIColor) -> BRCBoxStyle {
        return updateParams { style in
            style.boxBackgroundColor = color;
        }
    }
    
    func boxBorderColor(_ color : UIColor) -> BRCBoxStyle {
        return updateParams { style in
            style.boxBorderColor = color;
        }
    }
    
    func boxShadowColor(_ color : UIColor) -> BRCBoxStyle {
        return updateParams { style in
            style.boxShadowColor = color;
        }
    }
    
    func boxSecretImageColor(_ color : UIColor) -> BRCBoxStyle {
        return updateParams { style in
            style.boxSecretImageColor = color;
        }
    }
    
    func boxSecretImage(_ image : UIImage) -> BRCBoxStyle {
        return updateParams { style in
            style.boxSecretImage = image;
        }
    }
    
    func textAttributedDict(_ attributed : [NSAttributedString.Key:Any]) -> BRCBoxStyle {
        return updateParams { style in
            style.textAttributedDict = attributed;
        }
    }
    
    func placeHolderAttributedDict(_ attributed : [NSAttributedString.Key:Any]) -> BRCBoxStyle {
        return updateParams { style in
            style.placeHolderAttributedDict = attributed;
        }
    }
    
 }

// MARK: internal
internal class BRCBoxInputDelegateObject: NSObject, BRCBoxInputViewDelegate {
    var boxInputViewShouldReturn : (() -> Bool)?
    var boxStyleWithIndex : ((UInt,Bool) -> BRCBoxStyle?)?
    var boxViewWithIndex  : ((Int,Bool,CGSize) -> (UIView & BRCBoxViewProtocol)?)?
    var boxTextDidChangeSubject : ((String) -> Void)?
    var copyTextSubject : ((String) -> Void)?
    var pasteTextSubject : ((String) -> Void)?
    var cutTextSubject : ((String) -> Void)?
    var deleteTextSubject : ((String) -> Void)?
    var didChangeFocusStateSubject : ((Bool) -> Void)?
    var willDisplayBoxSubject : ((Int) -> Void)?
    var didEndDisplayBoxSubject : ((Int) -> Void)?
    var willSelectInputBoxSubject : ((Int) -> Void)?
    var didSelectInputBoxSubject : ((Int) -> Void)?
    var willUnSelectInputBoxSubject : ((Int) -> Void)?
    var didUnSelectInputBoxSubject : ((Int) -> Void)?
    func boxWithIndex(_ index: Int, _ inputView: BRCBoxInputView!) -> (UIView & BRCBoxViewProtocol)! {
        if (boxViewWithIndex != nil) {
            return boxViewWithIndex!(index,inputView.currentSelectIndex == index && inputView.isFirstResponder,inputView.boxSize(for: index));
        }
        return nil;
    }
    func boxStyleWithIndex(_ index: Int, _ boxView: BRCBoxView!, _ inputView: BRCBoxInputView!) -> BRCBoxStyle! {
        if (boxStyleWithIndex != nil) {
            return boxStyleWithIndex!(UInt(index),inputView.currentSelectIndex == index && inputView.isFirstResponder);
        }
        return nil
    }
    func boxInputViewShouldReturn(_ inputView: BRCBoxInputView!) -> Bool {
        if (boxInputViewShouldReturn != nil) {
            return boxInputViewShouldReturn!()
        }
        return false
    }
    func boxTextDidChange(_ inputView: BRCBoxInputView!) {
        boxTextDidChangeSubject?(inputView.text ?? "")
    }
    func copyText(text: String!, _ inputView: BRCBoxInputView!) {
        copyTextSubject?(text)
    }
    func pasteText(text: String!, _ inputView: BRCBoxInputView!) {
        pasteTextSubject?(text)
    }
    func cutText(text: String!, _ inputView: BRCBoxInputView!) {
        cutTextSubject?(text)
    }
    func deleteText(text: String!, _ inputView: BRCBoxInputView!) {
        deleteTextSubject?(text)
    }
    func didBecomeFirstResponder(_ inputView: BRCBoxInputView!) {
        didChangeFocusStateSubject?(true)
    }
    func didResignFirstResponder(_ inputView: BRCBoxInputView!) {
        didChangeFocusStateSubject?(false)
    }
    func willDisplayBox(_ boxView: BRCBoxView!, _ index: Int, _ inputView: BRCBoxInputView!) {
        willDisplayBoxSubject?(index)
    }
    func didEndDisplayBox(_ boxView: BRCBoxView!, _ index: Int, _ inputView: BRCBoxInputView!) {
        didEndDisplayBoxSubject?(index)
    }
    func willSelectInputBox(_ boxView: BRCBoxView!, _ index: Int, _ inputView: BRCBoxInputView!) {
        willSelectInputBoxSubject?(index)
    }
    func didSelectInputBox(_ boxView: BRCBoxView!, _ index: Int, _ inputView: BRCBoxInputView!) {
        didSelectInputBoxSubject?(index)
    }
    func willUnSelectInputBox(_ boxView: BRCBoxView!, _ index: Int, _ inputView: BRCBoxInputView!) {
        willUnSelectInputBoxSubject?(index)
    }
    func didUnSelectInputBox(_ boxView: BRCBoxView!, _ index: Int, _ inputView: BRCBoxInputView!) {
        didUnSelectInputBoxSubject?(index)
    }
}

internal class BRCCustomSwiftUIBoxView<BRCBoxContent:View & BRCBoxProtocol> : UIView,BRCBoxViewProtocol {
    var swiftUIView : BRCBoxContent;
    var convertUiView : UIView
    init(swiftUIView : BRCBoxContent) {
        self.swiftUIView = swiftUIView
        let hostingVC = UIHostingController(rootView: swiftUIView);
        let uiView : UIView = hostingVC.view;
        self.convertUiView = uiView;
        super.init(frame: .zero);
        addSubview(uiView);
        uiView.backgroundColor = .clear;
        uiView.translatesAutoresizingMaskIntoConstraints = false;
        let constraints = [
            uiView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            uiView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            uiView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            uiView.topAnchor.constraint(equalTo: self.topAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: BRCBoxViewProtocol
    var isNotEmpty: Bool {
        return swiftUIView.isNotEmpty
    }
    var isBoxSelected: Bool {
        return swiftUIView.isBoxSelected
    }
    func setSecureTextEntry(_ secureTextEntry: Bool, withDuration duration: CGFloat, delay: CGFloat) {
        swiftUIView.setSecureTextEntry(secureTextEntry, withDuration: duration, delay: delay)
    }
    func didSelectInputBox() {
        swiftUIView.didSelectInputBox()
    }
    func didUnSelectInputBox() {
        swiftUIView.didUnSelectInputBox()
    }
    func setBoxText(_ text: String!) {
        swiftUIView.setBoxText(text)
    }
    func setBoxPlaceHolder(_ placeHolder: String!) {
        swiftUIView.setBoxPlaceHolder(placeHolder)
    }
    func setBoxStyle(_ boxStyle: BRCBoxStyle!) {
        swiftUIView.setBoxStyle(boxStyle)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
