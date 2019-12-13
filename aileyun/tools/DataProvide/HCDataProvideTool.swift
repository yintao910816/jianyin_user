//
//  HCDataProvideTool.swift
//  aileyun
//
//  Created by huchuang on 2017/9/18.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class HCDataProvideTool: NSObject {
    
    dynamic var circleData : [HCCircleModel]?
    
    private var pageNum: Int = 1
    private let pageSize: Int = 10
    
    public var dataReloadCallBack: (([HCCircleModel]?)->())?
    
    // 设计成单例
    static let shareIntance : HCDataProvideTool = {
        let tools = HCDataProvideTool()
        return tools
    }()
    
    func requestCircleData(){
        pageNum = 1
        HttpRequestManager.shareIntance.HC_findLastestTopics(callback: { [unowned self](success, arr, msg) in
            if success == true {
                self.circleData = arr!
                self.dataReloadCallBack?(self.circleData)
            }else{
                self.pageNum = 1
            }
        })
    }
    
    func loadMoreCircleData() {
        pageNum += 1
        HttpRequestManager.shareIntance.HC_findLastestTopics(pageNum: pageNum, pageSize: pageSize) { [unowned self] (success, arr, msg) in
            if success == true {
                self.circleData?.append(contentsOf: arr!)
                self.dataReloadCallBack?(self.circleData)
            }else{
                if self.pageNum > 1 { self.pageNum -= 1 }
            }
        }
    }
}
