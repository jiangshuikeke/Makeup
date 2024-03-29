//
//  NavView.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/4/29.
//

import UIKit

///导航视图的背景图
class NavView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(image:UIImage,title:String,content:String){
        self.init(frame: CGRect(origin: .zero, size: CGSize(width: ScreenWidth, height: ScreenHeight - 180)))
        imageView.image = image
        titleLabel.text = title
        contentLabel.text = content
    }
    
    //MARK: - 懒记载以及变量
    private lazy var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = EssentialColor
        label.textAlignment = .center
        label.font = Title1Font
        return label
    }()
    
    private lazy var contentLabel:UILabel = {
        let label = UILabel()
        label.textColor = LightBlackColor
        label.preferredMaxLayoutWidth = fitWidth(width: 300)
        label.numberOfLines = 0
        label.font = MainBodyFont
        return label
    }()
    
    private lazy var backgroundView:RoundedRectView = {
        return RoundedRectView(frame:self.frame, type: .BottomRounded, radius: 50)
    }()
    
    //黑色圆背景
    private lazy var circleView:UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = fitWidth(width: 155)
        view.layer.masksToBounds = true
        return view
    }()


}

//MARK: - UI
extension NavView{
    func initView(){
        addSubview(backgroundView)
        addSubview(circleView)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(contentLabel)
        initLayout()
    }
    
    func initLayout(){
        
        circleView.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.height.equalTo(fitWidth(width: 310))
        }
       
        contentLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(-50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.bottom.equalTo(contentLabel.snp.top).offset(-11)
            make.height.equalTo(fitHeight(height: 41))
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.width.equalTo(fitWidth(width: 310))
            make.height.equalTo(fitHeight(height: 310))
            make.bottom.equalTo(titleLabel.snp.top).offset(-35)
        }
    }
    
    ///添加背景
    
}
