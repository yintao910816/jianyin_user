

import UIKit
import JavaScriptCore
import SVProgressHUD

class TreatWebViewController: BaseViewController {
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
        
        let w = UIWebView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 44 - 48))
        w.scrollView.bounces = false
        w.delegate = self
        self.view.addSubview(w)
        return w
    }()
    
    lazy var animator = PopoverAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        getURLStr()
        
//        url = "http://127.0.0.1:8020/patient/view/TreatFlow.html"
        
    }
    
    
    func getURLStr(){
        HttpRequestManager.shareIntance.HC_getH5URL(keyCode: "TREATINFORMATION_URL") { [weak self](success, info) in
            if success == true {
                self?.url = info
            }else{
                HCShowError(info: info)
                self?.url = "https://www.ivfcn.com/h5/patient/curlFlow/home.do"
            }
        }
    }
    
    func requestData(){
        SVProgressHUD.show()
        let request = URLRequest.init(url: URL.init(string: url!)!)
        webView.loadRequest(request)
    }
    
    
    func setTitle(){
        if let title = webView.stringByEvaluatingJavaScript(from: "document.title"){
            self.navigationItem.title = title
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension TreatWebViewController : UIWebViewDelegate{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool{
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView){
        HCPrint(message: "didStartLoad")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        HCPrint(message: "didFinishLoad")
        SVProgressHUD.dismiss()
        
        context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        
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

