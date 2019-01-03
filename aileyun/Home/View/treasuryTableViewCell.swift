//
//  treasuryTableViewCell.swift
//  aileyun
//
//  Created by huchuang on 2017/6/22.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class treasuryTableViewCell: UITableViewCell {

    
    var model : HCCircleModel?{
        didSet{
            
            if let path = model?.pic_path{
                HCPrint(message: path)
                headImg.HC_setImageFromURL(urlS: path, placeHolder: "默认头像")
            }
            
            titleL.text = model?.title
            
//            if let n = model?.views_number{
//                readL.text = String.init(format: "%d", n.intValue)
//            }
            
            if let n = model?.publish_date{
                timeL.text = Date.createTimeWithString(n)
            }
            
//            titleL.text = model?.info
            
        }
    }
    
    
    
    let headImg = UIImageView()
    
//    let nameL = UILabel()
    let timeL = UILabel()
    let titleL = UILabel()
    
    let readL = UILabel()
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func convertToTableData(arr : [String])->[String]{
        var tempArr = [String]()
        for i in arr{
            guard i != "" else {
                continue
            }
            tempArr.append(i)
        }
        return tempArr
    }
    
   
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI(){
        self.addSubview(headImg)
        headImg.snp.updateConstraints { (make) in
            make.top.equalTo(self).offset(15)
            make.left.equalTo(self).offset(20)
            make.width.height.equalTo(60)
            make.bottom.equalTo(self).offset(-15)
        }
        headImg.layer.cornerRadius = 5
        headImg.clipsToBounds = true
        
//        nameL.font = UIFont.init(name: kReguleFont, size: 14)
//        nameL.textColor = kTextColor
//        self.addSubview(nameL)
//        nameL.snp.updateConstraints { (make) in
//            make.top.equalTo(headImg)
//            make.left.equalTo(headImg.snp.right).offset(12)
//            make.right.equalTo(self).offset(-20)
//            make.height.equalTo(20)
//        }
        
        titleL.font = UIFont.init(name: kReguleFont, size: 13)
        titleL.textColor = kTextColor
        titleL.numberOfLines = 0
        self.addSubview(titleL)
        titleL.snp.updateConstraints { (make) in
            make.top.equalTo(headImg)
            make.left.equalTo(headImg.snp.right).offset(12)
            make.right.equalTo(self).offset(-20)
//            make.height.equalTo(20)
        }

        timeL.font = UIFont.init(name: kReguleFont, size: 12)
        timeL.textColor = kLightTextColor
        self.addSubview(timeL)
        timeL.snp.updateConstraints { (make) in
            make.top.equalTo(titleL.snp.bottom).offset(5)
            make.left.equalTo(titleL)
            make.right.equalTo(self).offset(-20)
        }
        
//        readL.textColor = kNumberColor
//        readL.textAlignment = NSTextAlignment.center
//        readL.font = UIFont.init(name: kReguleFont, size: 12)
//        self.addSubview(readL)
//        readL.snp.updateConstraints { (make) in
//            make.right.equalTo(self).offset(-20)
//            make.centerY.equalTo(headImg)
//            make.width.equalTo(30)
//        }
//
//        let readIV = UIImageView()
//        readIV.image = UIImage.init(named: "浏览量")
//        readIV.contentMode = UIViewContentMode.scaleAspectFit
//        self.addSubview(readIV)
//        readIV.snp.updateConstraints { (make) in
//            make.right.equalTo(readL.snp.left)
//            make.centerY.equalTo(readL)
//            make.width.height.equalTo(14)
//        }
    }
    
    

}

