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
    
    
}
