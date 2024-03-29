//
//  ToolView.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/7/5.
//

import UIKit

///工具视图
class ToolView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(step:LessonStep) {
        self.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth - fitWidth(width: 40), height: 170))
        initView()
        self.step = step
    }
    
    convenience init(){
        self.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth - fitWidth(width: 90), height: 170))
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - 懒加载以及变量
    private lazy var toolImageView:UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var toolLabel:UILabel = {
        let label = UILabel()
//        label.layer.cornerRadius = 20
//        label.layer.masksToBounds = true
//        label.layer.borderColor = BlackColor.cgColor
//        label.layer.borderWidth = 1
        return label
    }()
    
    private lazy var colorImageView:ColorCircleView = ColorCircleView()
    
    private lazy var colorLabel:UILabel = {
        let label = UILabel()
        return label
    }()
    
    var step:LessonStep?{
        didSet{
            //根据步骤绘制四分之一圆
            
            toolImageView.image = UIImage(named: step!.toolImage ?? "error")
            toolLabel.text = step!.toolName
            colorLabel.text = step!.colorName
            colorImageView.color = step!.color!
            colorImageView.location = quarterCircleLocation(by: step!.number)
            colorImageView.setNeedsDisplay()
            toolLabel.sizeToFit()
            colorLabel.sizeToFit()
            addRoundedRect(label: toolLabel)
            addRoundedRect(label: colorLabel)
            
        }
    }

}

//MARK: - UI
extension ToolView{
    func initView(){
        let blurView = blurView(radius: 20)
        addSubview(blurView)
        blurView.contentView.addSubview(toolImageView)
        blurView.contentView.addSubview(toolLabel)
        blurView.contentView.addSubview(colorImageView)
        blurView.contentView.addSubview(colorLabel)
        initLayout()
    }
    
    func initLayout(){
        toolImageView.snp.makeConstraints { make in
            make.centerX.equalTo(self).offset(-60)
            make.top.equalTo(self).offset(35)
            make.width.equalTo(fitWidth(width: 62))
            make.height.equalTo(fitHeight(height: 62))
        }
        
        toolLabel.snp.makeConstraints { make in
            make.centerX.equalTo(toolImageView)
            make.top.equalTo(toolImageView.snp.bottom).offset(20)
        }
        
        colorImageView.snp.makeConstraints { make in
            make.centerX.equalTo(self).offset(60)
            make.centerY.equalTo(toolImageView)
            
            make.height.width.equalTo(50)
        }
        
        colorLabel.snp.makeConstraints { make in
            make.centerY.equalTo(toolLabel)
            make.centerX.equalTo(colorImageView)
        }
    }
    
    func addRoundedRect(label:UILabel){
        var new = label.bounds
        new.size.width += 12
        new.size.height += 8
        new.origin.x -= 6
        new.origin.y -= 4
        let path = UIBezierPath(roundedRect: new, cornerRadius: 10)
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.borderWidth = 1
        shape.strokeColor = BlackColor.cgColor
        shape.fillColor = UIColor.clear.cgColor
        label.layer.sublayers?.removeAll()
        label.layer.addSublayer(shape)
    }
}
