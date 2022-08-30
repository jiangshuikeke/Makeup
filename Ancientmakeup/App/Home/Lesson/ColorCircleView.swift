//
//  ColorCircleView.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/8/28.
//

import UIKit

///自定义色环View
enum ColorLocation {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}
class ColorCircleView: UIView {

    convenience init(color:UIColor,location:ColorLocation){
        self.init(frame: CGRect(origin: .zero, size:CGSize(width: 50, height: 50)))
        self.color = color
        self.location = location
    }
    
    convenience init(){
        self.init(frame: CGRect(origin: .zero, size:CGSize(width: 50, height: 50)))
    }

    override func draw(_ rect: CGRect) {
        //先移除
        if (layer.sublayers != nil){
            layer.sublayers?.removeAll()
        }
        
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        //首先画个圆
        let circle = UIBezierPath(arcCenter:center, radius: 25, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        //画十字
        circle.addLine(to: CGPoint(x: 0, y: rect.height / 2))
        circle.move(to: CGPoint(x: rect.width / 2, y: 0))
        circle.addLine(to: CGPoint(x: rect.width / 2, y: rect.height))
        //绘制背景圆盘
        let back = CAShapeLayer()
        back.path = circle.cgPath
        back.fillColor = UIColor.clear.cgColor
        back.borderWidth = 1.0
        back.strokeColor = UIColor.black.cgColor
        //根据位置定始末点
        var endAngle:CGFloat = 0
        var startAngle:CGFloat = 0
        var clockwise = true
        switch location{
        case .topLeft:
            startAngle = .pi
            endAngle = 3 * .pi / 2
            break
        case .topRight:
            endAngle = 3 * .pi / 2
            clockwise = false
            break
        case .bottomLeft:
            startAngle = .pi / 2
            endAngle = .pi
            break
        case .bottomRight:
            endAngle = .pi / 2
            break
        }
        //绘制四分之一圆
        let quarterCirclePath = UIBezierPath(arcCenter: center, radius: 28, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        quarterCirclePath.addLine(to: center)
        quarterCirclePath.close()
        let quarterCircle = CAShapeLayer()
        quarterCircle.path = quarterCirclePath.cgPath
        quarterCircle.fillColor = color.cgColor
        quarterCircle.strokeColor = UIColor.black.cgColor
        quarterCircle.borderWidth = 1.0
        //图层添加
        back.addSublayer(quarterCircle)
        layer.addSublayer(back)
    }
    
    //MARK: - 全局变量以及懒加载
    var color:UIColor = .white
    var location:ColorLocation = .topRight
    
}
