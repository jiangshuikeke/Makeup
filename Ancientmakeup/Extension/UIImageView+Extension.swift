//
//  UIImageView+Extension.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/5.
//

import Foundation
import UIKit

extension UIImageView{
    
    //为View设置边距
    func padding(_ all:CGFloat){
        guard let image = self.image else{
            print("当前Image为nil")
            return
        }
        
        let originSize = self.frame.size
        var scaledSize:CGSize = .zero
        
        if image.size.width > image.size.height{
            let radio = image.size.height / image.size.width
            scaledSize = CGSize(width: originSize.width - 2 * all, height: (originSize.height - 2 * all) * radio)
        }else{
            let radio = image.size.height / image.size.width
            scaledSize = CGSize(width: (originSize.width - 2 * all) * radio, height: originSize.height - 2 * all)
        }
        
        UIGraphicsBeginImageContextWithOptions(scaledSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
        let new = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.image = new
    }
}
