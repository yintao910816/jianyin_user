//
//  ConfirmOrderViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/7/12.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD

class ConfirmOrderViewController: BaseViewController {
    
   
    var consultId : NSNumber?
    
    var price : String?{
        didSet {
            priceL.text = price
            nameL.text = "发起咨询"
            defaultTool = 0
        }
    }
    var doctorName : String?{
        didSet{
            titleL.text = "咨询对象：" + doctorName!
        }
    }
    
    //为了model
    //doctorId : String?
    
    let nameL = UILabel()
    let titleL = UILabel()
    let priceL = UILabel()
    
    let alipayBtn = UIButton()
    let weixinBtn = UIButton()
    
    let payBtn = UIButton()
    
    var weixinPrepayId : String?
    
    var defaultTool : NSInteger? {
        didSet{
            if defaultTool == 0 {
                alipayBtn.isSelected = true
                weixinBtn.isSelected = false
            }else{
                alipayBtn.isSelected = false
                weixinBtn.isSelected = true
            }
        }
    }
    
    var merOrderId : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "订单确认"
        
        initUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ConfirmOrderViewController.checkPayResult), name: NSNotification.Name.init(DID_BECOME_ACTIVE), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let leftItem = UIBarButtonItem(image: UIImage(named: "返回灰"), style: .plain, target: self, action: #selector(ConfirmOrderViewController.goToRecordVC))
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    @objc func goToRecordVC(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func checkPayResult(){
        if let s = merOrderId{    // "3194201805161052221379905827"
            SVProgressHUD.show()
            UnifyPayPluginManager.shareIntance.checkPayResult(merOrderId: s) { [weak self](bool) in
                if bool{
                    HCShowInfo(info: "支付成功")
                    self?.navigationController?.popViewController(animated: true)
                }else{
                    HCShowError(info: "未完成支付")
                }
            }
        }
    }


    func initUI(){
        
        let space = AppDelegate.shareIntance.space
        let contaiV = UIView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: 116))
        contaiV.backgroundColor = UIColor.white
        self.view.addSubview(contaiV)
        
        contaiV.addSubview(nameL)
        nameL.snp.updateConstraints { (make) in
            make.left.top.equalTo(contaiV).offset(20)
            make.width.equalTo(80)
            make.height.equalTo(20)
        }
        nameL.font = UIFont.init(name: kReguleFont, size: 12)
        nameL.textColor = kLightTextColor
        
        contaiV.addSubview(titleL)
        titleL.snp.updateConstraints { (make) in
            make.left.equalTo(nameL)
            make.top.equalTo(nameL.snp.bottom)
            make.width.equalTo(SCREEN_WIDTH - 40)
            make.height.equalTo(25)
        }
        titleL.font = UIFont.init(name: kBoldFont, size: 18)
        titleL.textColor = kTextColor
        
        contaiV.addSubview(priceL)
        priceL.snp.updateConstraints { (make) in
            make.left.equalTo(nameL)
            make.top.equalTo(titleL.snp.bottom)
            make.height.equalTo(25)
        }
        priceL.font = UIFont.init(name: kReguleFont, size: 16)
        priceL.textColor = kDefaultThemeColor
        
        let divi = UIView()
        contaiV.addSubview(divi)
        divi.snp.updateConstraints { (make) in
            make.left.right.bottom.equalTo(contaiV)
            make.height.equalTo(10)
        }
        divi.backgroundColor = kdivisionColor
        
        //选择支付方式
        let containerV = UIView.init(frame: CGRect.init(x: 0, y: 180, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        containerV.backgroundColor = UIColor.white
        self.view.addSubview(containerV)
        
        let chooseL = UILabel.init(frame: CGRect.init(x: 20, y: 20, width: 100, height: 20))
        containerV.addSubview(chooseL)
        chooseL.font = UIFont.init(name: kReguleFont, size: 12)
        chooseL.textColor = kLightTextColor
        chooseL.text = "选择支付方式"
        
        let alipayImgV = UIImageView()
        containerV.addSubview(alipayImgV)
        alipayImgV.snp.updateConstraints { (make) in
            make.left.equalTo(chooseL)
            make.top.equalTo(chooseL.snp.bottom).offset(20)
            make.width.height.equalTo(30)
        }
        alipayImgV.image = UIImage.init(named: "支付宝")
        alipayImgV.contentMode = .scaleAspectFit
        
        let alipayL = UILabel()
        containerV.addSubview(alipayL)
        alipayL.snp.updateConstraints { (make) in
            make.centerY.equalTo(alipayImgV)
            make.left.equalTo(alipayImgV.snp.right).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(80)
        }
        alipayL.font = UIFont.init(name: kReguleFont, size: 16)
        alipayL.textColor = kTextColor
        alipayL.text = "支付宝"
        
        containerV.addSubview(alipayBtn)
        alipayBtn.snp.updateConstraints { (make) in
            make.centerY.equalTo(alipayImgV)
            make.right.equalTo(containerV).offset(-20)
            make.width.height.equalTo(30)
        }
        alipayBtn.setImage(UIImage.init(named: "未选中"), for: .normal)
        alipayBtn.setImage(UIImage.init(named: "选中"), for: .selected)
        alipayBtn.tag = 0
        alipayBtn.addTarget(self, action: #selector(ConfirmOrderViewController.chooseTool), for: .touchUpInside)
        
        let diviV = UIView()
        containerV.addSubview(diviV)
        diviV.snp.updateConstraints { (make) in
            make.left.equalTo(containerV).offset(20)
            make.bottom.equalTo(alipayImgV).offset(10)
            make.width.equalTo(SCREEN_WIDTH - 40)
            make.height.equalTo(0.5)
        }
        diviV.backgroundColor = klightGrayColor
    
        
        let weixinImgV = UIImageView()
        containerV.addSubview(weixinImgV)
        weixinImgV.snp.updateConstraints { (make) in
            make.left.width.height.equalTo(alipayImgV)
            make.top.equalTo(alipayImgV.snp.bottom).offset(20)
        }
        weixinImgV.image = UIImage.init(named: "微信支付")
        weixinImgV.contentMode = .scaleAspectFit
        
        let weixinL = UILabel()
        containerV.addSubview(weixinL)
        weixinL.snp.updateConstraints { (make) in
            make.centerY.equalTo(weixinImgV)
            make.left.equalTo(weixinImgV.snp.right).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(80)
        }
        weixinL.font = UIFont.init(name: kReguleFont, size: 16)
        weixinL.textColor = kTextColor
        weixinL.text = "微信支付"

        containerV.addSubview(weixinBtn)
        weixinBtn.snp.updateConstraints { (make) in
            make.centerY.equalTo(weixinImgV)
            make.right.equalTo(containerV).offset(-20)
            make.width.height.equalTo(30)
        }
        weixinBtn.setImage(UIImage.init(named: "未选中"), for: .normal)
        weixinBtn.setImage(UIImage.init(named: "选中"), for: .selected)
        weixinBtn.tag = 1
        weixinBtn.addTarget(self, action: #selector(ConfirmOrderViewController.chooseTool), for: .touchUpInside)
        
        let divisionV = UIView()
        containerV.addSubview(divisionV)
        divisionV.snp.updateConstraints { (make) in
            make.left.right.bottom.equalTo(containerV)
            make.top.equalTo(weixinImgV.snp.bottom).offset(20)
        }
        divisionV.backgroundColor = klightGrayColor
        
        self.view.addSubview(payBtn)
        payBtn.snp.updateConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.height.equalTo(48)
            make.bottom.equalTo(self.view).offset(-space.bottomSpace)
        }
        payBtn.setTitle("确认支付", for: .normal)
        payBtn.titleLabel?.font = UIFont.init(name: kBoldFont, size: 16)
        payBtn.backgroundColor = kDefaultThemeColor
        
        payBtn.addTarget(self, action: #selector(ConfirmOrderViewController.pay), for: .touchUpInside)
    }
    

    @objc func chooseTool(btn : UIButton){
        defaultTool = btn.tag
    }
    
    @objc func pay(){
        
        if defaultTool == 0 {    //aliPay
            HCShowInfo(info: "咨询是免费的，请联系工作人员")
//            SVProgressHUD.show()
//            HttpRequestManager.shareIntance.HC_jiaYinPay(price: price!, type: "02") { [weak self](bool, dic) in
//                SVProgressHUD.dismiss()
//                if bool{
//                    if let payReq = dic!["appPayRequest"]{
//                        if let data = try? JSONSerialization.data(withJSONObject: payReq, options: .prettyPrinted){
//                            let s = String.init(data: data, encoding: String.Encoding.utf8)
//                            HCPrint(message: s)
//
//                            if let s = dic!["merOrderId"] as? String{
//                                HCPrint(message: s)
//                                self?.merOrderId = s
//                            }
//
//                            UnifyPayPluginManager.shareIntance.sendPayRequestWithResponse(payChannel: .unifyPayChannelAlipay, payStr: s!)
//                        }
//                    }
//                }
//            }
            
        }else{   //weixin
            HCShowInfo(info: "暂不支持微信支付")
//            SVProgressHUD.show()
//            HttpRequestManager.shareIntance.HC_jiaYinPay(price: price!, type: "01") { (bool, dic) in
//                SVProgressHUD.dismiss()
//                if bool{
//                    if let payReq = dic!["appPayRequest"]{
//                        if let data = try? JSONSerialization.data(withJSONObject: payReq, options: .prettyPrinted){
//                            let s = String.init(data: data, encoding: String.Encoding.utf8)
//                            HCPrint(message: s)
//
//                            UnifyPayPluginManager.shareIntance.sendPayRequestWithResponse(payChannel: .unifyPayChannelWXPay, payStr: s!)
//                        }
//                    }
//                }
//            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
