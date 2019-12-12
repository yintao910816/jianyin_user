//
//  BindHospitalViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/8/2.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD
import HandyJSON

class BindHospitalViewController: UIViewController {
    
    var hospitalModel : HospitalListModel?
    
    let nameTextF = UITextField()
    let idNoTextF = UITextField()

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false

        self.navigationItem.title = "实名认证"
        self.view.backgroundColor = kDefaultThemeColor
        
        initUI()
        
        setModel()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setData()
    }
    
    
    func setModel(){
        let dic = NSDictionary.init(dictionary: ["id" : "191", "name" : "新疆佳音"])
        hospitalModel = JSONDeserializer<HospitalListModel>.deserializeFrom(dict: dic)

    }
    
    func setData(){
        idNoTextF.text = UserManager.shareIntance.HCUserInfo?.idNo
    }
    
    
    func initUI(){
        let space = AppDelegate.shareIntance.space
        
        let scrollV = UIScrollView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 44))
        scrollV.backgroundColor = klightGrayColor
        
        scrollV.contentSize = CGSize.init(width: 0, height: SCREEN_HEIGHT * 1.2)
    
        self.view.addSubview(scrollV)
        
        let containV = UIView.init(frame: CGRect.init(x: 0, y: 10, width: SCREEN_WIDTH, height: 110))
        containV.backgroundColor = UIColor.white
        scrollV.addSubview(containV)
        
        let hosL = UILabel()
        containV.addSubview(hosL)
        hosL.snp.updateConstraints { (make) in
            make.top.left.equalTo(containV).offset(20)
            make.height.equalTo(20)
            make.width.equalTo(80)
        }
        hosL.font = UIFont.init(name: kReguleFont, size: kTextSize)
        hosL.textColor = kTextColor
        hosL.text = "真实姓名"
        
        containV.addSubview(nameTextF)
        nameTextF.snp.updateConstraints { (make) in
            make.right.equalTo(containV).offset(-20)
            make.top.equalTo(hosL)
            make.height.equalTo(20)
            make.left.equalTo(hosL.snp.right)
        }
        nameTextF.font = UIFont.init(name: kReguleFont, size: kTextSize)
        nameTextF.textColor = kLightTextColor
        nameTextF.textAlignment = NSTextAlignment.right
        nameTextF.placeholder = "请输入姓名"
        
        let divisionV1 = UIView()
        containV.addSubview(divisionV1)
        divisionV1.snp.updateConstraints { (make) in
            make.left.equalTo(hosL)
            make.top.equalTo(hosL.snp.bottom).offset(10)
            make.width.equalTo(SCREEN_WIDTH - 40)
            make.height.equalTo(1)
        }
        divisionV1.backgroundColor = kdivisionColor
        
        let idNoL = UILabel()
        containV.addSubview(idNoL)
        idNoL.snp.updateConstraints { (make) in
            make.left.equalTo(hosL)
            make.top.equalTo(divisionV1.snp.bottom).offset(15)
            make.height.equalTo(20)
            make.width.equalTo(80)
        }
        idNoL.font = UIFont.init(name: kReguleFont, size: kTextSize)
        idNoL.textColor = kTextColor
        idNoL.text = "身份证号"

        
        containV.addSubview(idNoTextF)
        idNoTextF.snp.updateConstraints { (make) in
            make.right.equalTo(nameTextF)
            make.top.equalTo(idNoL)
            make.height.equalTo(20)
            make.left.equalTo(hosL.snp.right)
        }
        idNoTextF.font = UIFont.init(name: kReguleFont, size: kTextSize)
        idNoTextF.textColor = kTextColor
        idNoTextF.textAlignment = NSTextAlignment.right
        idNoTextF.placeholder = "请输入身份证号码"
        
        let divisionV2 = UIView()
        containV.addSubview(divisionV2)
        divisionV2.snp.updateConstraints { (make) in
            make.left.equalTo(hosL)
            make.top.equalTo(idNoL.snp.bottom).offset(10)
            make.width.equalTo(SCREEN_WIDTH - 40)
            make.height.equalTo(1)
        }
        divisionV2.backgroundColor = kdivisionColor
        
      
        let bindBtn = UIButton()
        scrollV.addSubview(bindBtn)
        bindBtn.snp.updateConstraints { (make) in
            make.top.equalTo(containV.snp.bottom).offset(20)
            make.left.equalTo(hosL)
            make.width.equalTo(SCREEN_WIDTH - 40)
            make.height.equalTo(40)
        }
        bindBtn.layer.cornerRadius = 5
        bindBtn.backgroundColor = kDefaultThemeColor
        bindBtn.setTitle("认证", for: .normal)
        bindBtn.addTarget(self, action: #selector(BindHospitalViewController.bindHospital), for: .touchUpInside)

        
        let attentionL = UILabel()
        attentionL.numberOfLines = 0
        attentionL.font = UIFont.init(name: kReguleFont, size: kTextSize - 1)
        attentionL.textColor = kLightTextColor

        let attStr = NSMutableAttributedString.init(string: "注意事项：\n1、只有在佳音医院云门诊系统进行过登记的患者才能认证通过\n2、认证成功后，可以直接在APP内查看医嘱、检查检验结果、充值记录等信息\n3、认证成功后，可以在APP内查看未缴费清单并进行在线缴费\n4、认证失败时，请前往佳音医院门诊信息登记处进行资料修改后进行重新认证")
        let paraStyle = NSMutableParagraphStyle.init()
        paraStyle.lineSpacing = 3
        paraStyle.paragraphSpacing = 3
        paraStyle.headIndent = 20
        attStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paraStyle, range: NSRange.init(location: 0, length: attStr.length))

        attentionL.attributedText = attStr
        attentionL.sizeToFit()

        scrollV.addSubview(attentionL)
        attentionL.snp.updateConstraints { (make) in
            make.top.equalTo(bindBtn.snp.bottom).offset(30)
            make.left.equalTo(bindBtn)
            make.width.equalTo(SCREEN_WIDTH - 40)
        }
    }
    
    
    func hospitalList(){
        self.view.endEditing(true)
    }
    
    @objc func bindHospital(){
        
        guard nameTextF.text != "" && nameTextF.text != nil else {
            HCShowError(info: "请输入姓名！")
            return
        }

        guard idNoTextF.text != "" && idNoTextF.text != nil else {
            HCShowError(info: "请输入身份证！")
            return
        }

        let p = UserManager.shareIntance.HCUser?.phone ?? ""
        HCPrint(message: p)

        SVProgressHUD.show()
        HttpRequestManager.shareIntance.HC_bindID(phone: p, idNo: idNoTextF.text!, realName: nameTextF.text!) { (success, msg) in
            SVProgressHUD.dismiss()
            if success == true{
                HCShowInfo(info: msg)
                self.navigationController?.popViewController(animated: true)
            }else{
                HCShowError(info: msg)
            }
        }
        
        
        
    }

    

}
