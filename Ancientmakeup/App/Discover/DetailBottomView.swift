//
//  DetailBottomView.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/5.
//

import UIKit
///动态详细界面的底部视图
class DetailBottomView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var collectionImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "collection_pink")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var commentTextField:UITextField = {
        let text = UITextField()
        text.layer.masksToBounds = true
        text.layer.cornerRadius = 20
        text.backgroundColor = SkinColor
        text.attributedPlaceholder = NSAttributedString.init(string: "说点什么......", attributes: [.foregroundColor:UIColor.white,.font:MainBodyFont])
        return text
    }()

}
//MARK: - UI
extension DetailBottomView{
    func initView(){
        addSubview(collectionImageView)
        addSubview(commentTextField)
        initLayout()
        layoutIfNeeded()
        let leftView = UIView(frame:commentTextField.frame)
        leftView.frame.size = CGSize(width: 15, height: commentTextField.frame.height)
        commentTextField.leftView = leftView
        commentTextField.leftViewMode = .always
    }
    
    func initLayout(){
        collectionImageView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(fitWidth(width: 20))
            make.centerY.equalTo(self)
            make.height.equalTo(38)
            make.width.equalTo(38)
        }
        
        commentTextField.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(collectionImageView.snp.right).offset(fitWidth(width: 12))
            make.height.equalTo(35)
            make.width.equalTo(ScreenWidth - 100)
        }
    }
}
