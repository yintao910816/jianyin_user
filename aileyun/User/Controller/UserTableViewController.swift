//
//  UserTableViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/6/16.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD

class UserTableViewController: UIViewController {

    let reuseIdentifier = "reuseIdentifier"
    
    let titleArr : [[String]] = [["实名认证"], ["我的预约", "我的排号", "我的咨询", "我的健康卡"], ["通知消息", "意见反馈"]]
    
    var feedbackURL : String?
    var myQueueURL : String?
    
    lazy var tableView : UITableView = {
        let space = AppDelegate.shareIntance.space
        let tv =  UITableView.init(frame: CGRect.init(x: 0, y: space.topSpace, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 48))
        tv.separatorStyle = .none
        tv.dataSource = self
        tv.delegate = self
        tv.bounces = false
        self.view.addSubview(tv)
        return tv
    }()
    
    lazy var tableHeadV : UserHeadView = {
        let t = UserHeadView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 100))
        t.userM = UserManager.shareIntance.HCUser
        return t
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get{
            return .lightContent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = kDefaultThemeColor
        
        self.navigationItem.title = ""
        
        tableView.tableHeaderView = tableHeadV
        tableHeadV.naviVC = self.navigationController
        
        tableView.backgroundColor = klightGrayColor
        tableView.tableFooterView = UIView()
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    
        
        initFooterView()
        
        requestData()   
        
        NotificationCenter.default.addObserver(self, selector: #selector(UserTableViewController.setUserInfo), name: NSNotification.Name.init(UPDATE_USER_INFO), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        HttpRequestManager.shareIntance.HC_userInfo(callback: { [weak self] (success, msg) in
            if success == true { self?.setUserInfo() }
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setUserInfo(){
        tableHeadV.userM = UserManager.shareIntance.HCUser
    }
    
    func initFooterView(){
        let footContainerV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 180))
        
        self.tableView.tableFooterView = footContainerV
        
        let logoutBtn = UIButton.init(frame: CGRect.init(x: 0, y: 10, width: SCREEN_WIDTH, height: 44))
        logoutBtn.backgroundColor = UIColor.white
        logoutBtn.setTitle("退出登录", for: UIControlState.normal)
        logoutBtn.setTitleColor(kDefaultThemeColor, for: .normal)
        logoutBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: kTextSize)
        
        logoutBtn.addTarget(self, action: #selector(UserTableViewController.logout), for: UIControlEvents.touchUpInside)
        footContainerV.addSubview(logoutBtn)
        
        let infoV = UIView.init(frame: CGRect.init(x: 0, y: 80, width: SCREEN_WIDTH, height: 100))
        footContainerV.addSubview(infoV)
        
        let phoneL = UILabel.init()
        phoneL.textColor = kLightTextColor
        phoneL.font = UIFont.init(name: kReguleFont, size: kTextSize)
        let phoneStr = NSMutableAttributedString.init(string: "服务电话：" + KServicePhone)
        phoneStr.addAttributes([NSForegroundColorAttributeName : kDefaultThemeColor], range: NSRange.init(location: 5, length: 11))
        phoneL.attributedText = phoneStr
        phoneL.textAlignment = .center
        infoV.addSubview(phoneL)
        phoneL.snp.updateConstraints { (make) in
            make.left.right.top.equalTo(infoV)
            make.height.equalTo(30)
        }
        
        phoneL.isUserInteractionEnabled = true
        let tapG = UITapGestureRecognizer.init(target: self, action: #selector(UserTableViewController.callThePhone))
        phoneL.addGestureRecognizer(tapG)
        
        
        let timeL = UILabel.init()
        timeL.textColor = kLightTextColor
        timeL.font = UIFont.init(name: kReguleFont, size: kTextSize - 2)
        timeL.text = "（服务时间：8:00-20:00）"
        timeL.textAlignment = .center
        infoV.addSubview(timeL)
        timeL.snp.updateConstraints { (make) in
            make.top.equalTo(phoneL.snp.bottom)
            make.left.right.equalTo(infoV)
            make.height.equalTo(30)
        }
        
        let versionL = UILabel()
        let infoDic = Bundle.main.infoDictionary
        let currentVersion = infoDic?["CFBundleShortVersionString"] as! String
        versionL.text = "当前版本号：" + currentVersion
        versionL.textColor = UIColor.lightGray
        versionL.font = UIFont.init(name: kReguleFont, size: 12)
        versionL.sizeToFit()
        footContainerV.addSubview(versionL)
        versionL.snp.updateConstraints { (make) in
            make.centerX.equalTo(footContainerV)
            make.bottom.equalTo(footContainerV).offset(-10)
        }
    }
    
    func callThePhone(){
        let s = "tel://" + KServicePhone
        if let u = URL.init(string: s){
            UIApplication.shared.openURL(u)
        }
    }
    
    func logout(){
        let alertController = UIAlertController(title: "提醒",
                                                message: "退出登录会清空个人信息", preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "确定退出", style: .cancel) { (action) in
            UserManager.shareIntance.logout()
        }
        let okAction = UIAlertAction(title: "取消", style: .default, handler: {(action)->() in
            
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func requestData(){
        HttpRequestManager.shareIntance.HC_getH5URL(keyCode: "PATIENT_FEEDBACK") { [weak self](success, info) in
            if success == true {
                self?.feedbackURL = info
            }else{
                HCShowError(info: info)
            }
        }
        
        HttpRequestManager.shareIntance.HC_getH5URL(keyCode: "SELF_SERVICE_QUEUE") { [weak self](success, info) in
            if success == true {
                self?.myQueueURL = info
            }else{
                HCShowError(info: info)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func checkForRegister(urlS : String){
        
        if UserManager.shareIntance.HCUser?.visitCard != nil && UserManager.shareIntance.HCUser?.visitCard != ""{
            //已认证
            registerH5(urlS: urlS)
        }else{
            self.navigationController?.pushViewController(BindHospitalViewController(), animated: true)
            showAlert(title: "提醒", message: "还未进行身份认证")
        }
    }
    
    func registerH5(urlS : String){
        let webVC = WebViewController()
        webVC.url = urlS
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    //预约
    func register(){
        SVProgressHUD.show()
        HttpRequestManager.shareIntance.HC_getH5URL(keyCode: kRegisterURL) { [weak self](success, info) in
            if success == true {
                self?.checkForRegister(urlS: info)
            }else{
                HCShowError(info: info)
            }
        }
    }
    
    
    //SELF_SERVICE_QUEUE
    func myQueue(){
        if let url = myQueueURL {
            let webVC = WebViewController()
            webVC.url = url
            self.navigationController?.pushViewController(webVC, animated: true)
        }else{
            HCShowError(info: "网络出错")
        }
    }
    
    
    func feedBack(){
        if let url = feedbackURL {
            let webVC = WebViewController()
            webVC.url = url
            self.navigationController?.pushViewController(webVC, animated: true)
        }else{
            HCShowError(info: "网络出错")
        }
    }
    
    func authIDNumber(){
        if UserManager.shareIntance.HCUser?.visitCard != nil && UserManager.shareIntance.HCUser?.visitCard != "" {
            self.navigationController?.pushViewController(AuthenticationViewController(), animated: true)
        }else{
            self.navigationController?.pushViewController(BindHospitalViewController(), animated: true)
        }
    }
}

extension UserTableViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserTableViewCell
        cell.titleL.text = titleArr[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let t = titleArr[indexPath.section][indexPath.row]
        
        switch t {
        case "实名认证":
            HCPrint(message: "实名认证")
            if UserManager.shareIntance.realName(authentication: navigationController) == true {
                let bindVC = AuthenticationViewController()
                navigationController?.pushViewController(bindVC, animated: true)
            }

        case "我的预约":
            HCPrint(message: "我的预约")
            register()
        case "我的排号":
            HCPrint(message: "我的排号")
            myQueue()
        case "我的咨询":
            HCPrint(message: "我的咨询")
            self.navigationController?.pushViewController(ConsultRecordViewController(), animated: true)
        case "我的健康卡":
            if UserManager.shareIntance.HCUser?.visitCard != nil && UserManager.shareIntance.HCUser?.visitCard != "" {
                SVProgressHUD.show()
                HttpRequestManager.shareIntance.HC_getH5URL(keyCode: "HEALTH_CARD") { (flag, url) in
                    print(url)
                    SVProgressHUD.dismiss()
                    let webVC = WebViewController()
                    webVC.url = url
                    self.navigationController?.pushViewController(webVC, animated: true)
                }
            }else{
                self.navigationController?.pushViewController(BindHospitalViewController(), animated: true)
            }
        case "通知消息":
            HCPrint(message: "通知消息")
            self.navigationController?.pushViewController(MessageViewController(), animated: true)
        case "意见反馈":
            HCPrint(message: "意见反馈")
            feedBack()
        default:
            HCPrint(message: "other flag")
        }
        
    }
}
