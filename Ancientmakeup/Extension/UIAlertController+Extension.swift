//
//  UIAlertController+Extension.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/8/6.
//

import Foundation
import UIKit

extension UIAlertController{
    
    ///错误信息提示 无处理
    convenience init(errorMessage:String) {
        self.init(title: "错误", message: errorMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "确认", style: .default, handler: nil)
        self.addAction(action)
    }
    
    ///错误信息提示 有处理
    convenience init(errorMessage:String,handleTitle:String,handle:@escaping ((UIAlertAction))->Void){
        self.init(errorMessage: errorMessage)
        let handleAction = UIAlertAction(title: handleTitle, style: .default, handler: handle)
        self.addAction(handleAction)
    }
    
    ///跳转到通用设置的提示
    convenience init(title:String,message:String){
        self.init(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .cancel,handler: nil)
        self.addAction(okAction)
        
        let settingAction = UIAlertAction(title: "设置", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else{ return }
            //严谨
            if UIApplication.shared.canOpenURL(settingsUrl){
                UIApplication.shared.open(settingsUrl, options: [:],completionHandler: nil)
            }
        }
        self.addAction(settingAction)
    }
}
