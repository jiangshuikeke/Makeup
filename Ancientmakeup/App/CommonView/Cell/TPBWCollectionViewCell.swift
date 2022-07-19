//
//  TPBWCollectionViewCell.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/6/20.
//

import UIKit

enum TPBWCollectionViewCellType {
    case organs
    case dynasty
}

///上图下文字Cell
class TPBWCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(dynasty:String){
        self.init(frame: .zero)
        type = .dynasty
        self.titleLabel.text = dynasty
        initView()
    }
    
    convenience init(type:OragnsType){
        self.init(frame: .zero)
        contentType = type
        self.type = .organs
        initView()
    }
    
    override var isSelected: Bool{
        didSet{
            viewIsSelected()
        }
    }
    //MARK: - 懒加载以及变量
    private lazy var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    open lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = LittleFont
        label.textColor = .white
        return label
    }()
    
    private lazy var blurView:UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.layer.cornerRadius = 30
        blurView.layer.masksToBounds = true
        blurView.frame.size = CGSize(width: 80, height: 76)
        return blurView
    }()
    
    //图像名字
    private var named:String?
    //内容类型
    var contentType:OragnsType? {
        didSet{
            configureViewByType()
        }
    }
    var isLessonPattern:Bool = false
    //整个组件类型 默认五官
    var type:TPBWCollectionViewCellType = .organs
    
}

//UI
extension TPBWCollectionViewCell{
    func initView(){
        contentView.addSubview(blurView)
        blurView.contentView.addSubview(imageView)
        blurView.contentView.addSubview(titleLabel)
        initLayout()
    }
    
    func initLayout(){
        imageView.snp.makeConstraints { make in
            make.centerX.equalTo(blurView)
            make.top.equalTo(blurView).offset(15)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(blurView)
            make.top.equalTo(imageView.snp.bottom).offset(5)
        }
        
    }
    
    //根据类型配置视图
    func configureViewByType(){
        var title = ""
        switch contentType{
        case .none:
            break
        case .some(.eyebrow):
            named = "eyebrow"
            title = "眉形"
        case .some(.nose):
            named = "nose"
            title = "鼻型"
        case .some(.mouse):
            named = "mouse"
            title = "唇部"
        case .some(.face):
            named = "face_white"
            title = "面部"
        case .some(.eye):
            named = "eye"
            title = "眼部"
        case .some(.adorn):
            named = "adorn_white"
            title = "装饰"
        }
    
        imageView.image = UIImage(named: named!)?.withTintColor(EssentialColor)
        titleLabel.text = title
    }
    
    ///配置圆形imageview
    func configureCircleImageView(){
        imageView.layer.cornerRadius = 12.5
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(color: EssentialColor)
    }
    
    func viewIsSelected(){
        var color:UIColor
        color = isSelected ?.white:EssentialColor
        //替换图像
        if type == .organs{
            imageView.image = UIImage(named: named!)?.withTintColor(color)
        }else{
            imageView.image = UIImage(color: color)
        }
        color = isSelected ?EssentialColor:.clear
        let height:CGFloat = isSelected ?90:76
        if isSelected{
            blurView.effect = .none
        }else{
            blurView.effect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        }
        UIView.animate(withDuration: 1.0, delay: 0, options: [.allowAnimatedContent]) {
            self.blurView.backgroundColor = color
            self.blurView.frame.size.height = height
        } completion: { flag in }
        
    }
}
