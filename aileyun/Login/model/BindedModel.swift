//
//  BindedModel.swift
//  aileyun
//
//  Created by huchuang on 2017/8/11.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class BindedModel: NSObject {
    
//    "visitcard":"302100001",
//    "hospitalId":108,
//    "realname":"张晶",
//    "idno":"652302199211221528"

    
    var hospitalId : NSNumber?
    var hospitalName : String?
    var idNo : String?
    var patientId : NSNumber?
    var realName : String?
    var visitCard : String?
    
    // MARK:- 构造函数
    init(_ dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}


}
