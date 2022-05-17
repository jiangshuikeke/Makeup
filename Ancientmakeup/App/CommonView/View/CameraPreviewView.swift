//
//  CameraPreviewView.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/12.
//

import UIKit
import AVFoundation

///摄像内容展示视图
class CameraPreviewView: UIView {

    override class var layerClass: AnyClass{
        return AVCaptureVideoPreviewLayer.self
    }

    
    //MARK: - 懒加载以及变量
    var videoPreviewLayer:AVCaptureVideoPreviewLayer{
        return layer as! AVCaptureVideoPreviewLayer
    }
}
