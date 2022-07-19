//
//  LessonStep.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/7/5.
//

import UIKit
///妆容教学
@objcMembers
class LessonStep: NSObject {
    init(dict:[String:Any]){
        super.init()
        setValuesForKeys(dict)
    }
    
    //MARK: - 变量
    //步骤部位
    var part:String?
    //第几步骤
    var number:NSInteger = 0
    var title:String?
    var toolImage:String?
    var stepContent:String?
    var color:UIColor?
    var toolName:String?
    var colorName:String?
    var figureImage:String?
    var next:LessonStep?
    var pre:LessonStep?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "next" || key == "pre"{
            var step:LessonStep
            if let dict = value as? [String:Any]{
                step = LessonStep(dict: dict)
                if key == "next"{
                    next = step
                }else{
                    pre = step
                }
            }
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
