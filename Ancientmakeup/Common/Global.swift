//
//  Global.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/4/29.
//

import Foundation
import UIKit

//MARK: - 应用总体色调
///背景色
let backgroundColor = UIColor(hexStr: "0xFBF2E3")
///备选色
let SkinColor = UIColor(hexStr: "0xE0E0D0")
///基色
let BaseColor = UIColor(hexStr: "0xE5E5E5")
let BlackColor = UIColor(hexStr: "0x1C1C1C")
///浅黑
let LightBlackColor = UIColor(hexStr: "0x474646")
///浅灰
let LightGrayColor = UIColor(hexStr: "0xF4F4F2")
///灰色
let GrayColor = UIColor(hexStr: "0xC4C4C4")
///深灰
let DeepGrayColor = UIColor(hexStr: "0x484848")
///主色调
let EssentialColor = UIColor(hexStr: "0xC04851")
//MARK: -字体大小
let ExtraLittleFont:UIFont = UIFont.systemFont(ofSize: 13)
let LittleFont:UIFont = UIFont.systemFont(ofSize: 16)
let extraMediumFont:UIFont = UIFont.systemFont(ofSize: 18)
let mediumFont:UIFont = UIFont.systemFont(ofSize: 24)
let largeFont:UIFont = UIFont.systemFont(ofSize: 32)
let LargeTitleFont:UIFont = UIFont.systemFont(ofSize: 34)
let MainBodyFont:UIFont = UIFont.systemFont(ofSize: 14)
let ButtonFont:UIFont = UIFont.systemFont(ofSize: 16)
let Title1Font:UIFont = UIFont.systemFont(ofSize: 28)
let Title2Font:UIFont = UIFont.boldSystemFont(ofSize: 22)
let Title3Font:UIFont = UIFont.systemFont(ofSize: 20)
let HeadLineFont:UIFont = UIFont.systemFont(ofSize: 17)
///通知
let SwitchRootViewControllerNotification = Notification.Name("SwitchRootViewControllerNotification")

//切换视图时候隐藏tabbar
let PushViewControllerTabbarIsHidden = Notification.Name("PushViewControllerTabbarIsHidden")

///发送通知显示或隐藏Tabbar
func hiddenTabbar(isHidden:Bool,tag:NSInteger){
    NotificationCenter.default.post(name: PushViewControllerTabbarIsHidden, object: isHidden,userInfo:["tag":tag])
}

//MARK: - 有关于屏幕
let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height

//适配设备宽高
func fitWidth(width:CGFloat) -> CGFloat{
    return width * ScreenWidth / 375.0
}

func fitHeight(height:CGFloat) -> CGFloat{
    return height * ScreenHeight / 812.0
}

///状态栏高度
var StatusHeight : CGFloat {
    let scence = UIApplication.shared.connectedScenes.first as! UIWindowScene
    let manager = scence.statusBarManager
    return manager?.statusBarFrame.height ?? 0
}
//导航栏高度
let NavBarViewHeight:CGFloat = StatusHeight + 44

//自定义的tabbar高度
let DIYTabBarHeight:CGFloat = fitHeight(height: 66)

//MARK: - 有关于组件
let ItemMargin:CGFloat = 20.0


//MARK: - 测试数据
func modelForMakeup() -> Makeup{
    let winter = Makeup(dict: ["name":"桃花妆","content":"比酒晕妆红色稍浅，其妆色浅而艳如桃花，故名。唐宇文式《妆台记》中写道：“美人妆，面既傅（敷）粉，复以胭脂调匀掌中，施以两颊，浓者为‘酒晕妆’，淡者为‘桃花妆’；薄薄施朱，以粉罩之，为‘飞霞妆’。”","recommendationRate":5,"figureImage":"wintersweet_title"])
    
    let step0 = LessonStep(dict:["number":0,"title":"定眉峰","toolImage":"eyebrow_pencil","stepContent":"确定眉峰位置","color":UIColor(hexStr: "0x3F2822"),"toolName":"眉笔","colorName":"深檀色","figureImage":"winter_lesson_step_0"])
    let step1 = LessonStep(dict: ["number":1,"title":"画眉尾顶部线","toolImage":"eyebrow_pencil","stepContent":"眉峰处与眉尾最高点连线","color":UIColor(hexStr: "0x3F2822"),"toolName":"眉笔","colorName":"深檀色","figureImage":"winter_lesson_step_1"])
    let step2 = LessonStep(dict: ["number":2,"title":"画眉头","toolImage":"eyebrow_pencil","stepContent":"眉头与眉峰相连，形成圆滑的曲线","color":UIColor(hexStr: "0x3F2822"),"toolName":"眉笔","colorName":"深檀色","figureImage":"winter_lesson_step_2"])
    let step3 = LessonStep(dict: ["number":3,"title":"画眉尾底部线","toolImage":"eyebrow_pencil","stepContent":"眉峰处与眉尾最底点连线","color":UIColor(hexStr: "0x3F2822"),"toolName":"眉笔","colorName":"深檀色","figureImage":"winter_lesson_step_3"])
    let step4 = LessonStep(dict: ["number":4,"title":"眉形填充","toolImage":"eyebrow_pencil","stepContent":"填充并调整眉形","color":UIColor(hexStr: "0x3F2822"),"toolName":"眉笔","colorName":"深檀色","figureImage":"winter_lesson_step_4"])
    step0.next = step1
    step1.next = step2
    step2.next = step3
    step3.next = step4
    step4.next = nil
    
    let eyebrowPart = MakeupPart(dict: ["name":"眉形"])
    eyebrowPart.step = step0
    
    let adornStep0 = LessonStep(dict: ["number":0,"title":"定花钿位置","toolImage":"adorn_black","stepContent":"眉心正上方处确定花钿位置","color":EssentialColor,"toolName":"无","colorName":"玫红色","figureImage":"adorn_lesson_step_0"])
    let adornStep1 = LessonStep(dict: ["number":1,"title":"画花钿结构","toolImage":"adorn_pencil","stepContent":"以位置中心为起点平均分为四等分，画小折角","color":EssentialColor,"toolName":"锥形细节刷","colorName":"玫红色","figureImage":"adorn_lesson_step_1"])
    let adornStep2 = LessonStep(dict: ["number":2,"title":"填充花钿","toolImage":"adorn_rendering","stepContent":"填充调整每一部分呈花瓣状","color":EssentialColor,"toolName":"小号细节刷","colorName":"玫红色","figureImage":"adorn_lesson_step_2"])
    adornStep0.next = adornStep1
    adornStep1.next = adornStep2
    adornStep2.next = nil
    let adornPart = MakeupPart(dict: ["name":"装饰"])
    adornPart.step = adornStep0
    
    winter.parts = [eyebrowPart,adornPart]
    return winter
}
