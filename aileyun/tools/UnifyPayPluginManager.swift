//
//  UnifyPayPluginManager.swift
//  aileyun
//
//  Created by huchuang on 2018/4/27.
//  Copyright © 2018年 huchuang. All rights reserved.
//

import UIKit

class UnifyPayPluginManager: NSObject {
    
    
    enum UnifyPayChannel : NSInteger{
        case unifyPayChannelWXPay = 1
        case unifyPayChannelAlipay = 2
    }
    
    // 设计成单例
    static let shareIntance : UnifyPayPluginManager = {
        let tools = UnifyPayPluginManager()
        return tools
    }()
    
    
    func sendPayRequestWithResponse(payChannel : UnifyPayChannel, payStr : String){
            
        switch payChannel{
        case .unifyPayChannelWXPay:
            UMSPPPayUnifyPayPlugin.pay(withPayChannel: CHANNEL_WEIXIN, payData: payStr) { (resultCode, resultInfo) in
                //
            }
        case .unifyPayChannelAlipay:
            UMSPPPayUnifyPayPlugin.pay(withPayChannel: CHANNEL_ALIPAY, payData: payStr) { (resultCode, resultInfo) in
                //
            }
        }
    }
    
    
    //查询支付结果
    func checkPayResult(merOrderId : String, callback : @escaping(Bool)->()){
        HttpRequestManager.shareIntance.HC_jiayinPayResult(merOrderId: merOrderId) { (bool) in
            callback(bool)
        }
    }
    
    
    

}
