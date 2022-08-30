//
//  MakeupStepView.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/7/4.
//

import UIKit

///步骤卡片View
class MakeupStepView: UIView {
    convenience init() {
        self.init(frame: CGRect(origin: .zero, size: CGSize(width: ScreenWidth - fitWidth(width: 105), height: 275)))
        initView()
    }
    
    //MARK: - 懒加载以及变量
    var step:LessonStep?{
        didSet{
            titleView.title = step!.title
            titleView.setTitleColor(BlackColor, for: .normal)
            colorImageView.color = step!.color!
            colorImageView.location = quarterCircleLocation(by: step!.number)
            colorImageView.setNeedsDisplay()
            toolImageView.image = UIImage(named: step!.toolImage ?? "error")
            stepContentLabel.text = step!.stepContent
            colorLabel.text = step!.colorName
        }
    }
    
    private lazy var titleView:ITButton = {
        return ITButton()
    }()
    
    private lazy var toolImageView:UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var stepContentLabel:UILabel = {
        let label = UILabel()
        label.preferredMaxLayoutWidth = 160
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var colorImageView:ColorCircleView = ColorCircleView()
    
    private lazy var colorLabel:UILabel = {
        let label = UILabel()
        return label
    }()
}

//MARK: - UI
private extension MakeupStepView{
    func initView(){
        let blur = blurView(radius: 20)
        
        blur.contentView.addSubview(titleView)
        blur.contentView.addSubview(toolImageView)
        blur.contentView.addSubview(stepContentLabel)
        blur.contentView.addSubview(colorLabel)
        blur.contentView.addSubview(colorImageView)
        self.addSubview(blur)
        initLayout()
    }
    
    func initLayout(){
        titleView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(fitWidth(width: 20))
            make.top.equalTo(self).offset(20)
        }
        
        toolImageView.snp.makeConstraints { make in
            make.left.equalTo(titleView).offset(20)
            make.top.equalTo(titleView.snp.bottom).offset(20)
        }
        
        stepContentLabel.snp.makeConstraints { make in
            make.left.equalTo(colorImageView.snp.right).offset(fitWidth(width: 20))
            make.centerY.equalTo(toolImageView)
        }
        
        colorImageView.snp.makeConstraints { make in
            make.centerX.equalTo(toolImageView)
            make.top.equalTo(toolImageView.snp.bottom).offset(20)
            make.height.width.equalTo(50)
        }
        
        colorLabel.snp.makeConstraints { make in
            make.left.equalTo(stepContentLabel)
            make.centerY.equalTo(colorImageView)
        }
    }
}
