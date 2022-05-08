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
        self.init(frame: CGRect(origin: .zero, size: CGSize(width: fitWidth(width: 164), height: fitHeight(height: 68))))
        imageView.image = UIImage(named: image)
        titleLabel.text = title
        initView()
        
    }
    
    private lazy var imageView:UIImageView = {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: fitWidth(width: 23), height: fitHeight(height: 23))))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: fitWidth(width: 75), height: fitHeight(height: 25))))
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()

}

//MARK: - UI
private extension ComponentView{
    func initView(){
        backgroundColor = BlackColor
        layer.cornerRadius = 20
        layer.masksToBounds = true
        addSubview(imageView)
        addSubview(titleLabel)
        initLayout()
    }
    
    func initLayout(){
        let border:CGFloat = (frame.width - imageView.frame.width - titleLabel.frame.width - fitWidth(width: 3)) / 2
        imageView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(border)
            make.centerY.equalTo(self)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(imageView.snp.right).offset(fitWidth(width: 3))
        }
    }
}
