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
    ///妆容每一个部位
    var parts:[MakeupPart]?
    ///特征
    var characteristics = [String]()
    //妆容滤镜
    var filter:String?
    //妆容整体步骤
    var step:NSInteger = 0
    ///妆容故事
//    var story:MakeupStory?
    
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
        
        if key == "characteristics"{
            if let arr = value as? [String]{
                //简单数据类型如整形，字符串，结构体，采用的是深拷贝
                characteristics = arr
            }
        }
        
//        if key == "story"{
//            if let dict = value as? [String:Any]{
//                let story = MakeupStory(dict: dict)
//                self.story = story
//            }
//            return
//        }
        super.setValue(value, forKey: key)
    }
    
}
