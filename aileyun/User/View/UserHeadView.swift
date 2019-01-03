//
//  UserHeadView.swift
//  aileyun
//
//  Created by huchuang on 2017/8/3.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD

class UserHeadView: UIView {
    weak var naviVC : UINavigationController?
    
//    var doctorAdvice : String?

    let headImgV = UIImageView()
    let phoneL = UILabel()
    let attentionL = UILabel()
    
//    let fansL = UILabel()
    
//    let appointmentBtn = UserFunctionButton()
//    let consultBtn = UserFunctionButton()
//    let collectBtn = UserFunctionButton()
    
    var userM : HCUserModel? {
        didSet{
            
            phoneL.text = userM?.realname ?? "昵称未填写"
            
            attentionL.text = userM?.visitCard ?? "（无就诊卡信息）"
            
            
            if let imgS = UserManager.shareIntance.HCUserInfo?.imgUrl{
                headImgV.HC_setImageFromURL(urlS: imgS, placeHolder: "默认头像")
            }else{
                headImgV.image = UIImage.init(named: "默认头像")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let containerV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 100))
        containerV.backgroundColor = kDefaultThemeColor
        self.addSubview(containerV)
        
        let tapG = UITapGestureRecognizer.init(target: self, action: #selector(UserHeadView.userInfo))
        containerV.addGestureRecognizer(tapG)
        
        containerV.addSubview(headImgV)
        headImgV.snp.updateConstraints { (make) in
            make.left.equalTo(containerV).offset(20)
            make.top.equalTo(containerV).offset(20)
            make.width.height.equalTo(60)
        }
        headImgV.layer.cornerRadius = 30
        headImgV.clipsToBounds = true
        headImgV.contentMode = UIViewContentMode.scaleAspectFill
        
        containerV.addSubview(phoneL)
        phoneL.snp.updateConstraints { (make) in
            make.left.equalTo(headImgV.snp.right).offset(20)
            make.bottom.equalTo(headImgV.snp.centerY).offset(-5)
            make.height.equalTo(20)
            make.width.equalTo(150)
        }
        phoneL.font = UIFont.init(name: kBoldFont, size: kTextSize + 2)
        phoneL.textColor = UIColor.white
        
        let titleL = UILabel()
        containerV.addSubview(titleL)
        titleL.snp.updateConstraints { (make) in
            make.left.equalTo(phoneL)
            make.top.equalTo(headImgV.snp.centerY).offset(5)
            make.height.equalTo(15)
        }
        titleL.font = UIFont.init(name: kReguleFont, size: kTextSize - 2)
        titleL.textColor = UIColor.white
        titleL.text = "就诊卡号："
        
        containerV.addSubview(attentionL)
        attentionL.snp.updateConstraints { (make) in
            make.left.equalTo(titleL.snp.right).offset(10)
            make.centerY.height.equalTo(titleL)
        }
        attentionL.font = UIFont.init(name: kReguleFont, size: kTextSize - 2)
        attentionL.textColor = UIColor.white
        
        let rightImgV = UIImageView()
        containerV.addSubview(rightImgV)
        rightImgV.snp.updateConstraints {(make) in
            make.right.equalTo(containerV).offset(-20)
            make.centerY.equalTo(headImgV)
            make.width.height.equalTo(40)
        }
        rightImgV.contentMode = UIViewContentMode.right
        rightImgV.image = UIImage.init(named: "userRight")
        
        
//        let containerV2 = UIView.init(frame: CGRect.init(x: 0, y: 100, width: SCREEN_WIDTH, height: 80))
//        containerV2.backgroundColor = kdivisionColor
//        self.addSubview(containerV2)
//
//        let width = (SCREEN_WIDTH - 2) / 3
//        containerV2.addSubview(appointmentBtn)
//        appointmentBtn.snp.updateConstraints { (make) in
//            make.left.top.bottom.equalTo(containerV2)
//            make.width.equalTo(width)
//        }
//        appointmentBtn.setTitle("我的预约", for: UIControlState.normal)
//        appointmentBtn.setImage(UIImage.init(named: "预约"), for: UIControlState.normal)
//
//        appointmentBtn.addTarget(self, action: #selector(UserHeadView.register), for: UIControlEvents.touchUpInside)
//
//        containerV2.addSubview(consultBtn)
//        consultBtn.snp.updateConstraints { (make) in
//            make.left.equalTo(appointmentBtn.snp.right).offset(1)
//            make.top.bottom.equalTo(containerV2)
//            make.width.equalTo(width)
//        }
//        consultBtn.setTitle("问诊记录", for: UIControlState.normal)
//        consultBtn.setImage(UIImage.init(named: "问诊"), for: UIControlState.normal)
//
//        consultBtn.addTarget(self, action: #selector(UserHeadView.consult), for: .touchUpInside)
//
//        containerV2.addSubview(collectBtn)
//        collectBtn.snp.updateConstraints { (make) in
//            make.left.equalTo(consultBtn.snp.right).offset(1)
//            make.top.bottom.equalTo(containerV2)
//            make.width.equalTo(width)
//        }
//        collectBtn.setTitle("我的收藏", for: UIControlState.normal)
//        collectBtn.setImage(UIImage.init(named: "收藏"), for: UIControlState.normal)
//
//        collectBtn.addTarget(self, action: #selector(UserHeadView.myCollect), for: UIControlEvents.touchUpInside)
        
    }

    
    func userInfo(){
        let infoVC = UserInfoViewController()
        naviVC?.pushViewController(infoVC, animated: true)
    }
    
 
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
