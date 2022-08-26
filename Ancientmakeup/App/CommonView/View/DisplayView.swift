//
//  DisplayView.swift
//  ScorllviewTest
//
//  Created by 陈沈杰 on 2022/4/22.
//

import UIKit

///粉丝个数显示组件
class DisplayView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title:String,number:String) {
        self.init(frame: CGRect(origin: .zero, size: CGSize(width: 145, height: 74)))
        titleLabel.text = title
        numberLabel.text = number
        initView()
    }
    
    //MARK: - 懒加载以及变量
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var numberLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
}

//MARK: - UI
extension DisplayView{
    func initView(){
        layer.cornerRadius = 20
        layer.masksToBounds = true
        backgroundColor = BlackColor
        
        addSubview(titleLabel)
        addSubview(numberLabel)
        initLayout()
    }
    
    func initLayout(){
        numberLabel.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.top.equalTo(self).offset(13)
//            make.height.equalTo(fitHeight(height: 23))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(5)
            make.left.equalTo(self)
            make.right.equalTo(self)
//            make.height.equalTo(fitHeight(height: 23))
        }
    }
}
