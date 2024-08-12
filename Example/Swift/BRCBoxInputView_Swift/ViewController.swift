//
//  ViewController.swift
//  BRCBoxInputView_Swift
//
//  Created by sunzhixiong on 2024/8/12.
//

import UIKit
import BRCFastTest
import BRCBoxInputView

class ViewController : BRCBaseTestViewController {
    
    override func viewDidLoad() {
        self.isAutoHandlerKeyBoard = true;
        super.viewDidLoad();
    }
    
    override func setUpViews() {
        super.setUpViews();
        let label = UILabel.init();
        label.textColor = UIColor.brtest_red;
        label.tag = 100;
        addSubView(label, space: 10, height: 30);
        let boxInputView = BRCBoxInputView(inputLength: 10);
        boxInputView.contentInsets = .init(top: 0, left: 10, bottom: 0, right: 10);
        boxInputView.delegate = self;
        boxInputView.selectedBoxStyle.boxBorderColor = .brtest_black;
        boxInputView.boxStyle.boxBorderColor = .brtest_black;
        boxInputView.text = "Hello";
        boxInputView.placeHolder = "BRCBoxInputView";
        boxInputView.boxStyle.textAttributedDict = [
            .foregroundColor : UIColor.brtest_black,
            .font            : UIFont.boldSystemFont(ofSize: 16.0)
        ];
        boxInputView.boxStyle.placeHolderAttributedDict = [
            .foregroundColor : UIColor.brtest_secondaryGray,
            .font            : UIFont.boldSystemFont(ofSize: 14.0)
        ];
        addSubView(boxInputView, topSpace:10, width: UIScreen.main.bounds.width, height: 80, isCenter: true, isRight: false);
    }
    
    override func componentTitle() -> String {
        return "BRCBoxInputView"
    }
    
    override func componentDescription() -> String {
        return "一个高效易用的验证码输入组件"
    }
    
    override func componentFunctions() -> [Any] {
        return [
            "基于 UIKeyInput 协议",
            "支持占位符、阴影等多种样式",
            "支持自定义加密输入",
            "支持复制、粘贴、删除、拷贝的功能"
        ]
        
    }
}

extension ViewController : BRCBoxInputViewDelegate {
    func boxTextDidChange(_ inputView: BRCBoxInputView!) {
        let label = self.view.viewWithTag(100) as! UILabel;
        label.text = inputView.text;
    }
    
    func boxInputViewShouldReturn(_ inputView: BRCBoxInputView!) -> Bool {
        return true;
    }
}
