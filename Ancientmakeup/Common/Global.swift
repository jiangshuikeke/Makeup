//
//  Global.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/4/29.
//

import Foundation
import UIKit

///字体大小
let extraLittleFont:UIFont = UIFont.systemFont(ofSize: 13)
let LittleFont:UIFont = UIFont.systemFont(ofSize: 16)
let extraMediumFont:UIFont = UIFont.systemFont(ofSize: 18)
let mediumFont:UIFont = UIFont.systemFont(ofSize: 24)
let largeFont:UIFont = UIFont.systemFont(ofSize: 32)
let LargeTitleFont:UIFont = UIFont.systemFont(ofSize: 34)
let MainBodyFont:UIFont = UIFont.systemFont(ofSize: 14)
let ButtonFont:UIFont = UIFont.systemFont(ofSize: 16)
let Title1Font:UIFont = UIFont.systemFont(ofSize: 28)
let Title2Font:UIFont = UIFont.systemFont(ofSize: 22)
let Title3Font:UIFont = UIFont.systemFont(ofSize: 20)
let HeadLineFont:UIFont = UIFont.systemFont(ofSize: 17)
///通知
let SwitchRootViewControllerNotification = Notification.Name("SwitchRootViewControllerNotification")

//切换视图时候隐藏tabbar
let PushViewControllerTabbarIsHidden = Notification.Name("PushViewControllerTabbarIsHidden")

///发送通知显示或隐藏Tabbar
func hiddenTabbar(by isHidden:Bool){
    NotificationCenter.default.post(name: PushViewControllerTabbarIsHidden, object: isHidden)
}

//导航栏高度
let NavBarViewHeight:CGFloat = fitHeight(height: 40)


///小桃花
var littleWinterSweet:UIImageView {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "wintersweet_little")
    imageView.contentMode = .scaleAspectFit
    return imageView
}

///大桃花
var largeWinterSweet:UIImageView {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "wintersweet_large")
    imageView.contentMode = .scaleAspectFit
    return imageView
}
