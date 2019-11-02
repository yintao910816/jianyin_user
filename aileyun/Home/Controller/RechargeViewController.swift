//
//  RechargeViewController.swift
//  aileyun
//
//  Created by huchuang on 2018/5/6.
//  Copyright © 2018年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD

class RechargeViewController: BaseViewController {

    let hospiCardL = UILabel()
    
    let balanceL = UILabel()
    
    let cardBtn = UIButton.init()
    let hospitalBtn = UIButton.init()
    
    var defaultPurpose : NSInteger? {
        didSet{
            if defaultPurpose == 1 {
                cardBtn.isSelected = true
                hospitalBtn.isSelected = false
            }else{
                cardBtn.isSelected = false
                hospitalBtn.isSelected = true
            }
        }
    }
    
    var patientStyle : NSInteger?{
        didSet{
            defaultPurpose = patientStyle
            if patientStyle == 1 {
                hospitalBtn.isEnabled = false
            }else{
                hospitalBtn.isEnabled = true
            }
        }
    }
    
    let priceTF = HCTextField()
    
    let alipayBtn = UIButton()
    let weixinBtn = UIButton()
    let payBtn = UIButton()
    
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
        
        self.navigationItem.title = "在线充值"
        
        initUI()
        
        setData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(RechargeViewController.checkPayResult), name: NSNotification.Name.init(DID_BECOME_ACTIVE), object: nil)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func checkPayResult(){
        if let s = merOrderId{    // "3194201805161052221379905827"
            SVProgressHUD.show()
            UnifyPayPluginManager.shareIntance.checkPayResult(merOrderId: s) { [weak self](bool) in
                SVProgressHUD.dismiss()
                
                let payType = self?.defaultTool == 0 ? "支付宝支付" : "微信支付"
                let rechargeResultCtrl = RechargeResultViewController.init(nibName: "RechargeResultViewController", bundle: Bundle.main)
                if bool{
//                    HCShowInfo(info: "支付成功")
//                    self?.navigationController?.popViewController(animated: true)
                    rechargeResultCtrl.set(orderNum: s, payType: payType, payMoney: self?.priceTF.text ?? "0.0", payState: true)
                }else{
                    HCShowError(info: "未完成支付")
                    rechargeResultCtrl.set(orderNum: s, payType: payType, payMoney: self?.priceTF.text ?? "0.0", payState: false)
                }
                
                self?.navigationController?.pushViewController(rechargeResultCtrl, animated: true)
            }
        }
    }
    
    func setData(){
        hospiCardL.text = UserManager.shareIntance.HCUser?.visitCard
        defaultTool = 0
        
        
        let queue = DispatchQueue.global()
        let group = DispatchGroup.init()
        
        SVProgressHUD.show()
        
        queue.async(group: group, qos: .default, flags: []) {
            HttpRequestManager.shareIntance.HC_cardBalance { [weak self](success, info) in
                if success == true{
                    self?.balanceL.text = String.init(format: "(余额：%@元)", info)
                }else{
                    self?.balanceL.text = "(余额：0元)"
                }
            }
        }
        
        queue.async(group: group, qos: .default, flags: []) {
            let cardNo = UserManager.shareIntance.HCUser?.visitCard ?? ""
            HttpRequestManager.shareIntance.HC_rechargeType(cardNo: cardNo) { [weak self](success, info) in
                if success == true{
                    self?.patientStyle = info == "2" ? 2 : 1
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            SVProgressHUD.dismiss()
        }
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func initUI(){
        let space = AppDelegate.shareIntance.space
        let backgroundV = UIView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        backgroundV.backgroundColor = kdivisionColor
        self.view.addSubview(backgroundV)
        
        let contaiV = UIView.init(frame: CGRect.init(x: 0, y: 5, width: SCREEN_WIDTH, height: 150))
        contaiV.backgroundColor = UIColor.white
        backgroundV.addSubview(contaiV)
        
        let cardL = UILabel.init()
        contaiV.addSubview(cardL)
        cardL.snp.updateConstraints { (make) in
            make.left.top.equalTo(contaiV).offset(20)
            make.height.equalTo(30)
        }
        cardL.font = UIFont.init(name: kReguleFont, size: kTextSize)
        cardL.textColor = kTextColor
        cardL.text = "就诊卡号:"
        
        contaiV.addSubview(hospiCardL)
        hospiCardL.snp.updateConstraints { (make) in
            make.left.equalTo(cardL.snp.right).offset(15)
            make.centerY.height.equalTo(cardL)
        }
        hospiCardL.font = UIFont.init(name: kReguleFont, size: kTextSize)
        hospiCardL.textColor = kTextColor
        
        contaiV.addSubview(balanceL)
        balanceL.snp.updateConstraints { (make) in
            make.left.equalTo(hospiCardL.snp.right).offset(5)
            make.centerY.equalTo(cardL)
        }
        balanceL.font = UIFont.init(name: kReguleFont, size: kTextSize - 2)
        balanceL.textColor = kLightTextColor
        
        let purposeL = UILabel.init()
        contaiV.addSubview(purposeL)
        purposeL.snp.updateConstraints { (make) in
            make.left.equalTo(cardL)
            make.top.equalTo(cardL.snp.bottom).offset(5)
            make.height.equalTo(30)
        }
        purposeL.font = UIFont.init(name: kReguleFont, size: kTextSize)
        purposeL.textColor = kTextColor
        purposeL.text = "充值去向:"
        
        
        contaiV.addSubview(cardBtn)
        cardBtn.snp.updateConstraints { (make) in
            make.left.equalTo(purposeL.snp.right).offset(15)
            make.centerY.equalTo(purposeL)
            make.height.equalTo(20)
            make.width.equalTo(90)
        }
        cardBtn.setTitle("门诊充值", for: .normal)
        cardBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: kTextSize - 2)
        cardBtn.setTitleColor(kTextColor, for: .normal)
        cardBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        cardBtn.setImage(UIImage.init(named: "unselected"), for: .normal)
        cardBtn.setImage(UIImage.init(named: "selected"), for: .selected)
        cardBtn.tag = 1
        
        cardBtn.addTarget(self, action: #selector(RechargeViewController.selectPurpose), for: .touchUpInside)
        
        

        contaiV.addSubview(hospitalBtn)
        hospitalBtn.snp.updateConstraints { (make) in
            make.left.equalTo(cardBtn.snp.right).offset(10)
            make.centerY.equalTo(purposeL)
            make.height.equalTo(20)
            make.width.equalTo(90)
        }
        hospitalBtn.setTitle("住院押金", for: .normal)
        hospitalBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: kTextSize - 2)
        hospitalBtn.setTitleColor(kTextColor, for: .normal)
        hospitalBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        hospitalBtn.setImage(UIImage.init(named: "unselected"), for: .normal)
        hospitalBtn.setImage(UIImage.init(named: "selected"), for: .selected)
        hospitalBtn.tag = 2
        
        hospitalBtn.addTarget(self, action: #selector(RechargeViewController.selectPurpose), for: .touchUpInside)
        
        
        
        
        let priceL = UILabel.init()
        contaiV.addSubview(priceL)
        priceL.snp.updateConstraints { (make) in
            make.left.equalTo(cardL)
            make.top.equalTo(purposeL.snp.bottom).offset(5)
            make.height.equalTo(30)
            make.width.equalTo(80)
        }
        priceL.font = UIFont.init(name: kReguleFont, size: kTextSize)
        priceL.textColor = kTextColor
        priceL.text = "充值金额:"
        
        
        contaiV.addSubview(priceTF)
        priceTF.snp.updateConstraints { (make) in
            make.left.equalTo(priceL.snp.right).offset(5)
            make.right.equalTo(contaiV).offset(-20)
            make.centerY.equalTo(priceL)
            make.height.equalTo(30)
        }
        priceTF.textAlignment = .left
        priceTF.placeholder = "请输入金额"
        priceTF.backgroundColor = UIColor.init(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1)
        
        
        //选择支付方式
        let containerV = UIView.init()
        containerV.backgroundColor = UIColor.white
        backgroundV.addSubview(containerV)
        containerV.snp.updateConstraints { (make) in
            make.top.equalTo(contaiV.snp.bottom).offset(8)
            make.left.right.equalTo(backgroundV)
        }
        
        let chooseL = UILabel.init(frame: CGRect.init(x: 20, y: 10, width: 100, height: 20))
        containerV.addSubview(chooseL)
        chooseL.font = UIFont.init(name: kReguleFont, size: kTextSize - 2)
        chooseL.textColor = kLightTextColor
        chooseL.text = "支付方式"
        
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
        alipayBtn.setImage(UIImage.init(named: "unselected"), for: .normal)
        alipayBtn.setImage(UIImage.init(named: "selected"), for: .selected)
        alipayBtn.tag = 0
        alipayBtn.addTarget(self, action: #selector(RechargeViewController.chooseTool), for: .touchUpInside)
        
        let diviV = UIView()
        containerV.addSubview(diviV)
        diviV.snp.updateConstraints { (make) in
            make.left.equalTo(containerV).offset(20)
            make.bottom.equalTo(alipayImgV).offset(10)
            make.width.equalTo(SCREEN_WIDTH - 40)
            make.height.equalTo(1)
        }
        diviV.backgroundColor = kdivisionColor
        
        
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
        weixinBtn.setImage(UIImage.init(named: "unselected"), for: .normal)
        weixinBtn.setImage(UIImage.init(named: "selected"), for: .selected)
        weixinBtn.tag = 1
        weixinBtn.addTarget(self, action: #selector(RechargeViewController.chooseTool), for: .touchUpInside)
        
        let divisionV = UIView()
        containerV.addSubview(divisionV)
        divisionV.snp.updateConstraints { (make) in
            make.top.equalTo(weixinImgV.snp.bottom).offset(20)
            make.left.right.bottom.equalTo(containerV)
        }
        divisionV.backgroundColor = klightGrayColor
        
        
        let infoV = UIView.init()
        backgroundV.addSubview(infoV)
        infoV.snp.updateConstraints { (make) in
            make.top.equalTo(containerV.snp.bottom).offset(20)
            make.left.right.equalTo(backgroundV)
        }
        
        
        let infoL = UILabel.init()
        infoL.textColor = kLightTextColor
        infoL.font = UIFont.init(name: kReguleFont, size: kTextSize - 3)
        infoL.text = "就诊卡预付款仅限支付诊疗费用，不能在食堂消费"
        infoL.textAlignment = .center
        infoV.addSubview(infoL)
        infoL.snp.updateConstraints { (make) in
            make.top.equalTo(infoV)
            make.left.right.equalTo(infoV)
            make.height.equalTo(30)
        }
        
        let phoneL = UILabel.init()
        phoneL.textColor = kLightTextColor
        phoneL.font = UIFont.init(name: kReguleFont, size: kTextSize - 2)
        let phoneStr = NSMutableAttributedString.init(string: "如有疑问可到前台咨询或者拨打电话：" + KServicePhone)
        phoneStr.addAttributes([NSAttributedString.Key.foregroundColor : kDefaultThemeColor], range: NSRange.init(location: 17, length: 11))
        phoneL.attributedText = phoneStr
        phoneL.textAlignment = .center
        infoV.addSubview(phoneL)
        phoneL.snp.updateConstraints { (make) in
            make.top.equalTo(infoL.snp.bottom)
            make.left.right.bottom.equalTo(infoV)
            make.height.equalTo(30)
        }
        
        phoneL.isUserInteractionEnabled = true
        let tapG = UITapGestureRecognizer.init(target: self, action: #selector(RechargeViewController.callThePhone))
        phoneL.addGestureRecognizer(tapG)
        
        

        self.view.addSubview(payBtn)
        payBtn.snp.updateConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.height.equalTo(48)
            make.bottom.equalTo(self.view).offset(-space.bottomSpace)
        }
        payBtn.setTitle("确认支付", for: .normal)
        payBtn.titleLabel?.font = UIFont.init(name: kBoldFont, size: 16)
        payBtn.backgroundColor = kDefaultThemeColor
        
        payBtn.addTarget(self, action: #selector(RechargeViewController.pay), for: .touchUpInside)
    }
    
    @objc func selectPurpose(btn : UIButton) {
        defaultPurpose = btn.tag
    }
    
    @objc func callThePhone(){
        let s = "tel://" + KServicePhone
        if let u = URL.init(string: s){
            UIApplication.shared.openURL(u)
        }
    }
    
    
    @objc func chooseTool(btn : UIButton){
        defaultTool = btn.tag
    }
    
    @objc func pay(){
        
        let moneyS = priceTF.text
        
        guard moneyS != "" else{
            HCShowError(info: "请输入金额")
            return
        }
        
        guard defaultPurpose != nil else{
            HCShowError(info: "请选择充值去向")
            return
        }
        
        
        if patientStyle == 2{
            if defaultPurpose == 1{
                let alertController = UIAlertController(title: "充值提醒",
                                                        message: "您是住院用户，当前选择的是 门诊充值，请确认是否继续",
                                                        preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                let okAction = UIAlertAction(title: "确认", style: .default, handler: {(action)->() in
                    self.payWithMoney(money: moneyS!)
                })
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                
                UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
                
            }else{
                let alertController = UIAlertController(title: "充值提醒",
                                                        message: "您当前选择的是 住院充值，住院充值仅用于缴纳住院押金，请确认是否继续",
                                                        preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                let okAction = UIAlertAction(title: "确认", style: .default, handler: {(action)->() in
                    self.payWithMoney(money: moneyS!)
                })
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                
                UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
            }
        }else{
            self.payWithMoney(money: moneyS!)
        }
        
        
    }
    
    
    func payWithMoney(money : String){
        if defaultTool == 0 {    //aliPay
            SVProgressHUD.show()
            HttpRequestManager.shareIntance.HC_jiaYinPay(price: money, type: "02", preType : defaultPurpose!) { [weak self](bool, dic) in
                SVProgressHUD.dismiss()
                if bool{
                    if let payReq = dic!["appPayRequest"]{
                        if let data = try? JSONSerialization.data(withJSONObject: payReq, options: .prettyPrinted){
                            let s = String.init(data: data, encoding: String.Encoding.utf8)
                            HCPrint(message: s)
                            
                            if let s = dic!["merOrderId"] as? String{
                                HCPrint(message: s)
                                self?.merOrderId = s
                            }
                            
                            UnifyPayPluginManager.shareIntance.sendPayRequestWithResponse(payChannel: .unifyPayChannelAlipay, payStr: s!)
                        }
                    }
                }
            }
            
        }else{   //weixin
//            HCShowInfo(info: "暂不支持微信支付")
            SVProgressHUD.show()
            HttpRequestManager.shareIntance.HC_jiaYinPay(price: money, type: "01", preType : defaultPurpose!) { [weak self](bool, dic) in
                SVProgressHUD.dismiss()
                if bool{
                    if let payReq = dic!["appPayRequest"]{
                        if let data = try? JSONSerialization.data(withJSONObject: payReq, options: .prettyPrinted){
                            let s = String.init(data: data, encoding: String.Encoding.utf8)
                            HCPrint(message: s)
                            
                            if let s = dic!["merOrderId"] as? String{
                                HCPrint(message: s)
                                self?.merOrderId = s
                            }
                            
                            UnifyPayPluginManager.shareIntance.sendPayRequestWithResponse(payChannel: .unifyPayChannelWXPay, payStr: s!)
                        }
                    }
                }
            }
        }
    }
}

