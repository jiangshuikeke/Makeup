//
//  UIView+Extension.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/4/18.
//

import Foundation
import UIKit


extension UIView{
    
    ///添加毛玻璃样式
    func addBlurStyle(){
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = frame
        blurView.layer.cornerRadius = 10
        blurView.layer.masksToBounds = true
        addSubview(blurView)
        sendSubviewToBack(blurView)
    }
}
