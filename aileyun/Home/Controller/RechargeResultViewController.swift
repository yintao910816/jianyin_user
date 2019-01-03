//
//  RechargeResultViewController.swift
//  aileyun
//
//  Created by 尹涛 on 2018/10/18.
//  Copyright © 2018年 huchuang. All rights reserved.
//

import UIKit

class RechargeResultViewController: BaseViewController {

    @IBOutlet weak var payStateOutlet: UILabel!
    @IBOutlet weak var orderNumOutlet: UILabel!
    @IBOutlet weak var payTypeOutlet: UILabel!
    @IBOutlet weak var payMoneyOutlet: UILabel!
    
    @IBOutlet weak var topCns: NSLayoutConstraint!
    
    private var orderNum: String!
    private var payType: String!
    private var payMoney: String!
    private var payStateText: String!
    
    @IBAction func backToHome(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func gotoRechargeRecord(_ sender: UIButton) {
        let webVC = WebViewController()
        webVC.url = HC_RECHARGE_RECORD
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    func set(orderNum: String, payType: String, payMoney: String, payState: Bool) {
        self.payStateText = payState == true ? "充值成功" : "充值失败"
        
        self.orderNum = "订单编号：\(orderNum)"
        self.payType  = "支付方式：\(payType)"
        self.payMoney = "支付金额：\(payMoney)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.isX == true {
            topCns.constant = topCns.constant + 20
        }
        
        navigationItem.title = "充值结果"
        
        payStateOutlet.text = payStateText
        
        orderNumOutlet.text = orderNum
        payTypeOutlet.text  = payType
        payMoneyOutlet.text = payMoney
    }

}
