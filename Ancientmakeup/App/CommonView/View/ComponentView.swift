//
//  ComponentView.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/4/17.
//

import UIKit
///左图右文字组件
class ComponentView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    convenience init(image:String,title:String) {
        self.init(frame: CGRect(origin: .zero, size: CGSize(width: fitWidth(width: 165), height: fitHeight(height: 97))))
        imageView.image = UIImage(named: image)?.withTintColor(.white)
        titleLabel.text = title
        initView()
        
    }
    
    private lazy var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.frame.size = CGSize(width: fitWidth(width: 32), height: fitHeight(height: 32))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()

}

//MARK: - UI
private extension ComponentView{
    func initView(){
        backgroundColor = BlackColor
        layer.cornerRadius = 30
        layer.masksToBounds = true
        addSubview(imageView)
        addSubview(titleLabel)
        initLayout()
    }
    
    func initLayout(){
        titleLabel.sizeToFit()
        let border:CGFloat = (frame.width - imageView.frame.width - titleLabel.frame.width - fitWidth(width: 10)) / 2
        
        imageView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(fitWidth(width: 10))
            make.centerY.equalTo(self)
            make.width.equalTo(fitWidth(width: 32))
            make.height.equalTo(fitHeight(height: 32))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(border)
        }
    }
}
