//
//  Organs.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/6/20.
//

import UIKit

///五官描述
class Organs: NSObject {
    override init() {
        super.init()
    }
    
    convenience init(dict:[String:Any]) {
        self.init()
        setValuesForKeys(dict)
    }
    
    //MARK: - 属性
    
    private var name:String = ""
    private var content:String = ""
    private var image:String = ""
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
