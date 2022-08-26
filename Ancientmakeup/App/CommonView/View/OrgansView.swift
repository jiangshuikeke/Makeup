//
//  OrgansView.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/9.
//

import UIKit


//五官类型
enum OrgansType {
    case eye
    case eyebrow
    case nose
    case mouth
    case face
    case adorn
}
///五官View
class OrgansView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //默认隐藏
    convenience init(type:OrgansType,title:String,isHidden:Bool = true){
        self.init(frame: CGRect(origin: .zero, size: CGSize(width: fitWidth(width: 120), height: fitHeight(height: 45))))
        self.type = type
        titleLabel.text = title
        self.isHidden = isHidden
        initView()
    }
    
    //MARK: - 懒加载以及变量
    
    //类型
    private var type:OrgansType?
    //五官视图
    private lazy var organImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.frame.size = CGSize(width: fitWidth(width: 42), height: fitWidth(width: 42))
        imageView.backgroundColor = BlackColor
        imageView.layer.cornerRadius = 21
        imageView.contentMode = .center
        return imageView
    }()
    
    //TODO: - 设置五官名称
    var title:String?{
        didSet{
            titleLabel.text = title
        }
    }
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = LittleFont
        return label
    }()
    
    private lazy var backView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0.6
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
}

//MARK: - UI
extension OrgansView{
    func initView(){
        addSubview(organImageView)
        addSubview(titleLabel)
        addSubview(backView)
        sendSubviewToBack(backView)
        initLayout()
        configureOrgansImage()
    }
    
    func initLayout(){
        organImageView.snp.makeConstraints { make in
            make.width.equalTo(fitWidth(width: 42))
            make.height.equalTo(fitWidth(width: 42))
            make.centerY.equalTo(self)
            make.left.equalTo(self)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(organImageView.snp.right).offset(-fitWidth(width: 15))
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(self)
        }
        
        backView.snp.makeConstraints { make in
            make.left.equalTo(organImageView.snp.right).offset(-fitWidth(width: 15))
            make.right.equalTo(self).offset(-fitWidth(width: 5))
            make.top.equalTo(self)
            make.height.equalTo(self)
        }
    }
    
    //根据类型配置五官图像
    func configureOrgansImage(){
        var named = ""
        switch type{
            case .none:
                break
            case .some(.face):
                named = "face_white"
            case .some(.eyebrow):
                named = "eyebrow"
            case .some(.nose):
                named = "nose"
            case .some(.mouth):
                named = "mouse"
            case .some(.eye):
                named = "eye"
            case .some(.adorn):
                named = "adorn_white"
        }
        organImageView.image = UIImage(named: named)?.withTintColor(.white)
        organImageView.padding(12)
        if type == .nose{
            organImageView.padding(left: 12, top: 8, right: 12, bottom: 8)
        }
        
    }
}
