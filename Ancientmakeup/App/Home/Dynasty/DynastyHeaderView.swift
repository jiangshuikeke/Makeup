//
//  DynastyHeaderView.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/7/2.
//

import UIKit

///朝代妆容头部View
class DynastyHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(){
        self.init(frame: .zero)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 变量以及懒加载
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 28)
        return label
    }()
    
    private lazy var contentLabel:UILabel = {
        let label = UILabel()
        label.font = MainBodyFont
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = ScreenWidth - fitWidth(width: 40)
        return label
    }()
    
    var headerHeight:CGFloat {
        return contentLabel.frame.maxY + 12
    }
    
    var dynasty:DynastyMakeup?{
        didSet{
            configurationView()
        }
    }

}

//MARK: - UI
extension DynastyHeaderView{
    func initView(){
        addSubview(titleLabel)
        addSubview(contentLabel)
        initLayout()
    }
    
    func initLayout(){
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(fitWidth(width: 20))
            make.top.equalTo(36)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
    }
    
    func configurationView(){
        let line = NSMutableParagraphStyle()
        line.lineSpacing = 8
        contentLabel.attributedText = NSAttributedString(string: dynasty!.content ?? "无内容", attributes: [.font : MainBodyFont,.paragraphStyle : line])
        contentLabel.sizeToFit()
        titleLabel.text = dynasty!.name
        layoutIfNeeded()
    }
}
