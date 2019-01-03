//
//  AuthenticationViewController.swift
//  aileyun
//
//  Created by huchuang on 2018/7/22.
//  Copyright © 2018年 huchuang. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "实名认证"
        self.view.backgroundColor = kDefaultThemeColor
        
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func initUI(){
        
        let space = AppDelegate.shareIntance.space
        
        let scrollV = UIScrollView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 44))
        scrollV.backgroundColor = klightGrayColor
        scrollV.contentSize = CGSize.init(width: 0, height: SCREEN_HEIGHT * 1.2)
        
        self.view.addSubview(scrollV)
        
        let titleL = UILabel.init()
        scrollV.addSubview(titleL)
        titleL.snp.updateConstraints { (make) in
            make.centerX.equalTo(scrollV)
            make.top.equalTo(scrollV).offset(100)
        }
        titleL.font = UIFont.init(name: kReguleFont, size: kTextSize + 10)
        titleL.text = "已认证"
        
        let cancelBtn = UIButton.init()
        scrollV.addSubview(cancelBtn)
        cancelBtn.snp.updateConstraints { (make) in
            make.top.equalTo(titleL.snp.bottom).offset(100)
            make.left.equalTo(scrollV).offset(20)
            make.width.equalTo(SCREEN_WIDTH - 40)
        }
        cancelBtn.setTitle("取消认证", for: .normal)
        cancelBtn.backgroundColor = kDefaultThemeColor
        cancelBtn.layer.cornerRadius = 5
        
        cancelBtn.addTarget(self, action: #selector(AuthenticationViewController.cancelAuth), for: .touchUpInside)
        
    
        
        let attentionL = UILabel()
        scrollV.addSubview(attentionL)
        attentionL.snp.updateConstraints { (make) in
            make.bottom.equalTo(scrollV.snp.top).offset(SCREEN_HEIGHT - space.bottomSpace - space.topSpace - 80)
            make.left.equalTo(scrollV).offset(20)
            make.width.equalTo(SCREEN_WIDTH - 40)
        }
        attentionL.numberOfLines = 0
        attentionL.font = UIFont.init(name: kReguleFont, size: kTextSize - 1)
        attentionL.textColor = kLightTextColor
        
        let attStr = NSMutableAttributedString.init(string: "注意事项：\n1、只有在佳音医院云门诊系统进行过登记的患者才能认证通过\n2、认证成功后，可以直接在APP内查看医嘱、检查检验结果、充值记录等信息\n3、认证成功后，可以在APP内查看未缴费清单并进行在线缴费\n4、认证失败时，请前往佳音医院门诊信息登记处进行资料修改后进行重新认证")
        
        let paraStyle = NSMutableParagraphStyle.init()
        paraStyle.lineSpacing = 3
        paraStyle.paragraphSpacing = 3
        paraStyle.headIndent = 20
        attStr.addAttribute(NSParagraphStyleAttributeName, value: paraStyle, range: NSRange.init(location: 0, length: attStr.length))
        
        attentionL.attributedText = attStr
        attentionL.sizeToFit()
        
    }

    func cancelAuth(){
        HttpRequestManager.shareIntance.HC_unbindJIAYIN { (success, msg) in
            if success == true{
                HCShowInfo(info: msg)
                UserManager.shareIntance.deleteCard()
                let not = Notification.init(name: NSNotification.Name.init(UPDATE_USER_INFO), object: nil, userInfo: nil)
                NotificationCenter.default.post(not)
                self.navigationController?.popViewController(animated: true)
            }else{
                HCShowError(info: msg)
            }
            
        }
    }
}

