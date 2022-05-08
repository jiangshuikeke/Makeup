//
//  PersonalHeaderView.swift
//  ScorllviewTest
//
//  Created by 陈沈杰 on 2022/4/21.
//

import UIKit
///个人界面的头部View
class PersonalHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        layoutIfNeeded()
        
        let viewHeight = fansDisplayView.frame.maxY
        return CGSize(width: ScreenWidth, height: viewHeight)
    }
    
    
    
    //MARK: - 懒加载以及变量
    
    ///背景圆角矩形
    public lazy var roundedRect : RoundedRectView = {
//        return RoundedRectView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: fitHeight(height: 195)),type: .BottomRounded,radius: 30,color: SkinColor)
        return RoundedRectView(type: .BottomRounded, radius: 30, image: UIImage(named: "page0")!)
    }()
    
    ///头像框
    private lazy var iconImageView:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = fitWidth(width: 44)
        image.layer.masksToBounds = true
        image.layer.borderWidth = 2.0
        image.layer.borderColor = LightGrayColor.cgColor
        image.backgroundColor = EssentialColor
        
        return image
    }()
    
    ///昵称
    private lazy var nicknameLabel : UILabel = {
       let nickname = UILabel()
        nickname.textAlignment = .center
        nickname.text = "bLacKpinK"
        nickname.font = UIFont.boldSystemFont(ofSize: 32)
        nickname.textColor = DeepGrayColor
        return nickname
    }()
    
    ///个性签名
    private lazy var signLabel : UILabel = {
        let sign = UILabel()
        sign.textAlignment = .center
        sign.text = "中国人不骗中国人"
        sign.font = UIFont.systemFont(ofSize: 16)
        sign.textColor = DeepGrayColor
        return sign
    }()
    
    ///粉丝
    private lazy var fansDisplayView : DisplayView = {
        return DisplayView(title: "粉丝", number: "8")
    }()
    
    ///关注
    private lazy var foucsDisplayView:DisplayView = {
        return DisplayView(title: "关注", number: "108")
    }()

}

//MARK: - UI
extension PersonalHeaderView{
    func initView(){
        addSubview(roundedRect)
        addSubview(iconImageView)
        addSubview(nicknameLabel)
        addSubview(signLabel)
        addSubview(foucsDisplayView)
        addSubview(fansDisplayView)
        initLayout()
    }
    
    func initLayout(){
        roundedRect.snp.makeConstraints { make in
            make.left.right.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(fitHeight(height: 195))
        }
        iconImageView.snp.makeConstraints { make in
            make.width.equalTo(fitWidth(width: 88))
            make.height.equalTo(fitWidth(width: 88))
            make.centerX.equalTo(self)
            make.top.equalTo(roundedRect.snp.bottom).offset(-fitWidth(width: 44))
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.top.equalTo(iconImageView.snp.bottom).offset(fitHeight(height: 4))
        }
        
        signLabel.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(fitHeight(height: 4))
        }
        
        foucsDisplayView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(fitWidth(width: 35))
            make.width.equalTo(fitWidth(width: 145))
            make.height.equalTo(fitHeight(height: 75))
            make.top.equalTo(signLabel.snp.bottom).offset(fitHeight(height: 8))
        }
        
        fansDisplayView.snp.makeConstraints { make in
            make.right.equalTo(self).offset(-fitWidth(width: 35))
            make.top.equalTo(foucsDisplayView)
            make.width.equalTo(fitWidth(width: 145))
            make.height.equalTo(fitHeight(height: 75))
        }
    }
    
    func rectZoom(scale:CGFloat){
        let s = abs(scale)
        roundedRect.transform = roundedRect.transform.scaledBy(x: s, y: s)
    }
}
