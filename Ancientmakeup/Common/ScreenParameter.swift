//
//  ScreenParameter.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/4/15.
//
//屏幕尺寸的参数
import Foundation
import UIKit

let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height

//适配设备宽高
func fitWidth(width:CGFloat) -> CGFloat{
    return width * ScreenWidth / 375.0
}

func fitHeight(height:CGFloat) -> CGFloat{
    return height * ScreenHeight / 667
}

///状态栏高度
var StatusHeight : CGFloat {
    let scence = UIApplication.shared.connectedScenes.first as! UIWindowScene
    let manager = scence.statusBarManager
    return manager?.statusBarFrame.height ?? 0
}



