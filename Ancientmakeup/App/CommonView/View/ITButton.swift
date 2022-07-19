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
    convenience init(title:String,alignment:ImageAlignment) {
        self.init(type: .custom)
        setTitle(title, for: .normal)
        setTitleColor(.black, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel?.sizeToFit()
        self.alignment = alignment
//        isEnabled = false
        initView()
    }
    
    convenience init() {
        self.init(type: .custom)
        titleLabel?.font = Title2Font
        initView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //设置边距
//        let titleW = titleLabel?.bounds.width ?? 0
//        let titleH = titleLabel?.bounds.height ?? 0
//        let imageW = imageView?.bounds.width ?? 0
//        let imageH = imageView?.bounds.height ?? 0
        let space:CGFloat = 3
        
        switch alignment {
            case .left:
            titleEdgeInsets = UIEdgeInsets(top: 0, left: space, bottom: 0, right: -space)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -space, bottom: 0, right: space)
            break
            case .right: break
            case .top: break
            case .bottom: break
        }
    }
    
    //MARK: - 懒加载以及变量
    private var alignment:ImageAlignment = .left
    
    var title:String?{
        didSet{
            setTitle(title, for: .normal)
        }
    }
}

extension ITButton{
    func initView(){
        imageView?.frame.size = CGSize(width: 10, height: 10)
        imageView?.layer.cornerRadius = 5
        imageView?.layer.masksToBounds = true
        setImage(UIImage(named: "reddot"), for: .normal)
    }

}


