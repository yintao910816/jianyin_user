//
//  WebViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/7/24.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import JavaScriptCore
import SVProgressHUD

class WebViewController: BaseViewController {
    
    fileprivate var name: String = ""
    fileprivate var cardNum: String = ""
    
    fileprivate var isPopToRoot: Bool = false
    
    var redirect_url: String?

    var url : String?{
        didSet{
            HCPrint(message: url)
            if url != oldValue{
                let hospId : String!
                if let i = UserManager.shareIntance.HCUser?.hospitalId {
                    hospId = String.init(format: "%d", i.intValue)
                }else{
                    hospId = "0"
                }
                
                let token = UserManager.shareIntance.HCUser?.token ?? "noToken"
                
                if url!.contains("?"){
                    if url!.contains("hospitalId"){
                        if url!.hasSuffix("&"){
                            url = url! + "token=" + token + "&navHead=aly"
                            requestData()
                        }else if url!.hasSuffix("token="){
                            url = url! + token + "&navHead=aly"
                            requestData()
                        }else{
                            url = url! + "&token=" + token + "&navHead=aly"
                            requestData()
                        }
                    }else{
                        if url!.hasSuffix("&"){
                            url = url! + "token=" + token + "&hospitalId=" + hospId + "&navHead=aly"
                            requestData()
                        }else if url!.hasSuffix("token="){
                            url = url! + token + "&hospitalId=" + hospId + "&navHead=aly"
                            requestData()
                        }else{
                            url = url! + "&token=" + token + "&hospitalId=" + hospId + "&navHead=aly"
                            requestData()
                        }
                    }
                }else{
                    if UserManager.shareIntance.HCUser?.token != nil {
                        url = url! + "?token=" + token + "&hospitalId=" + hospId + "&navHead=aly"
                    }
                    requestData()
                }
            }
            HCPrint(message: url)
        }
    }
    
    var params : [String : Any]?
    
    var context : JSContext?
    
    lazy var isPublishClick : Bool = false
    
    lazy var webView : UIWebView = {
        
        let space = AppDelegate.shareIntance.space
        
        let w = UIWebView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 44))
        w.scrollView.bounces = false
        w.delegate = self
        self.view.addSubview(w)
        return w
    }()
    
    lazy var animator = PopoverAnimator()
    
    fileprivate func tranform(alipays jsonString: String) ->String {
        
        guard let astring = jsonString.removingPercentEncoding else {
            return jsonString
        }
        
        let dealString = astring.replacingOccurrences(of: "alipay://alipayclient/?", with: "")
        
        guard let jsonData  = dealString.data(using: .utf8) else {
            return jsonString
        }
        
        guard let ret = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) else {
            return jsonString
        }
        
        guard var dict = ret as? [String: Any] else {
            return jsonString
        }
        
        dict["fromAppUrlScheme"] = kScheme
        
        if JSONSerialization.isValidJSONObject(dict) == false {
            return jsonString
        }
        
        let data : Data! = try? JSONSerialization.data(withJSONObject: dict, options: [])
        guard let retString = String.init(data: data, encoding: .utf8) else {
            return jsonString
        }
        
        return "alipay://alipayclient/?\(retString)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? jsonString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "佳音"
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(wchatPayFinish),
                                               name: NSNotification.Name.init(WCHAT_FINISH),
                                               object: nil)
    }
    
    @objc private func wchatPayFinish() {
        if let urlStr = redirect_url, let url = URL.init(string: urlStr) {
            let mRequest = URLRequest.init(url: url)
            webView.loadRequest(mRequest)
            redirect_url = nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let leftItem = UIBarButtonItem(image: UIImage(named: "返回灰"), style: .plain, target: self, action: #selector(WebViewController.popViewController))
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    func requestData(){
        SVProgressHUD.show()
        HCPrint(message: url)
        let request = URLRequest.init(url: URL.init(string: url!)!)
        webView.loadRequest(request)
    }
    
    func setTitle(){
        if let title = webView.stringByEvaluatingJavaScript(from: "document.title"){
            if title != ""{
                self.navigationItem.title = title
            }
        }
    }

    func popViewController(){
        if isPopToRoot == true {
            navigationController?.popToRootViewController(animated: true)
        }else if webView.canGoBack{
            webView.goBack()
        }else{
            SVProgressHUD.dismiss()
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension WebViewController : UIWebViewDelegate{
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool{

        let s = request.url?.absoluteString
        let rs = "app.jyyy.so://".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        if s == "app://reload"{
            webView.loadRequest(URLRequest.init(url: URL.init(string: url!)!))
            return false
        }else if s?.hasPrefix("alipays://") == true || s?.hasPrefix("alipay://") == true {
            if let url = URL.init(string: tranform(alipays: request.url!.absoluteString)) {
                let flag = UIApplication.shared.openURL(url)
                if flag == false {
                    SVProgressHUD.showError(withStatus: "未检测到支付宝客户端，请安装后重试")
                }
            }else {
                SVProgressHUD.showError(withStatus: "未检测到支付地址")
            }
            return false
        }else if s?.contains("wx.tenpay.com") == true && s?.contains("redirect_url=\(rs)") == false {
            let sep = s!.components(separatedBy: "redirect_url=")
            redirect_url = sep.first(where: { !$0.contains("wx.tenpay.com") })
            let reloadUrl = sep.first(where: { $0.contains("wx.tenpay.com") })!.appending("&redirect_url=\(rs)")
            if let _url = URL.init(string: reloadUrl) {
                var mRequest = URLRequest.init(url: _url)
                mRequest.setValue("app.jyyy.so://", forHTTPHeaderField: "Referer")
                webView.loadRequest(mRequest)
            }
            return false
        }else if (s?.contains("http"))!{
            return true
        }
        
        return true

    }
    
    func webViewDidStartLoad(_ webView: UIWebView){
        HCPrint(message: "didStartLoad")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        HCPrint(message: "didFinishLoad")
        SVProgressHUD.dismiss()
        
        context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        
        // JS调用打开充值界面
        let openRechargeView: @convention(block) () ->() = {
            DispatchQueue.main.async {[weak self]in
                self?.navigationController?.pushViewController(RechargeViewController(), animated: true)
            }
        }
        
        // 人脸识别之后公安验证需要的参数
        let startVerify: @convention(block) (String, String) ->() = { (userNane, cardNo) in
            DispatchQueue.main.async {[weak self] in
                self?.name = userNane
                self?.cardNum = cardNo
                
                self?.openFaceAuthor()
            }
        }
        
        // 实名认证成功刷新本地数据
        let refreshInfofor: @convention(block) () ->() = {
            DispatchQueue.main.async { _ in
                UserManager.shareIntance.updateUserInfo(callback: { ret in
                    if ret == true { HCPrint(message: "本地用信息更新成功") }
                    else { HCPrint(message: "本地用信息更新成功") }
                })
            }
        }
        
        context?.setObject(unsafeBitCast(openRechargeView, to: AnyObject.self), forKeyedSubscript: "openRechargeView" as NSCopying & NSObjectProtocol)
        context?.setObject(unsafeBitCast(startVerify, to: AnyObject.self), forKeyedSubscript: "startVerify" as NSCopying & NSObjectProtocol)
        context?.setObject(unsafeBitCast(refreshInfofor, to: AnyObject.self), forKeyedSubscript: "refreshInfofor" as NSCopying & NSObjectProtocol)

        context?.exceptionHandler = {(context, value)in
            HCPrint(message: value)
        }
        
        setTitle()
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        HCPrint(message: error.localizedDescription)
        SVProgressHUD.dismiss()
    }
}

extension WebViewController: LivenessDelegate {
    
    fileprivate func openFaceAuthor() {
        if FaceSDKManager.sharedInstance()!.canWork() == true {
            let licensePath = Bundle.main.path(forResource: FACE_LICENSE_NAME, ofType: FACE_LICENSE_SUFFIX)
            FaceSDKManager.sharedInstance()?.setLicenseID(FACE_LICENSE_ID, andLocalLicenceFile: licensePath)
        }
        
        let faceVC = LivenessViewController.init()
        let model = LivingConfigModel.sharedInstance()
        faceVC.livenesswithList(model!.liveActionArray as? [Any], order: model!.isByOrder, numberOfLiveness: model!.numOfLiveness)
        faceVC.delegate = self
        present(faceVC, animated: true, completion: nil)
    }

    func imageString(_ string: String!) {
        SVProgressHUD.show()
        
        HttpRequestManager.shareIntance.HC_getBaiduAccessToken { [weak self] (success, access_token) in
            guard let strongSelf = self else { return }
            
            if success == true {
                let id_card_number = strongSelf.cardNum
                let name = strongSelf.name
                HttpRequestManager.shareIntance.baidubce(access_token: access_token,
                                                         image: string,
                                                         id_card_number: id_card_number,
                                                         name: name,
                                                         callBack: { [weak self] (success, data) in
                                                            if success == true && Double(data)! > 50.0 {
//                                                                SVProgressHUD.showSuccess(withStatus: "公安验证分数：\(data)")
                                                                SVProgressHUD.dismiss()
                                                                self?.pushAuthorTwo()
                                                            }else {
                                                                SVProgressHUD.showError(withStatus: "公安验证失败")
                                                            }
                })
            }else {
                SVProgressHUD.showError(withStatus: "AccessToken获取失败")
            }
        }
    }
    
    private func pushAuthorTwo() {
        let webVC = WebViewController()
        webVC.isPopToRoot = true
        webVC.url = REALNAME_AUTHOR_TWO
        navigationController?.pushViewController(webVC, animated: true)
    }

}

