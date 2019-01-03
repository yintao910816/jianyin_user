//
//  HCTextField.swift
//  aileyun
//
//  Created by huchuang on 2018/6/28.
//  Copyright © 2018年 huchuang. All rights reserved.
//

import UIKit

class HCTextField: UITextField{

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isSetNumber = true
        self.keyboardType = .numbersAndPunctuation
        self.delegate = self
    }
    
    // 从xib或者storeboard 实例
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isSetNumber = true
        self.keyboardType = .numbersAndPunctuation
        self.delegate = self
    }
    
}

extension HCTextField: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         return textField.isNum(range: range, changeStr: string)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        HCPrint(message: "textFieldDidEndEditing")
        textField.setNum()
    }
}






private var IsSetNumberKey: UInt8 = 0
private var MaxKey: UInt8 = 0

extension UITextField {
    // 是否设置数字格式
    public var isSetNumber: Bool? {
        get {
            return (objc_getAssociatedObject(self, &IsSetNumberKey) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(self, &IsSetNumberKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    // 设置最大数
    public var max: Double? {
        get {
            return (objc_getAssociatedObject(self, &MaxKey) as? Double)
        }
        set {
            objc_setAssociatedObject(self, &MaxKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    // 输入验证
    func isNum(range: NSRange, changeStr: String) -> Bool {
        if self.isSetNumber! {
            let text = self.text ?? ""
            if let index = text.index(of: "."){
                let tempS = text.substring(from: index)
                if tempS.lengthOfBytes(using: String.Encoding.utf8) == 3 && changeStr != ""{
                    return false
                }
            }
            if changeStr.components(separatedBy: ".").count > 1 {
                if text.components(separatedBy: ".").count > 1 {
                    return false
                }
            }
            return changeStr.isFiltered(text: "0123456789.")
        }
        return true
    }
    // 格式化，为了去除多余的.
    func setNum() {
        if self.isSetNumber! {
            self.text = (self.text == nil || self.text == "") ? "0" : self.text
            while self.text!.hasSuffix(".") {
                self.text = NSString(string: text!).replacingCharacters(in: NSMakeRange(text!.lengthOfBytes(using: String.Encoding.utf8) - 1, 1), with: "")
            }
            if max != nil{
                self.text = Double(text!)! > self.max! ? "\(self.max!)" : text!
            }
            if self.text!.lengthOfBytes(using: String.Encoding.utf8) > 1{
                while self.text!.hasPrefix("0"){
                    self.text = NSString(string: text!).replacingCharacters(in: NSMakeRange(0, 1), with: "")
                    if self.text!.lengthOfBytes(using: String.Encoding.utf8) == 1{
                        break
                    }
                }
                if self.text!.hasPrefix("."){
                    self.text = "0" + self.text!
                }
            }
        }
    }
    
}


extension String{
    // 是否属于子集内
    func isFiltered(text:String) -> Bool {
        var cs = NSCharacterSet(charactersIn: text).inverted
        let filtered = self.components(separatedBy: cs).joined(separator: "")
        let basicTest = self == filtered
        if(!basicTest) {
            return false
        }
        return true
    }
}
