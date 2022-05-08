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
let littleFont:UIFont = UIFont.systemFont(ofSize: 16)
let extraMediumFont:UIFont = UIFont.systemFont(ofSize: 18)
let mediumFont:UIFont = UIFont.systemFont(ofSize: 24)
let largeFont:UIFont = UIFont.systemFont(ofSize: 32)
let LargeTitleFont:UIFont = UIFont.systemFont(ofSize: 34)
let MainBodyFont:UIFont = UIFont.systemFont(ofSize: 14)
let ButtonFont:UIFont = UIFont.systemFont(ofSize: 16)
let Title1Font:UIFont = UIFont.systemFont(ofSize: 28)
let HeadLineFont:UIFont = UIFont.systemFont(ofSize: 17)
///通知
let SwitchRootViewControllerNotification = Notification.Name("SwitchRootViewControllerNotification")

//切换视图时候隐藏tabbar
let PushViewControllerTabbarIsHidden = Notification.Name("PushViewControllerTabbarIsHidden")
let PushViewControllerTabbarDisplay = Notification.Name("PushViewControllerTabbarDisplay")
