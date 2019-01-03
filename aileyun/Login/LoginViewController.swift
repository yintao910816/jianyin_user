//
//  LoginViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/6/19.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {
    
    
    let containerV = UIView.init()
    
    let aileyunImgV = UIImageView.init(image: UIImage.init(named: shareImgName))
    
    lazy var gradientL : CAGradientLayer = {
        let l = CAGradientLayer.init()
        l.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 100)
        let pingColor = kDefaultThemeColor
        l.colors = [pingColor.cgColor, UIColor.white.cgColor]
        return l
    }()
    
    let cellphoneTF = UITextField()
    let verifyTF = UITextField()
    let verifyBtn = UIButton()
    
    var count = 0
    let KMaxSeconds = 60
    
    var timer : Timer?
    
    let infoBtn = UIButton.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        observeKeyboard()
        
        self.view.layer.addSublayer(gradientL)
        
        initLoginV()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = kTextColor
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        timer?.invalidate()
    }
    
    func initLoginV(){
        containerV.frame = CGRect.init(x: 0, y: 100, width: SCREEN_WIDTH, height: 400)
        self.view.addSubview(containerV)
        
        containerV.addSubview(aileyunImgV)
        aileyunImgV.snp.updateConstraints { (make) in
            make.left.right.top.equalTo(containerV)
            make.height.equalTo(120)
        }
        aileyunImgV.contentMode = UIViewContentMode.scaleAspectFit
        
        let headL = UILabel()
        containerV.addSubview(headL)
        headL.snp.updateConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(20)
            make.left.equalTo(containerV).offset(40)
            make.top.equalTo(aileyunImgV.snp.bottom).offset(40)
        }
        headL.text = "登录名"
        headL.font = UIFont.init(name: kReguleFont, size: 16)
        headL.textColor = kTextColor
        
        containerV.addSubview(cellphoneTF)
        cellphoneTF.snp.updateConstraints { (make) in
            make.centerY.equalTo(headL)
            make.left.equalTo(headL.snp.right).offset(10)
            make.right.equalTo(containerV).offset(-40)
            make.height.equalTo(20)
        }
        cellphoneTF.placeholder = "输入手机号"
        cellphoneTF.font = UIFont.init(name: kReguleFont, size: 16)
        cellphoneTF.textColor = kTextColor
        cellphoneTF.textAlignment = NSTextAlignment.right
        cellphoneTF.keyboardType = UIKeyboardType.numberPad
        cellphoneTF.clearButtonMode = .whileEditing
        cellphoneTF.text = UserDefaults.standard.value(forKey: kUserPhone) as? String
        
        let divisionV = UIView()
        containerV.addSubview(divisionV)
        divisionV.snp.updateConstraints { (make) in
            make.top.equalTo(headL.snp.bottom).offset(10)
            make.left.equalTo(containerV).offset(40)
            make.right.equalTo(containerV).offset(-40)
            make.height.equalTo(1)
        }
        divisionV.backgroundColor = kdivisionColor
        
        
        let verifyL = UILabel()
        containerV.addSubview(verifyL)
        verifyL.snp.updateConstraints { (make) in
            make.left.equalTo(containerV).offset(40)
            make.top.equalTo(divisionV.snp.bottom).offset(25)
            make.width.equalTo(60)
            make.height.equalTo(20)
        }
        verifyL.text = "验证码"
        verifyL.font = UIFont.init(name: kReguleFont, size: 16)
        verifyL.textColor = kTextColor
        
        
        containerV.addSubview(verifyBtn)
        verifyBtn.snp.updateConstraints { (make) in
            make.right.equalTo(containerV).offset(-40)
            make.centerY.equalTo(verifyL)
            make.width.equalTo(90)
            make.height.equalTo(30)
        }
        verifyBtn.setTitle("获取验证码", for: UIControlState.normal)
        verifyBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: 13)
        verifyBtn.backgroundColor = kDefaultThemeColor
        verifyBtn.layer.cornerRadius = 5
        
        verifyBtn.addTarget(self, action: #selector(LoginViewController.startCount), for: UIControlEvents.touchUpInside)
        
        
        containerV.addSubview(verifyTF)
        verifyTF.snp.updateConstraints { (make) in
            make.centerY.equalTo(verifyL)
            make.left.equalTo(verifyL.snp.right)
            make.right.equalTo(verifyBtn.snp.left).offset(-8)
            make.height.equalTo(20)
        }
        verifyTF.placeholder = "输入验证码"
        verifyTF.font = UIFont.init(name: kReguleFont, size: 14)
        verifyTF.textColor = kTextColor
        verifyTF.keyboardType = UIKeyboardType.numberPad
        verifyTF.textAlignment = NSTextAlignment.right
        
        
        
        let diviV = UIView()
        containerV.addSubview(diviV)
        diviV.snp.updateConstraints { (make) in
            make.top.equalTo(verifyL.snp.bottom).offset(10)
            make.left.equalTo(containerV).offset(40)
            make.right.equalTo(containerV).offset(-40)
            make.height.equalTo(1)
        }
        diviV.backgroundColor = kdivisionColor
        
        
        let infoL = UILabel.init()
        containerV.addSubview(infoL)
        infoL.snp.updateConstraints { (make) in
            make.top.equalTo(diviV.snp.bottom).offset(30)
            make.right.equalTo(containerV.snp.centerX)
        }
        infoL.text = "获取不到验证码？"
        infoL.font = UIFont.init(name: kReguleFont, size: kTextSize - 4)
        infoL.textColor = kTextColor
        
        
        containerV.addSubview(infoBtn)
        infoBtn.snp.updateConstraints { (make) in
            make.centerY.equalTo(infoL)
            make.left.equalTo(infoL.snp.right)
            make.width.equalTo(76)
            make.height.equalTo(24)
        }
        infoBtn.setTitle("语音验证码", for: .normal)
        infoBtn.setTitleColor(kDefaultThemeColor, for: .normal)
        infoBtn.layer.borderColor = kDefaultThemeColor.cgColor
        infoBtn.layer.borderWidth = 1
        infoBtn.layer.cornerRadius = 5
        infoBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: kTextSize - 4)
        
        infoBtn.addTarget(self, action: #selector(LoginViewController.checkForVoiceAction), for: .touchUpInside)
        
        
        
        let loginBtn = UIButton()
        containerV.addSubview(loginBtn)
        loginBtn.snp.updateConstraints { (make) in
            make.top.equalTo(infoL.snp.bottom).offset(30)
            make.left.equalTo(containerV).offset(40)
            make.right.equalTo(containerV).offset(-40)
            make.height.equalTo(40)
        }
        loginBtn.setTitle("登 录", for: UIControlState.normal)
        loginBtn.layer.cornerRadius = 10
        loginBtn.backgroundColor = kDefaultThemeColor
        
        loginBtn.addTarget(self, action: #selector(LoginViewController.login), for: UIControlEvents.touchUpInside)
        
        #if DEBUG
        cellphoneTF.text = "18672345930"
        verifyTF.text = "8888"
        #endif

    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        HCPrint(message: "touch begin")
        self.view.endEditing(true)
        
        var rect = containerV.frame
        rect.origin.y = 100
        UIView.animate(withDuration: 0.25) {[weak self]()in
            self?.containerV.frame = rect
            self?.aileyunImgV.alpha = 1
        }
    }
    
    func checkForVoiceAction(){
        
        guard checkIsPhone(cellphoneTF.text!) else{
            HCShowError(info: "请输入正确的手机号码！")
            return
        }
        
        let alertController = UIAlertController(title: "提醒",
                                                message: "没有获取到验证码？点击语音验证码后请注意接听电话", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "语音验证码", style: .default, handler: {[weak self](action)->() in
            self?.getVoiceCode()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func getVoiceCode(){
        infoBtn.isEnabled = false
        
        SVProgressHUD.show(withStatus: "获取中...")
        HttpRequestManager.shareIntance.HC_validateCodeYY(phone: cellphoneTF.text!, callback: {[weak self](success, message) in
            SVProgressHUD.dismiss()
            if success {
                HCShowInfo(info: "获取成功，稍等电话通知")
                self?.count = 0
                
                if let t = self?.timer{
                    t.invalidate()
                    self?.resetCodeBtn()
                }
                
                self?.timer = Timer.scheduledTimer(timeInterval: 1, target: self!, selector: #selector(LoginViewController.voiceShowSecond), userInfo: nil, repeats: true)
            }else{
                HCShowError(info: message)
                self?.infoBtn.isEnabled = true
            }
        })
    }
    
    func voiceShowSecond(){
        count = count + 1
        if count == KMaxSeconds {
            resetVoiceBtn()
            timer?.invalidate()
        }else{
            let showString = String.init(format: "%ds重新获取", KMaxSeconds - count)
            infoBtn.setTitle(showString, for: UIControlState.normal)
            infoBtn.setTitleColor(UIColor.white, for: .normal)
            infoBtn.backgroundColor = kLightTextColor
        }
    }
    
    func resetVoiceBtn(){
        infoBtn.isEnabled = true
        infoBtn.setTitle("语音验证码", for: UIControlState.normal)
        infoBtn.setTitleColor(kDefaultThemeColor, for: .normal)
        infoBtn.backgroundColor = UIColor.white
    }
    
    
    
    func startCount(){
        
        guard checkIsPhone(cellphoneTF.text!) else{
            HCShowError(info: "请输入正确的手机号码！")
            return
        }

        verifyBtn.isEnabled = false

        SVProgressHUD.show(withStatus: "获取中...")
        HttpRequestManager.shareIntance.HC_validateCode(phone: cellphoneTF.text!, callback: { [weak self](success, message) in
            SVProgressHUD.dismiss()
            if success {
                HCShowInfo(info: "获取验证码成功！")
                self?.count = 0
                
                if let t = self?.timer{
                    t.invalidate()
                    self?.resetVoiceBtn()
                }

                self?.timer = Timer.scheduledTimer(timeInterval: 1, target: self!, selector: #selector(LoginViewController.showSecond), userInfo: nil, repeats: true)
            }else{
                HCShowError(info: message)
                self?.verifyBtn.isEnabled = true
            }
        })
    }
    
    
    func showSecond(){
        count = count + 1
        if count == KMaxSeconds {
            resetCodeBtn()
            timer?.invalidate()
        }else{
            let showString = String.init(format: "%ds重新请求", KMaxSeconds - count)
            verifyBtn.setTitle(showString, for: UIControlState.normal)
            verifyBtn.backgroundColor = kLightTextColor
        }
    }

    
    func resetCodeBtn(){
        verifyBtn.isEnabled = true
        verifyBtn.setTitle("获取验证码", for: UIControlState.normal)
        verifyBtn.backgroundColor = kDefaultThemeColor
    }
    
    func login(){
        
        guard cellphoneTF.text != "" && cellphoneTF.text != nil else {
            HCShowError(info: "请输入手机号码！")
            return
        }
        guard verifyTF.text != "" && verifyTF.text != nil else {
            HCShowError(info: "请输入密码！")
            return
        }

        SVProgressHUD.show()
        
        HttpRequestManager.shareIntance.HC_login(uname: cellphoneTF.text!, code: verifyTF.text!) { [weak self](bool, msg) in
            if bool == true{
                UserDefaults.standard.set(self?.cellphoneTF.text!, forKey: kUserPhone)
                
                HttpRequestManager.shareIntance.HC_userInfo(callback: { (success, msg) in
                    if success == true {
                        SVProgressHUD.dismiss()
                        UIApplication.shared.keyWindow?.rootViewController = MainTabBarController()
                    }else{
                        HCShowError(info: msg)
                    }
                })
            }else{
                HCShowError(info: msg)
            }
        }
    
    }


    func observeKeyboard() -> () {
        //注册键盘出现的通知
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    func keyboardShow() -> () {
        
        var rect = containerV.frame
        rect.origin.y = 0
        UIView.animate(withDuration: 0.25) {[weak self]()in
            self?.containerV.frame = rect
            self?.aileyunImgV.alpha = 0
        }
    }
    
}
