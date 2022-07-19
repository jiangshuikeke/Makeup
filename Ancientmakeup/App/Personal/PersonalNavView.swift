//
//  PersonalNavView.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/6/14.
//

import UIKit
///个人主页中的导航栏
class PersonalNavView: UIView {

    init(icon:String){
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: ScreenWidth, height: NavBarViewHeight + StatusHeight)))
        self.initView()
        //添加头像
        //TODO: - 网络加载
//        iconImageView.image = UIImage(named: icon)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///头像框
    lazy var iconImageView:UIImageView = {
        let icon = UIImageView()
        icon.layer.cornerRadius = 20
        icon.layer.masksToBounds = true
        icon.backgroundColor = .green
        icon.alpha = 0
        return icon
    }()
    
    ///消息提醒按键
    private lazy var infoRemindButton:UIButton = {
        let infoBt = UIButton(type: .custom)
        infoBt.setImage(UIImage(named: "remind"), for: .normal)
        return infoBt
    }()
    
    ///更多功能按键
    private lazy var moreFunButton:UIButton = {
        let moreBt = UIButton(type: .custom)
        moreBt.setImage(UIImage(named: "more"), for: .normal)
        return moreBt
    }()
}

//MARK: - UI
extension PersonalNavView{
    func initView(){
        addSubview(iconImageView)
        addSubview(infoRemindButton)
        addSubview(moreFunButton)
        initLayout()
    }
    
    func initLayout(){
        iconImageView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(50)
            make.height.width.equalTo(40)
        }
        
        moreFunButton.snp.makeConstraints { make in
            make.right.equalTo(self).offset(-fitWidth(width: 20))
            make.centerY.equalTo(self).offset(StatusHeight / 2)
        }
        
        infoRemindButton.snp.makeConstraints { make in
            make.right.equalTo(moreFunButton.snp.left).offset(-fitWidth(width: 15))
            make.centerY.equalTo(self).offset(StatusHeight / 2)
        }
    }
    func backgroundAlpha(alpha:CGFloat){
        backgroundColor = UIColor(white: 5, alpha: alpha)
    }
    ///显示头像并且背景色渐变
    func showIcon(){
        //1.更新布局
        iconImageView.snp.remakeConstraints { make in
            make.centerY.equalTo(self).offset(StatusHeight / 2)
            make.centerX.equalTo(self)
            make.height.width.equalTo(40)
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: []) {
            self.iconImageView.alpha = 1
            self.layoutIfNeeded()
        } completion: { flag in
            print("显示头像")
        }

    }
    
    func hideIcon(){
        iconImageView.snp.remakeConstraints{ make in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(50)
            make.height.width.equalTo(40)
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: []) {
            self.backgroundColor = .clear
            self.iconImageView.alpha = 0
            self.layoutIfNeeded()
        } completion: { flag in
            print("隐藏头像")
        }
    }
}
