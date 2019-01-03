//
//  HCCircleModel.swift
//  aileyun
//
//  Created by huchuang on 2017/9/18.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class HCCircleModel: NSObject {
    
    var seo_description : String?
    var views_number : NSNumber?
    var href_ : String?
    var name : String?
    var author : String?
    
    var type : String?
    var publish_date : NSNumber?
    var hospital_id : String?
    var id : NSNumber?
    var pic_path : String?
    
    var info : String?
    var seo_keywords : String?
    var title : String?
    var is_href : NSNumber?

    
    var url : String?


    // MARK:- 构造函数
    init(_ dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
