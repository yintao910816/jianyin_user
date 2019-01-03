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
    
    private var pageNum: Int = 0
    private let pageSize: Int = 10
    
    private var tempPageNum: Int = 0
    // 设计成单例
    static let shareIntance : HCDataProvideTool = {
        let tools = HCDataProvideTool()
        return tools
    }()
    
    func requestCircleData(){
        tempPageNum = pageNum
        pageNum = 0
        HttpRequestManager.shareIntance.HC_findLastestTopics(callback: { [unowned self](success, arr, msg) in
            if success == true {
                self.tempPageNum = 0
                self.circleData = arr!
            }else{
                HCPrint(message: msg)
                self.pageNum = self.tempPageNum
            }
        })
    }
    
    func loadMoreCircleData() {
        HttpRequestManager.shareIntance.HC_findLastestTopics(pageNum: pageNum, pageSize: pageSize) { [unowned self] (success, arr, msg) in
            if success == true {
                self.pageNum += 1
                self.circleData?.append(contentsOf: arr!)
            }else{
                HCPrint(message: msg)
            }
        }
    }
}
