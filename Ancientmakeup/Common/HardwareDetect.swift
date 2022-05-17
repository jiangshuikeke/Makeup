//
//  HardwareDetect.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/11.
//

///用于检测设备是否存在某些硬件
import Foundation
import UIKit


func judgeIsCameraExist() -> Bool{
    return UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
}

//显示相册或者摄像内容
//func showImagePicker(sourceType:UIImagePickerController.SourceType)
