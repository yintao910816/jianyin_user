//
//  HomeFunctionView.swift
//  aileyun
//
//  Created by huchuang on 2017/8/18.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeFunctionView: UIView {
    
    weak var naviVC : UINavigationController?
    
    var modelArr : [HomeFunctionModel]?{
        didSet{
            collectionV.reloadData()
            updateSize((modelArr?.count)!)
        }
    }

    lazy var collectionV : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize.init(width: FuncSizeWidth, height: FuncSizeWidth)
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        let collectV = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: FuncSizeWidth), collectionViewLayout: layout)
        
        collectV.delegate = self
        collectV.dataSource = self
        
        collectV.backgroundColor = UIColor.white
        
        return collectV
        
    }()
    
    let collectionReuseI = "collectionReuseI"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionV.register(FunctionCollectionViewCell.self, forCellWithReuseIdentifier: collectionReuseI)
        self.addSubview(collectionV)
    }
    
    func updateSize(_ count : NSInteger){
        let layer = (count - 1) / 4 + 1
        HCPrint(message: layer)
        collectionV.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: FuncSizeWidth * CGFloat(layer))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func actionWithModel(model : HomeFunctionModel){
        let name = model.name
        
        if let url = model.url {
            if url == "#"{
                if let name = name{
                    switch name {
                    case "在线客服":
                        helpDesk()
                    case "在线充值":
                        jiayinPay()
                    default:
                        HCPrint(message: name + " 没有url")
                    }
                }else{
                    HCShowError(info: "出错：name为空")
                }
            }else{
                if let needBind = model.isBind {
                    if needBind.intValue == 1 {
                        guard UserManager.shareIntance.HCUser?.visitCard != nil && UserManager.shareIntance.HCUser?.visitCard != "" else{
                            
                            self.naviVC?.pushViewController(BindHospitalViewController(), animated: true)
                            showAlert(title: "提醒", message: "此功能需要实名认证")
                            
                            return
                        }
                    }
                    let webVC = WebViewController()
                    webVC.url = url
                    naviVC?.pushViewController(webVC, animated: true)
                }
            }
        }else{
          HCShowError(info: "功能暂不开放")
        }
    }
    
    
    func helpDesk(){
        let s = "tel://" + KServicePhone
        if let u = URL.init(string: s){
            UIApplication.shared.openURL(u)
        }
    }
    
    
    func jiayinPay(){
        guard UserManager.shareIntance.HCUser?.visitCard != nil && UserManager.shareIntance.HCUser?.visitCard != "" else{
            
            self.naviVC?.pushViewController(BindHospitalViewController(), animated: true)
            showAlert(title: "提醒", message: "此功能需要实名认证")
            
            return
        }
        self.naviVC?.pushViewController(RechargeViewController(), animated: true)
        
//        let rechargeResultCtrl = RechargeResultViewController.init(nibName: "RechargeResultViewController", bundle: Bundle.main)
//        rechargeResultCtrl.set(orderNum: "3746135683154671536741367451635", payType: "支付宝充值", payMoney: "100", payState: false)
//        self.naviVC?.pushViewController(rechargeResultCtrl, animated: true)
    }
    

}




extension HomeFunctionView : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: FuncSizeWidth, height: FuncSizeWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionReuseI, for: indexPath) as! FunctionCollectionViewCell
        cell.model = modelArr?[indexPath.row]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = modelArr?[indexPath.row]
        if let model = model {
            actionWithModel(model: model)
        }
    }
}
