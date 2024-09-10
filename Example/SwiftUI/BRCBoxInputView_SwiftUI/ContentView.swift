//
//  ContentView.swift
//  BRCBoxInputView_SwiftUI
//
//  Created by sunzhixiong on 2024/8/16.
//

import SwiftUI
import BRCFastTest
import BRCBoxInputView
import BRCFlexTagBox

extension String : Identifiable{
    public var id : Int{
        return self.hashValue
    }
}

struct TagView : View {
    var backgroundColor : Color
    var text : String
    init(_ backgroundColor: Color,_ text: String) {
        self.backgroundColor = backgroundColor
        self.text = text
    }
    var body: some View {
        Text(NSString.brctest_localizable(withKey: text))
            .font(.footnote)
            .fontWeight(.bold)
            .foregroundColor(.brtest_white())
            .padding(.init(top: 3, leading: 5, bottom: 3, trailing: 5))
            .background(backgroundColor)
            .cornerRadius(4)
            .clipped()
    }
}



struct ContentView : View {
    
    @Binding var isBoxInputFocus : Bool
    @State var placeHolder : String = "";
    @State var isSecureTextEntry : Bool = false;
    @State var textFieldText : String = "Hello World"
    @State var boxInputText : String = "1"
    @State var inputLength : UInt = 6;
    @State var isAutoDismissKeyBoardWhenFinishInput : Bool = false;
    @State var caretWidth : CGFloat = 2;
    @State var caretHeight : CGFloat = 30;
    @State var keyBoardType : String = "普通键盘";
    @State var boxContainerHeight : CGFloat = 0;
    
    func getKetBoardTypeWithStr(_ string : String) -> UIKeyboardType {
        if (keyBoardType == "普通键盘") {
            return .default;
        }
        return .numberPad;
    }
    
    var body: some View {
        VStack {
            BRCFlexTagBox(testTags:[
                "Objective-C",
                "Swift",
                "SwiftUI",
                "UITextInput",
                "API强大",
                "支持高度自定义",
                "支持 iOS 13.0 以上"
            ], contentHeight: $boxContainerHeight)
            .tagBackgroundColor(.brtest_contentWhite)
            .frame(height: boxContainerHeight)

            Toggle("开启加密输入", isOn: $isSecureTextEntry)
                .font(.system(size: 16.0,weight: .bold))
            Toggle("开启编辑", isOn: $isBoxInputFocus)
                .font(.system(size: 16.0,weight: .bold))
            Toggle("输入完后键盘自动消失",isOn: $isAutoDismissKeyBoardWhenFinishInput)
                .font(.system(size: 16.0,weight: .bold))
            HStack {
                Text("光标宽度")
                     .font(.system(size: 16.0,weight: .bold))
                Slider(value: $caretWidth, in: 0...10)
            }
            
            HStack {
                Text("光标高度")
                     .font(.system(size: 16.0,weight: .bold))
                     .font(.system(size: 16.0,weight: .bold))
                Slider(value: $caretHeight, in: 0...80)
            }
            
            Picker(selection: $keyBoardType) {
                ForEach(["普通键盘","数字键盘"]) { item in
                    Text("\(item)")
                        .tag(item)
                }
            } label: {}
                .pickerStyle(.segmented)
                .accentColor(.brtest_black())
            
            HStack {
                Text("输入占位符")
                    .font(.system(size: 16.0,weight: .bold))
                TextField(text: $placeHolder) {
                   Text("占位符")
                }
                .frame(height: 50)
            }
            
             Stepper {
                Text("输入框长度:\(inputLength)")
                     .font(.system(size: 16.0,weight: .bold))
             } onIncrement: {
                 inputLength += 1;
             } onDecrement: {
                 if (inputLength >= 2) {
                     inputLength -= 1;
                 }
             }
            
            Text("输入框输入内容:\(boxInputText)")
                .font(.system(size: 16.0,weight: .bold))
            
            BRCBoxInput<BRCBox>(text: $boxInputText,isFocus: $isBoxInputFocus)
                .isDismissKeyBoardWhenClickReturn(true)
                .boxStyleWithIndex({ index, isSelect in
                    var boxStyle : BRCBoxStyle;
                    if (isSelect) {
                        boxStyle = BRCBoxStyle.defaultSelected()
                        boxStyle.boxBorderColor = .brtest_red;
                        boxStyle.boxBorderWidth = 2;
                    } else {
                        boxStyle = BRCBoxStyle.default()
                        boxStyle.boxBorderColor = .brtest_black;
                    }
                    boxStyle.textAttributedDict = [
                        .foregroundColor : UIColor.brtest_black
                    ]
                    boxStyle.placeHolderAttributedDict = [
                        .foregroundColor : UIColor.brtest_gray
                    ]
                    boxStyle.boxSecretImageColor = UIColor.brtest_black;
                    return boxStyle;
                })
                .inputLength(inputLength)
                .placeHolder(placeHolder)
                .caretTintColor(.brtest_blue)
                .caretHeight(caretHeight)
                .caretWidth(caretWidth)
                .keyboardType(getKetBoardTypeWithStr(keyBoardType))
                .secureTextEntry(isSecureTextEntry)
                .autoDismissKeyBoardWhenFinishInput(isAutoDismissKeyBoardWhenFinishInput)
                .returnKeyType(.done)
                .frame(height: 80)
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    ContentView(isBoxInputFocus:.constant(false));
}
