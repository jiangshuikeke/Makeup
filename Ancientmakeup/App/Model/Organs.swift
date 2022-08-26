//
//  Organs.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/6/20.
//

import UIKit

///五官描述
@objcMembers
class Organs: NSObject {
    override init() {
        super.init()
    }
    
    init(name:String,content:String,image:UIImage) {
        super.init()
        self.name = name
        self.content = content
        self.image = image
    }
    
    convenience init(image:UIImage,cgImage:CGImage) {
        self.init()
        self.image = image
        self.cgImage = cgImage
    }
    
    convenience init(dict:[String:Any]) {
        self.init()
        setValuesForKeys(dict)
    }
    
    //MARK: - 属性
    var name:String?
    var content:String?
    var image:UIImage?
    var cgImage:CGImage?
    var type:OrgansType?
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
