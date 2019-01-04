//
//  UserManager.swift
//  pregnancyForD
//
//  Created by pg on 2017/4/25.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit
import SVProgressHUD
import WebKit

class UserManager: NSObject {
    //之前的接口获取
    var localUser : LocalUserModel?
    //微信对应
    var currentUser : UserModel?
    var UserInfoModel : UserInfoModel?
    //QQ对应
    var QQModel : UserQQModel?
    
    
    //新设计的接口
    var HCUser : HCUserModel? {
        didSet{
            if HCUser != nil{
                HCPrint(message: "registerRemoteNotification")
                UMessage.registerForRemoteNotifications()
            }else{
                HCPrint(message: "unregisterRemoteNotification")
                UMessage.unregisterForRemoteNotifications()
            }
        }
    }
    
    var HCUserInfo : HCUserInfoModel?

    var BindedModel : BindedModel?
    
    
    var treatURLStr : String?
    
    
    
    // 设计成单例
    static let shareIntance : UserManager = {
        let tools = UserManager()
        return tools
    }()

    
    func updateUserInfo(showHud: Bool = true, callback : @escaping (Bool)->()){
        SVProgressHUD.show()
        HttpRequestManager.shareIntance.HC_userInfo(callback: { (success, msg) in
            if success == true {
                SVProgressHUD.dismiss()
                callback(true)
            }else{
                callback(false)
            }
        })
    }
    
    func deleteCard(){
        HCUser?.visitCard = nil
        
        let dic = UserDefaults.standard.value(forKey: kUserDic) as? [String : Any]
        if var dic = dic{
            dic["visitCard"] = ""
            UserDefaults.standard.set(dic, forKey: kUserDic)
        }
    }
    
    
    
    func logout(){
        HttpClient.shareIntance.cancelAllRequest()
        
        //清理缓存
        if #available(iOS 9.0, *) {
            let types = WKWebsiteDataStore.allWebsiteDataTypes()
            let dateForm = Date.init(timeIntervalSince1970: 0)
            WKWebsiteDataStore.default().removeData(ofTypes: types, modifiedSince: dateForm, completionHandler: {
                HCPrint(message: "clear cache")
            })
        }
        
        //注销推送
        UserManager.shareIntance.HCUser = nil
        UserManager.shareIntance.HCUserInfo = nil
        UserManager.shareIntance.BindedModel = nil
        
        //清空用户信息
        UserDefaults.standard.removeObject(forKey: kUserDic)
        UserDefaults.standard.removeObject(forKey: kUserInfoDic)
        UserDefaults.standard.removeObject(forKey: kBindDic)
        
        UserDefaults.standard.removeObject(forKey: kBBSToken)
        
        //跳转登录界面
        UIApplication.shared.keyWindow?.rootViewController = BaseNavigationController.init(rootViewController: LoginViewController())
    }
    
    
}

extension UserManager {
    
    @discardableResult
    func realName(authentication navigationController: UINavigationController?) ->Bool{
        if UserManager.shareIntance.HCUser?.visitCard != nil && UserManager.shareIntance.HCUser?.visitCard != "" {
            return true
        }
        if let _ =  UserManager.shareIntance.HCUser?.token {
            let webVC = WebViewController()
            webVC.url = REALNAME_AUTHOR
            navigationController?.pushViewController(webVC, animated: true)
        }else {
            SVProgressHUD.showInfo(withStatus: "请重新登录")
        }
        return false
    }
}
