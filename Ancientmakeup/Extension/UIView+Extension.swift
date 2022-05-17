//
//  UIView+Extension.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/4/18.
//

import Foundation
import UIKit


extension UIView{
    
    ///添加毛玻璃样式
    func addBlurStyle(){
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
       
        blurView.frame = bounds
        blurView.layer.cornerRadius = 10
        blurView.layer.masksToBounds = true
        addSubview(blurView)
        sendSubviewToBack(blurView)
    }
    
    ///绘制下半圆弧
    func addCurve(color:UIColor){
        //绘制涂层
        let shape = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: 0, y: frame.height))
        path.addLine(to: CGPoint(x: fitWidth(width: 100), y: frame.height))
        //绘制曲线
        path.addCurve(to: CGPoint(x: center.x, y: frame.height + 20), controlPoint1: CGPoint(x: center.x - 40, y: frame.height), controlPoint2: CGPoint(x: center.x - 40, y: frame.height + 20))
        path.addCurve(to: CGPoint(x: center.x + (ScreenWidth - 2 * fitWidth(width: 100)) / 2, y: frame.height ), controlPoint1: CGPoint(x: center.x + 40 , y: frame.height + 20), controlPoint2: CGPoint(x: center.x + 40, y: frame.height ))
        path.addLine(to: CGPoint(x: ScreenWidth, y: frame.height))
        path.addLine(to: CGPoint(x: ScreenWidth, y: 0))
        path.close()
        shape.path = path.cgPath
        shape.fillColor = color.cgColor
        layer.addSublayer(shape)
    }
    
    ///绘制上部分的圆弧
    func drawTopCurve(color:UIColor){
        let shape = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: fitWidth(width: 100), y: 0))
        path.addCurve(to: CGPoint(x: center.x, y: 20), controlPoint1: CGPoint(x: center.x - 40, y: 0), controlPoint2: CGPoint(x: center.x - 40, y: 20))
        path.addCurve(to: CGPoint(x: center.x + (ScreenWidth - 2 * fitWidth(width: 100)) / 2, y: 0 ), controlPoint1: CGPoint(x: center.x + 40 , y: 20), controlPoint2: CGPoint(x: center.x + 40, y: 0 ))
        path.addLine(to: CGPoint(x: ScreenWidth, y: 0))
        path.addLine(to: CGPoint(x: ScreenWidth, y: frame.height))
        path.addLine(to: (CGPoint(x: 0, y: frame.height)))
        path.close()
        shape.path = path.cgPath
        shape.fillColor = color.cgColor
        layer.mask = shape
    }
    
    ///绘制阴影
    func addShadow(){
        layer.shadowOpacity = 0.6
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowColor = BlackColor.cgColor
    }
}
