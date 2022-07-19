//
//  MakupPart.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/7/6.
//

import UIKit

///妆容部分
@objcMembers
class MakeupPart: NSObject {
    init(dict:[String:Any]){
        super.init()
        setValuesForKeys(dict)
    }
    
    var name:String?
    var step:LessonStep?
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
