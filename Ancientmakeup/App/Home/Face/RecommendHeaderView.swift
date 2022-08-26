//
//  RecommendHeaderView.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/13.
//

import UIKit

enum RecommendHeaderType{
    case analysis
    case makeup
}
///推荐妆容的头部视图
class RecommendHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(type:RecommendHeaderType) {
        if type == .analysis{
            self.init(frame: CGRect(origin: .zero, size: CGSize(width: ScreenWidth, height: fitHeight(height: 100))))
        }else{
            self.init(frame: .zero)
        }
        self.type = type
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //MARK: - 懒加载以及变量
    //固定内容标题
    private lazy var fixedTitleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .black
        label.text = "你适合的国风妆容类型是"
        return label
    }()
    
    //根据人物图像得出来的结论
    private lazy var figureFitlabel:ITButton = ITButton()
    
    private lazy var contentLable:UILabel = {
        let label = UILabel()
        label.font = MainBodyFont
        label.text = "唐五代是中国面妆史上最为繁盛的时期。在这一时期，出现了许多时髦切流行一时的面妆。主要分为红妆和胡妆。"
        label.preferredMaxLayoutWidth = ScreenWidth - fitWidth(width: 40)
        label.numberOfLines = 0
        return label
    }()
    
    private var type:RecommendHeaderType = .analysis
}

//MARK: - UI
extension RecommendHeaderView{
    func initView(){
        addSubview(fixedTitleLabel)
        addSubview(figureFitlabel)
        addSubview(contentLable)
        if type == .analysis{
            contentLable.isHidden = true
        }else{
            figureFitlabel.isHidden = true
        }
        initLayout()
    }
    
    func initLayout(){
        fixedTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(fitWidth(width: 20))
            make.top.equalTo(self).offset(fitHeight(height: 30))
        }
        
        figureFitlabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(fitWidth(width: 20))
            make.top.equalTo(fixedTitleLabel.snp.bottom).offset(fitHeight(height: 10))
        }
        
        contentLable.snp.makeConstraints { make in
            make.left.equalTo(self).offset(fitWidth(width: 20))
            make.top.equalTo(fixedTitleLabel.snp.bottom).offset(fitHeight(height: 10))
        }
    }
}

