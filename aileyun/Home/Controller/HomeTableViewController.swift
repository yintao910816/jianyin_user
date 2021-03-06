//
//  HomeTableViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/6/16.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

let ScrollImageVHeight : CGFloat = SCREEN_WIDTH / 750 * 445
let FuncSizeWidth = SCREEN_WIDTH / 4
let NoticeViewHeight : CGFloat = 100
let SelectViewHeight : CGFloat = 0
let GoodnewsHeight : CGFloat = 100
let KnownledgeViewHeight : CGFloat = 0
let ViewGap : CGFloat = 3

class HomeTableViewController: BaseViewController {

    var expertGuidS : String?
    
    var classOnline : String?
    
    lazy var noticeV : NoticeView = {
        let l = NoticeView.init(frame: CGRect.init(x: 0, y: ScrollImageVHeight, width: SCREEN_WIDTH, height: NoticeViewHeight))
        return l
    }()
    
    var shouldHideNoticeV : Bool = false {
        didSet{
            noticeV.isHidden = shouldHideNoticeV
        }
    }

    lazy var containerV : UIView = {
        let c = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: ScrollImageVHeight + FuncSizeWidth + SelectViewHeight + ViewGap * 2 + KnownledgeViewHeight))
        c.backgroundColor = kdivisionColor
        c.clipsToBounds = true
        return c
    }()
    
    
    lazy var picScrollV : topView = {
        let t = topView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: ScrollImageVHeight))
        t.naviCtl = self.navigationController
        t.autoScrollTimeInterval = 3
        return t
    }()
    
    var howManyLayer : CGFloat?
    
    lazy var functionV : HomeFunctionView = {
        let f = HomeFunctionView.init(frame: CGRect.init(x: 0, y: ScrollImageVHeight, width: SCREEN_WIDTH, height: FuncSizeWidth))
        f.naviVC = self.navigationController
        return f
    }()
    
    lazy var selectV : selectView = {
        let s = selectView.init(frame: CGRect.init(x: 0, y: ScrollImageVHeight + NoticeViewHeight + ViewGap, width: SCREEN_WIDTH, height: SelectViewHeight))
        return s
    }()
    
    lazy var gooodnewsV : GoodNewsView = {
        let g = GoodNewsView.init(frame: CGRect.init(x: 0, y: ScrollImageVHeight + FuncSizeWidth + ViewGap * 2 + SelectViewHeight, width: SCREEN_WIDTH, height: GoodnewsHeight))
        return g
    }()
    
    let reuseIdentifier = "reuseIdentifier"
    
    lazy var tableV : UITableView = {
        let space = AppDelegate.shareIntance.space
        let t = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.bottomSpace - 48))
        t.rowHeight = UITableView.automaticDimension
        t.estimatedRowHeight = 300
        t.dataSource = self
        t.delegate = self
        return t
    }()
    
    
    var circleArr : [HCCircleModel]?{
        didSet{
            tableV.reloadData()
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        get {
            return .lightContent
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        if UserManager.shareIntance.realName(authentication: nil, needPush: false) == false {
            HttpRequestManager.shareIntance.HC_userInfo(callback: { (success, msg) in
                if success == true {
                    HCPrint(message: "个人信息获取成功")
                }else {
                    HCPrint(message: "个人信息获取失败")
                }
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        
        HCDataProvideTool.shareIntance.dataReloadCallBack = { [weak self] data in
            self?.circleArr = data
            self?.tableV.mj_footer.endRefreshing()
        }
        
        self.tableV.mj_header.beginRefreshing()
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTableViewController.beginRefresh), name: NSNotification.Name.init(BIND_SUCCESS), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func beginRefresh(){
        self.tableV.mj_header.beginRefreshing()
    }
    
    
    func initUI(){
        self.navigationItem.title = ""
        
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(tableV)
        tableV.register(treasuryTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        
        if #available(iOS 11.0, *) {
            tableV.contentInsetAdjustmentBehavior = .never
        } else {
        }
        
    
        containerV.addSubview(picScrollV)
        containerV.addSubview(functionV)
        containerV.addSubview(noticeV)
//        containerV.addSubview(selectV)
        containerV.addSubview(gooodnewsV)
        
        tableV.tableHeaderView = containerV
        tableV.tableFooterView = UIView()
        
        //诊疗流程
        selectV.guideBtn.addTarget(self, action: #selector(HomeTableViewController.treatFlow), for: .touchUpInside)
        //暂时去之前的论坛
        selectV.classroomBtn.addTarget(self, action: #selector(HomeTableViewController.groupDiscuss), for: .touchUpInside)
        
        let headRefresher = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(HomeTableViewController.requestData))
        headRefresher?.setTitle("下拉刷新数据", for: .idle)
        headRefresher?.setTitle("释放刷新数据", for: .pulling)
        headRefresher?.setTitle("正在请求数据", for: .refreshing)

        let footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMore))
        
        tableV.mj_footer = footer!
        tableV.mj_header = headRefresher
    }
    
    func messageAction(){
        self.navigationController?.pushViewController(MessageViewController(), animated: true)
    }
    
    @objc func goodNewsDetail(){
        SVProgressHUD.show()
        HttpRequestManager.shareIntance.HC_getH5URL(keyCode: "GOOD_NEWS_2017") { [weak self](success, info) in
            if success == true {
                SVProgressHUD.dismiss()
                HCPrint(message: info)
                let webVC = WebViewController()
                webVC.url = info
                self?.navigationController?.pushViewController(webVC, animated: true)
            }else{
                HCShowError(info: info)
            }
        }
    }
    
    @objc func noticeDetail(){
        SVProgressHUD.show()
        if noticeV.modelArr![noticeV.row].typeCom == "dynamic" {
            let notIdS = String.init(format: "%d", (noticeV.modelArr![noticeV.row].id!.intValue))
            HttpRequestManager.shareIntance.HC_getH5URL(keyCode: "NOTICE_DETAIL_URL", callback: { [weak self](success, urlS) in
                SVProgressHUD.dismiss()
                if success == true{
                    let webVC = WebViewController()
                    webVC.url = urlS + "?noticeId=" + notIdS
                    self?.navigationController?.pushViewController(webVC, animated: true)
                }else{
                    HCShowError(info: urlS)
                }
            })
        }else{
            messageAction()
        }
    }
    
    func qrcodeVC(){
        self.navigationController?.pushViewController(QRCodeScanViewController(), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshView(){
        guard let layer = howManyLayer else{
            return
        }
        let headV = tableV.tableHeaderView
        functionV.frame = CGRect.init(x: 0, y: ScrollImageVHeight, width: SCREEN_WIDTH, height: FuncSizeWidth * layer)
        noticeV.frame = CGRect.init(x: 0, y: ScrollImageVHeight + FuncSizeWidth * layer + ViewGap, width: SCREEN_WIDTH, height: NoticeViewHeight)
        if shouldHideNoticeV == false{
            headV?.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: ScrollImageVHeight + FuncSizeWidth * layer + SelectViewHeight + GoodnewsHeight + NoticeViewHeight + ViewGap * 4 + KnownledgeViewHeight)
//            selectV.snp.updateConstraints({ (make) in
//                make.left.right.equalTo(noticeV)
//                make.top.equalTo(noticeV.snp.bottom).offset(ViewGap)
//                make.height.equalTo(SelectViewHeight)
//            })
        }else{
            headV?.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: ScrollImageVHeight + FuncSizeWidth * layer + SelectViewHeight + GoodnewsHeight + ViewGap * 3 + KnownledgeViewHeight)
//            selectV.snp.updateConstraints({ (make) in
//                make.left.right.equalTo(functionV)
//                make.top.equalTo(functionV.snp.bottom).offset(ViewGap)
//                make.height.equalTo(SelectViewHeight)
//            })
        }
        
        gooodnewsV.snp.updateConstraints ({ (make) in
            make.left.right.equalTo(functionV)
            make.top.equalTo(shouldHideNoticeV ? functionV.snp.bottom : noticeV.snp.bottom).offset(ViewGap)
            make.height.equalTo(GoodnewsHeight)
        })
        
        tableV.tableHeaderView = headV
    }
   
    @objc func loadMore() {
        HCDataProvideTool.shareIntance.loadMoreCircleData()
    }
    
    @objc func requestData(){
        // 防止401导致未处理
        tableV.mj_header.endRefreshing()
        
        SVProgressHUD.show()
        
        HCDataProvideTool.shareIntance.requestCircleData()
        
        let group = DispatchGroup.init()
        
        group.enter()
        HttpRequestManager.shareIntance.HC_banner { [weak self](success, arr, msg) in
            if success == true{
                self?.picScrollV.dataArr = arr
            }else{
                HCShowError(info: msg)
            }
            group.leave()
        }
        
        group.enter()
        HttpRequestManager.shareIntance.HC_functionList { [weak self](success, arr, msg) in
            if success == true{
                self?.functionV.modelArr = arr
                self?.howManyLayer = CGFloat(((arr?.count)! - 1) / 4 + 1)
            }else{
                HCShowError(info: msg)
            }
            group.leave()
        }
        
//        group.enter()
//        // H5地址
//        HttpRequestManager.shareIntance.HC_getH5URL(keyCode: "EXPERT_GUIDANCE_2017") { [weak self](success, info) in
//            if success == true {
//                self?.expertGuidS = info
//            }else{
//                HCShowError(info: info)
//            }
//            group.leave()
//        }
//        
//        group.enter()
//        // H5地址
//        HttpRequestManager.shareIntance.HC_getH5URL(keyCode: "CLASS_ONLINE_2017") { [weak self](success, info) in
//            if success == true {
//                self?.classOnline = info
//            }else{
//                HCShowError(info: info)
//            }
//            group.leave()
//        }
        
        //公告
        group.enter()
        HttpRequestManager.shareIntance.HC_notice { [weak self](arr, s) in
            if let modelArr = arr{
                self?.noticeV.modelArr = modelArr
                
                self?.dealWithNote(arr: modelArr)
                
                //添加点击事件
                let tapG = UITapGestureRecognizer.init(target: self, action: #selector(HomeTableViewController.noticeDetail))
                self?.noticeV.addGestureRecognizer(tapG)
            }else{
                self?.shouldHideNoticeV = true
            }
            group.leave()
        }
        
        group.enter()
        HttpRequestManager.shareIntance.HC_goodnews { [weak self](modelArr, msg) in
            if let arr = modelArr{
                self?.gooodnewsV.modelArr = arr
                //添加点击事件
                let tapG = UITapGestureRecognizer.init(target: self, action: #selector(HomeTableViewController.goodNewsDetail))
                self?.gooodnewsV.addGestureRecognizer(tapG)
            }else{
            }
            group.leave()
        }
        
        
        group.notify(queue: DispatchQueue.main) {[weak self]()in
            SVProgressHUD.dismiss()
            self?.refreshView()
        }
    }
    
    
    func dealWithNote(arr : [NoticeHomeVModel]){
        
        var allow = true
        
        let t = UserDefaults.standard.value(forKey: kpopAlertTime) as? String
        if let t = t{
            let todayS = Date.init().converteYYYYMMdd()
            if t == todayS{
                allow = false
            }
        }
        
        guard allow == true else{
            HCPrint(message: "今天的名额用完了！")
            return
        }
        
        for i in arr {
            if let flag = i.popFlag{
                if flag.intValue == 1{
                    let alertVC = AlertViewController()
                    alertVC.titleL.text = i.title
                    alertVC.contentL.text = i.content
                    alertVC.modalPresentationStyle = .custom
            
                    UIApplication.shared.keyWindow?.rootViewController?.present(alertVC, animated: false, completion: nil)
                    
                    let todayS = Date.init().converteYYYYMMdd()
                    UserDefaults.standard.set(todayS, forKey: kpopAlertTime)
                    
                    break
                }
            }
        }
    }
    
}


extension HomeTableViewController {
    
    //专家指导
    @objc func treatFlow(){
        guard let s = expertGuidS else {return}
        if s == "EXPERT_GUIDANCE_2017" {
            let tabVC = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
            tabVC.selectedIndex = 2
        }
    }
    
    //在线课堂
    @objc func groupDiscuss(){
        guard classOnline != nil else {return}
        if classOnline  == "#" {
            HCShowInfo(info: "功能暂不开放")
        }else{
            let webVC = WebViewController()
            webVC.url = classOnline!
            self.navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
    func moreAction(){
        let webVC = WebViewController()
        webVC.url = "http://m.jiayinyy.com/news.php"
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
}

extension HomeTableViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return circleArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! treasuryTableViewCell
        cell.model = circleArr?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let contV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 50))
        contV.backgroundColor = UIColor.white
        
        let diviV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 1))
        diviV.backgroundColor = kdivisionColor
        contV.addSubview(diviV)
        
        let knowledgeIV = UIImageView()
        knowledgeIV.image = UIImage.init(named: "标题")
        knowledgeIV.contentMode = .scaleAspectFit
        contV.addSubview(knowledgeIV)
        knowledgeIV.snp.updateConstraints { (make) in
            make.left.equalTo(contV).offset(20)
            make.centerY.equalTo(contV)
            make.width.height.equalTo(20)
        }
        
        let knowledgeL = UILabel()
        knowledgeL.text = "最新资讯"
        knowledgeL.font = UIFont.init(name: kReguleFont, size: kTextSize)
        knowledgeL.textColor = kTextColor
        contV.addSubview(knowledgeL)
        knowledgeL.snp.updateConstraints { (make) in
            make.left.equalTo(knowledgeIV.snp.right).offset(10)
            make.centerY.equalTo(knowledgeIV)
        }
        
        
//        let moreBtn = UIButton()
//        moreBtn.setTitle("更多", for: .normal)
//        moreBtn.setTitleColor(kTextColor, for: .normal)
//        moreBtn.titleLabel?.font = UIFont.init(name: kReguleFont, size: kTextSize - 2)
//        contV.addSubview(moreBtn)
//        moreBtn.snp.updateConstraints { (make) in
//            make.right.equalTo(contV).offset(-20)
//            make.centerY.equalTo(knowledgeIV)
//        }
//
//        moreBtn.addTarget(self, action: #selector(HomeTableViewController.moreAction), for: .touchUpInside)
        
        let divisionV = UIView()
        divisionV.backgroundColor = kdivisionColor
        contV.addSubview(divisionV)
        divisionV.snp.updateConstraints { (make) in
            make.left.right.bottom.equalTo(contV)
            make.height.equalTo(1)
        }
        
        return contV
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let m = circleArr?[indexPath.row]
        if let isHref = m?.is_href{
            if isHref.intValue == 1{
                if let u = m?.href_{
                    let webVC = WebViewController()
                    webVC.url = u
                    self.navigationController?.pushViewController(webVC, animated: true)
                }
            }else{
                if let n = m?.id{
                    let webVC = WebViewController()
                    webVC.url = String.init(format: "%@?id=%@", "http://app.jyyy.so:8081/patient/xjjy/view/newsDetail.html", n)
                    self.navigationController?.pushViewController(webVC, animated: true)
                }
            }
        }
    }
}
