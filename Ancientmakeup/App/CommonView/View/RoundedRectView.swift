//
//  RoundedRectView.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/4/17.
//

import UIKit

enum RoundedRectViewType{
    ///上部分圆角
    case TopRounded
    ///下部分圆角
    case BottomRounded
    ///圆角矩形
    case FullRounded
}
///左下，右下圆角矩形
class RoundedRectView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame:CGRect,type:RoundedRectViewType,radius:CGFloat,color:UIColor = .white){
        self.type = type
        self.radius = radius
        self.color = color
        super.init(frame: frame)
    }
    
    convenience init (type:RoundedRectViewType,radius:CGFloat,image:UIImage){
        self.init(frame: CGRect(origin: .zero, size: CGSize(width: ScreenWidth, height: fitHeight(height: 190))))
        self.radius = radius
        self.type = type
        self.image = image
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        let path : UIBezierPath
        switch type{
        case .TopRounded:
            path = UIBezierPath(roundedRect: frame, byRoundingCorners: [UIRectCorner.topLeft,UIRectCorner.topRight], cornerRadii: CGSize(width: radius, height: radius))
            break
            
        case .BottomRounded:
            path = UIBezierPath(roundedRect: frame, byRoundingCorners: [UIRectCorner.bottomRight,UIRectCorner.bottomLeft], cornerRadii: CGSize(width: radius, height: radius))
            break
        case .FullRounded:
            path = UIBezierPath(roundedRect: frame, cornerRadius: radius)
            break
        }
       
        let lay = CAShapeLayer()
        
        lay.fillColor = color.cgColor
        
        lay.path = path.cgPath
        layer.addSublayer(lay)
        if nil != image{
            initView()
        }
    }
    
    //MARK: - 变量
    private var type:RoundedRectViewType = .FullRounded
    private var radius:CGFloat = 0
    private var color:UIColor = .white
    
    ///用于存放背景图片
    private var image:UIImage?
    private lazy var imageView:UIImageView = {
        let imageView = UIImageView(frame: frame)
        imageView.contentMode = .scaleAspectFit
        imageView.image = image!
        return imageView
    }()
}

//MARK: - UI
extension RoundedRectView{
    func initView(){
        addSubview(imageView)
    }
    
}
