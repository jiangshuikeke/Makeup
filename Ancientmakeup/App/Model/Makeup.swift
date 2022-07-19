//
//  Makeup.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/6/20.
//

import UIKit
///妆容类
///swift 4.0之后kvc 需要加上注解才能有效
@objcMembers
class Makeup: NSObject,NSMutableCopying {
    //深拷贝 值也会复制
    func mutableCopy(with zone: NSZone? = nil) -> Any {
        let makeup = Makeup()
        makeup.parts = self.parts
        makeup.name = self.name
        makeup.content = self.content
        makeup.recommendationRate = self.recommendationRate
        makeup.figureImage = self.figureImage
        return makeup
    }
    
    //MARK: - 属性
    
    ///妆容名称
    var name:String?
    ///妆容内容
    var content:String?
    ///推荐指数
    var recommendationRate:Int = 5
    ///妆容图片
    var figureImage:String?
    
    var parts:[MakeupPart]?
    
    init(dict:[String:Any]) {
        super.init()
        self.setValuesForKeys(dict)
    }
    
    override init() {
        super.init()
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("undefinedKey : \(key)")
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "parts"{
            if let dicts = value as? [[String:Any]] {
                for dict in dicts {
                    let part = MakeupPart(dict: dict)
                    parts?.append(part)
                }
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    
}
