//
//  HCUserModel.swift
//  aileyun
//
//  Created by huchuang on 2017/7/27.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class HCUserModel: NSObject {
    
    var deviceType : String?
    var ip : String?
    var token : String?
    var nickname : String?
    var loginDate : NSNumber?
    
    var idNo : String?
    var realname : String?
    var versionCode : String?
    var id : NSNumber?
    var packageName : String?
    
    var visitCard : String?
    var userAgents : String?
    var phone : String?
    var updateTime : NSNumber?
    var hospitalId : NSNumber?
    
    var createTime : NSNumber?
    var sex : NSNumber?
    var pinyin : String?

    
    var password : String?
    
    
    convenience init(_ dic : [String : Any]) {
        self.init()
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        //
    }
    
    
}
