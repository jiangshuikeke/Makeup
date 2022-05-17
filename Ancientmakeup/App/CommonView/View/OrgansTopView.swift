//
//  OragnsTopView.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/10.
//

import UIKit

///五官视图 上图下文字
class OrgansTopView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(type:OragnsType){
        self.init(frame: .zero)
        self.type = type
        initView()
    }
    
    //MARK: - 懒加载以及变量
    private lazy var oragnsImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = LittleFont
        label.textColor = .white
        return label
    }()
    
    private lazy var backView:UIView = {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 72, height: 72)))
        view.layer.cornerRadius = 36
        view.backgroundColor = .white
        view.alpha = 0.3
        view.layer.shadowColor = BlackColor.cgColor
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowPath = UIBezierPath(roundedRect: view.frame, cornerRadius: 36).cgPath
        view.layer.shadowOpacity = 0.5
        return view
    }()
    
    lazy var isSelected:Bool = false {
        didSet{
            //改变五官图片样式 改变背景大小
            viewIsSelected()
        }
    }
    
    //图像名字
    private var named:String?
    
    var type:OragnsType?
}

extension OrgansTopView{
    func initView(){
        addSubview(backView)
        sendSubviewToBack(backView)
        addSubview(oragnsImageView)
        addSubview(titleLabel)
        initLayout()
        configureViewByType()
    }
    
    func initLayout(){
        oragnsImageView.snp.makeConstraints { make in
            make.centerX.equalTo(backView)
            make.top.equalTo(backView).offset(15)
            make.width.equalTo(fitWidth(width: 30))
            make.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(backView)
            make.top.equalTo(oragnsImageView.snp.bottom).offset(5)
        }
    }
    
    //根据类型配置视图
    func configureViewByType(){
        var title = ""
        switch type{
        case .none:
            break
        case .some(.eyebrow):
            named = "eyebrow_pink"
            title = "眉形"
        case .some(.nose):
            named = "nose_pink"
            title = "鼻型"
        case .some(.mouse):
            named = "mouse_pink"
            title = "唇部"
        case .some(.face):
            named = "face_pink"
            title = "面部"
        case .some(.eye):
            named = "eye_pink"
            title = "眼部"
        }
        
        oragnsImageView.image = UIImage(named: named!)
        titleLabel.text = title
    }
    
    func viewIsSelected(){
        //替换图像
        let preIndex = named?.firstIndex(of: "_")
        let pre = named?[named!.startIndex ... preIndex!]
        let name = isSelected ?(pre! + "white"): (pre! + "pink")

        oragnsImageView.image = UIImage(named: String(name))
        
        let color:UIColor = isSelected ?EssentialColor:.white
        let height:CGFloat = isSelected ?100:72
        let y = isSelected ?backView.frame.origin.y - 14:backView.frame.origin.y + 14
        let alpha = isSelected ?1.0:0.3
        let radius:CGFloat = isSelected ?30:36
        UIView.animate(withDuration: 1.0, delay: 0, options: [.allowAnimatedContent]) {
            self.backView.backgroundColor = color
            self.backView.frame.size.height = height
            self.backView.frame.origin.y = y
            self.backView.alpha = alpha
            self.backView.layer.cornerRadius = radius
            
        } completion: { flag in
            self.backView.layer.shadowPath = UIBezierPath(roundedRect: self.backView.bounds, cornerRadius: radius).cgPath
        }
    }
}
