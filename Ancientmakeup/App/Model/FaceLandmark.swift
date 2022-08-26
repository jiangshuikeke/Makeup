//
//  FaceLandmark.swift
//  CoreImageTest
//
//  Created by 陈沈杰 on 2022/7/29.
//

import UIKit
import Vision

@objcMembers
///作为探测人脸后的五官图像信息类
class FaceLandmark: NSObject {
    
    override init() {
        super.init()
    }
    
    init(dict:[String:Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    
    //MARK: - 变量属性
    //人脸框
    var boundingBox:CGRect?
    var nose:Organs?
    var mouth:Organs?
    var eye:Organs?
    var eyebrow:Organs?
    var face:Organs?
    var rightEye:Organs?
    var leftEye:Organs?
    var rightEyebrow:Organs?
    var leftEyebrow:Organs?
    
    //量感 五官占脸部比例
    var quantity:CGFloat = 0{
        didSet{
            //小
            if quantity > 0.10 && quantity < 0.14{
                quantityInt = -1
            }//中
            else if quantity > 0.14 && quantity < 0.18{
                quantityInt = 0
            }//大
            else{
                quantityInt = 1
            }
        }
    }
    var quantityInt:NSInteger = 0
    //脸部轮廓
    var outline:NSInteger = 0
    //人脸风格
    var style:String{
        switch (quantityInt,outline){
            case (-1,-1):
                return "少女"
            case (0,-1):
                return "柔和"
            case (1,-1):
                return "华美"
            case (-1,0):
                return "自然"
            case (0,0):
                return "均衡"
            case (1,0):
                return "大气"
            case (-1,1):
                return "少年"
            case (0,1):
                return "摩登"
            case (1,1):
                return "戏剧"
            default:
                return "出错了"
        }
    
    }
}
