//
//  NoticeHomeVModel.swift
//  aileyun
//
//  Created by huchuang on 2017/11/11.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class NoticeHomeVModel: HJModel {
    
    
    var content : String = "您有新的通知提醒，点击查看详情"
    var id : NSNumber?
    var popFlag : NSNumber?    // 1   需要弹窗
    var typeCom : String?
    var title : String = "通知提醒"
    
    var hospitalId : String?
    var type : NSNumber?
    var createTime : String?
    var url : String?
    
}
