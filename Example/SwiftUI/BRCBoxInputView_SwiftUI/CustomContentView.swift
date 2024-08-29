//
//  CustomContentView.swift
//  BRCBoxInputView_SwiftUI
//
//  Created by sunzhixiong on 2024/8/16.
//

import SwiftUI
import BRCFastTest
import BRCBoxInputView

struct CustomBoxView: View, BRCBoxProtocol {
    @State var text: String = ""
    @State var isSelected: Bool
    
    var boxSize : CGSize
    
    var isNotEmpty: Bool {
        return !text.isEmpty
    }
    
    var isBoxSelected: Bool {
        return isSelected
    }
    
    func setSecureTextEntry(_ secureTextEntry: Bool, withDuration duration: CGFloat, delay: CGFloat) {
    }
    
    func setBoxText(_ text: String) {
        self.text = text
        print(text);
    }
    
    func setBoxPlaceHolder(_ placeHolder: String) {
        
    }
    
    func didSelectInputBox() {
        isSelected = true
    }
    
    func didUnSelectInputBox() {
        isSelected = false
    }
    
    func setBoxStyle(_ boxStyle: BRCBoxStyle) {
        
    }
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text(text)
                .foregroundColor(.brtest_black())
            
            Spacer()
            
            Rectangle()
                .foregroundColor(isSelected ? Color.blue : Color.gray)
                .frame(height: 3)
        }
        .frame(width: boxSize.width,height: boxSize.height)
    }
}

struct CustomBoxView2 : View, BRCBoxProtocol {
    @State var text: String = ""
    @State var isSelected: Bool
    
    var boxSize : CGSize
    
    var isNotEmpty: Bool {
        return !text.isEmpty
    }
    
    var isBoxSelected: Bool {
        return isSelected
    }
    
    func setSecureTextEntry(_ secureTextEntry: Bool, withDuration duration: CGFloat, delay: CGFloat) {
    }
    
    func setBoxText(_ text: String) {
        self.text = text
        print(text);
    }
    
    func setBoxPlaceHolder(_ placeHolder: String) {
        
    }
    
    func didSelectInputBox() {
        isSelected = true
    }
    
    func didUnSelectInputBox() {
        isSelected = false
    }
    
    func setBoxStyle(_ boxStyle: BRCBoxStyle) {
        
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(boxSize.width / 2)
                .clipped()
                .frame(width: boxSize.width,height: boxSize.height)
                .foregroundColor(isSelected ? Color.brtest_cyan() : Color.brtest_fifthGray())
                .frame(height: 3)
                .shadow(radius: 5)
            
            Text(text)
                .foregroundColor(isSelected ? .white : .brtest_black())
                .frame(width: boxSize.width,height: boxSize.height)
        }
    }
}

struct CustomContentView : View {
    @State var text : String = "12";
    @State var isFocus : Bool = false;
    
    @State var text2 : String = "你好";
    @State var isFocus2 : Bool = false;
    @State var currentIndex : Int = 0;
    
    func character(at index: Int, in str: String) -> String {
        // 确保索引不超过字符串的长度
        guard index >= 0 && index < str.count else {
            return ""
        }
        
        // 计算索引
        let targetIndex = str.index(str.startIndex, offsetBy: index)
        
        // 获取字符并转换为String类型
        let character = str[targetIndex]
        return String(character)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Text("自定义样式1")
                            .font(.system(size: 16.0,weight: .bold))
                        Spacer()
                        
                        Text(text)
                    }
                    
                    BRCBoxInput<CustomBoxView>(text: $text, isFocus: $isFocus)
                        .customBoxView { index, isSelect, boxSize in
                            CustomBoxView(text:character(at: index, in: text),isSelected:isSelect,boxSize:boxSize)
                        }
                        .frame(height: 80)
                }
                .padding()
                .background(Color.brtest_fifthGray().opacity(0.6))
                .cornerRadius(10)
                .clipped()
                
                VStack {
                    HStack {
                        Text("自定义样式2")
                            .font(.system(size: 16.0,weight: .bold))
                        Spacer()
                        
                        Text(text2)
                    }
                    
                    BRCBoxInput<CustomBoxView2>(text: $text2, isFocus: $isFocus2)
                        .customBoxView { index, isSelect,boxSize in
                            CustomBoxView2(text:character(at: index, in: text2),isSelected:isSelect,boxSize:boxSize)
                        }
                        .onClickInputViewBlock {
                            isFocus2.toggle()
                            BRCToast.show("onClickInputViewBlock");
                        }
                        .didSelectBox({ index in
                            print("didSelectBox\(index)")
                        })
                        .didUnSelectBox({ index in
                            print("didUnSelectBox\(index)")
                        })
                        .willSelectBox({ index in
                            print("willSelectBox\(index)")
                        })
                        .willUnSelectBox({ index in
                            print("willUnSelectBox\(index)")
                        })
                        .willDisplayBox({ index in
                            print("willDisplayBox\(index)")
                        })
                        .didEndDisplayBox({ index in
                            print("didEndDisplayBox\(index)")
                        })
                        .didCutTextFromPasteboard({ text in
                            BRCToast.show("剪切板剪切\(text)");
                        })
                        .didCopyTextFromPasteboard({ text in
                            BRCToast.show("剪切板复制\(text)");
                        })
                        .didPasteTextFromPasteboard({ text in
                            BRCToast.show("剪切板粘贴\(text)");
                        })
                        .didDeleteTextFromPasteboard({ text in
                            BRCToast.show("剪切板删除\(text)");
                        })
                        .focusScrollPosition(.left)
                        .caretTintColor(.brtest_white)
                        .frame(height: 80)
                }
                .padding()
                .background(Color.brtest_fifthGray().opacity(0.6))
                .cornerRadius(10)
                .clipped()
                
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("样例")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CustomContentView()
}
