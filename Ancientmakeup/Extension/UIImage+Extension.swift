//
//  UIImage+Extension.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/4/19.
//

import Foundation
import UIKit

extension UIImage{
    ///纯色图片
    convenience public init(color:UIColor) {
        let rect = CGRect(origin: .zero, size: CGSize(width: 1.0, height: 1.0))
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.init(cgImage: image.cgImage!)
    }
    
    //实现图像方向正确
    func fixedImage() -> UIImage?{
        if self.imageOrientation == .up{
            return self
        }
        
        var transform = CGAffineTransform.identity
        
        switch imageOrientation{
            case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -.pi / 2)
            break
        default:
            break
        }
        
        switch imageOrientation{
            case .upMirrored, .downMirrored:
                transform = transform.translatedBy(x: self.size.width, y: 0)
                transform = transform.scaledBy(x: -1, y: 1)
                break
            case .leftMirrored, .rightMirrored:
                transform = transform.translatedBy(x: self.size.height, y: 0)
                transform = transform.scaledBy(x: -1, y: 1)
                break
            default:
                break
        }
        
        let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: self.cgImage!.bitmapInfo.rawValue)
        
        switch imageOrientation{
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
            break
        default:
            ctx?.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            break
        }
        
        let cgImage = ctx?.makeImage()!
        guard let cgImage = cgImage else{ return nil }
        return UIImage(cgImage: cgImage)
    }
    
    var cgImageOrientation:CGImagePropertyOrientation {
        switch imageOrientation{
        //图片顺时针旋转90度，如果iPhone拍摄手机需要旋转180度（前置摄像头的话也是如此）
        case .left:
            return CGImagePropertyOrientation.left
        case .leftMirrored:
            return CGImagePropertyOrientation.leftMirrored
        //图片逆时针旋转90度，如果iPhone拍摄手机竖屏即可（前置摄像头的话也是如此)
        case .right:
            return CGImagePropertyOrientation.right
        case .rightMirrored:
            return CGImagePropertyOrientation.rightMirrored
        //图片方向朝上，如果iPhone拍摄手机需要逆时针旋转90度（前置摄像头的话则顺时针旋转90度)
        case .up:
            return CGImagePropertyOrientation.up
        case .upMirrored:
            return CGImagePropertyOrientation.upMirrored
        //图片旋转180度，如果iPhone拍摄手机需要顺时针旋转90度(前置摄像头的话则逆时针90度)
        case .down:
            return CGImagePropertyOrientation.down
        case .downMirrored:
            return CGImagePropertyOrientation.downMirrored
        @unknown default:
            print("转化出现问题")
            return CGImagePropertyOrientation.up
        }
    }
    
}
