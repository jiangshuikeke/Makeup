//
//  MakeupStory.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/6/23.
//

import UIKit

///妆容故事
@objcMembers
class MakeupStory: NSObject {
    override init() {
        super.init()
    }
    
    convenience init(dict:[String:Any]) {
        self.init()
        setValuesForKeys(dict)
    }
    
    //MARK: - 属性
    var name:String?
    var content:String?
    var image:String?
    
}
