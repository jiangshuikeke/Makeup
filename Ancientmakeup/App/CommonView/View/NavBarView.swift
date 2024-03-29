//
//  NavBarView.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/3.
//

import UIKit

///自定义导航栏视图
class NavBarView: UIView {
    
    init() {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: ScreenWidth, height: StatusHeight + 44)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title:String?){
        self.init()
            titleLabel.text = title
            initView()
    }
    
    convenience init(icon:String?,nickname:String?){
        self.init()
        addCurve(color: SkinColor)
        isDetail = true
        initView()
    }
    
    //MARK: - 懒加载以及变量
    private lazy var backImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.frame.size = CGSize(width: 50, height: 50)
        imageView.image = UIImage(named: "back_arrow")
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backViewController)))
        return imageView
    }()
    
    //导航标题
    lazy var titleLabel:UILabel = {
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
    
    //
    public lazy var rightButton:UIButton = UIButton()
    
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
            make.centerY.equalTo(self).offset(StatusHeight / 2)
            make.left.equalTo(self).offset(fitWidth(width: 20))
            make.height.equalTo(fitWidth(width: 44))
            make.width.equalTo(fitWidth(width: 44))
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
            make.centerY.equalTo(self).offset(StatusHeight / 2)
            make.centerX.equalTo(self)
        }
        
    }
    
    //
    func configureRightButton(imageName:String,name:String?,imageColor:UIColor = .black){
        rightButton.setTitle(name, for: .normal)
        rightButton.setImage(UIImage(named: imageName)?.withTintColor(imageColor), for: .normal)
        rightButton.imageView?.contentMode = .scaleAspectFit
        addSubview(rightButton)
        rightButton.snp.makeConstraints { make in
            make.centerY.equalTo(backImageView)
            make.right.equalTo(self).offset(-fitWidth(width: 20))
            make.height.width.equalTo(fitWidth(width: 30))
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
