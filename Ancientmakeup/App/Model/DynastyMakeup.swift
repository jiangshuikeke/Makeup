//
//  DynastyMakeup.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/6/20.
//

import UIKit
///朝代妆容
@objcMembers
class DynastyMakeup: NSObject {
    override init() {
        super.init()
    }
    
    init(dict:[String:Any]){
        super.init()
        setValuesForKeys(dict)
    }
    
    //MARK: - 属性
    var name:String?
    var content:String?
    //朝代背景图
    var image:String?
    ///该朝代下的妆容
    var makeups:[Makeup]?
    override func setValue(_ value: Any?, forKey key: String) {
        
        //需要转化
        if key == "makeups"{
            makeups = [Makeup]()
            if let array = value as? NSArray{
                for dict in array{
                    let makeup = Makeup(dict: dict as! [String : Any])
                    makeups?.append(makeup)
                }
            }
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    override func value(forUndefinedKey key: String) -> Any? {
        print("无定义")
    }
}
