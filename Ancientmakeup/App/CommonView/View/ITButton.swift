//
//  ITButton.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/6/28.
//

import UIKit

enum ImageAlignment {
    case left
    case right
    case top
    case bottom
}

///标题图像
class ITButton: UIButton {
    
    convenience init(title:String){
        self.init()
        let attrbuteTitle = NSAttributedString(string: title, attributes:[.font:Title2Font])
        setAttributedTitle(attrbuteTitle, for: .normal)
    }
    
    convenience init() {
        self.init(image: "reddot",font: Title2Font)
    }
    
    convenience init(image:String,font:UIFont){
        var con = UIButton.Configuration.plain()
        con.imagePadding = 6
        con.imagePlacement = .leading
        con.baseForegroundColor = UIColor.black
        con.image = UIImage(named: image)
        self.init(configuration: con, primaryAction:nil)
        self.font = font
//        titleLabel?.frame = CGRect(origin: .zero, size: CGSize(width: fitWidth(width: 88), height: fitHeight(height: 44)))
        titleLabel?.numberOfLines = 0
        titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel?.preferredMaxLayoutWidth = fitWidth(width: 88)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK: - 懒加载以及变量
    private var alignment:ImageAlignment = .left
    private var font:UIFont?
    var title:String?{
        didSet{
            let attrbuteTitle = NSAttributedString(string: title!, attributes:[.font:font!])
            setAttributedTitle(attrbuteTitle, for: .normal)
        }
    }
}



