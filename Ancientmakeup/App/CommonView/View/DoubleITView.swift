//
//  DoubleITView.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/6/29.
//

import UIKit

///两图一标题按钮
class DoubleITView: UIView {
    convenience init(frame:CGRect,title:String,textColor:UIColor,leftImage:UIImage,rightImage:UIImage) {
        self.init(frame:frame)

        titleLabel.text = title
        titleLabel.textColor = textColor
        leftImageView.image = leftImage
        rightImageView.image = rightImage
        initView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initLayout()
    }
    
    //MARK: - 懒加载以及变量
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = ButtonFont
        return label
    }()
    
    private lazy var leftImageView:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var rightImageView:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
}

//MARK: - UI
extension DoubleITView{
    func initView(){
        addSubview(leftImageView)
        addSubview(titleLabel)
        addSubview(rightImageView)
    }
    
    func initLayout(){
        leftImageView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(25)
            make.centerY.equalTo(self)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(leftImageView.snp.right).offset(5)
            make.centerY.equalTo(self)
        }
        
        rightImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-25)
        }
    }
    
}
