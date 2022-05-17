//
//  NavBarView.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/3.
//

import UIKit

///自定义导航栏视图
class NavBarView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title:String?){
        self.init(frame: CGRect(origin: CGPoint(x: 0, y: StatusHeight), size: CGSize(width: ScreenWidth, height: NavBarViewHeight)))
        if title != nil{
            titleLabel.text = title
        }
        isDetail = false
        initView()
    }
    
    convenience init(icon:String?,nickname:String?){
        self.init(frame: CGRect(origin: CGPoint(x: 0, y: StatusHeight), size: CGSize(width: ScreenWidth, height: fitHeight(height: 50))))
        addCurve(color: SkinColor)
        isDetail = true
        initView()
    }
    
    //MARK: - 懒加载以及变量
    private lazy var backImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.frame.size = CGSize(width: 50, height: 50)
//        imageView.layer.backgroundColor = BlackColor.cgColor
//        imageView.layer.cornerRadius = 18
//        imageView.contentMode = .center
        imageView.image = UIImage(named: "back_arrow")
//        imageView.padding(15)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backViewController)))
        return imageView
    }()
    
    //导航标题
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        //加粗
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    //头像
    private lazy var iconImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .green
        return imageView
    }()
    
    //昵称
    private lazy var nicknameLabel:UILabel = {
        let label = UILabel()
        label.contentMode = .center
        label.font = HeadLineFont
        label.textColor = DeepGrayColor
        label.text = "Greg"
        return label
    }()
    
    var title:String?{
        didSet{
            titleLabel.text = title
        }
    }
    
    //是否是详细动态页的导航栏
    private var isDetail:Bool = false
    
    open weak var delegate:NavBarViewDelegate?
    
}

//MARK: - UI
extension NavBarView{
    func initView(){
        self.backgroundColor = .clear
        addSubview(backImageView)
        backImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(fitWidth(width: 20))
            make.height.equalTo(40)
            make.width.equalTo(40)
        }

        if isDetail{
            prepareForDeatil()
        }else{
            prepareForNormal()
        }
        
    }
    
    func prepareForNormal(){
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.centerX.equalTo(self)
        }
    }
    
    //配置详细动态导航栏
    func prepareForDeatil(){
        addSubview(nicknameLabel)
        addSubview(iconImageView)
        
        nicknameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(iconImageView.snp.bottom).offset(6)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(6)
            make.height.equalTo(33)
            make.width.equalTo(33)
        }
    }
}

//按键事件处理
extension NavBarView{
    //回退
    @objc func backViewController(){
        delegate?.back()
    }
}

protocol NavBarViewDelegate : NSObjectProtocol{
    func back()
}
