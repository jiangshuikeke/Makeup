//
//  RecommendHeaderView.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/13.
//

import UIKit

///推荐妆容的头部视图
class RecommendHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(title:String) {
        self.init(frame: CGRect(origin: .zero, size: CGSize(width: ScreenWidth, height: fitHeight(height: 100))))
        initView()
        figureFitlabel.title = title
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
}

//MARK: - UI
extension RecommendHeaderView{
    func initView(){
        addSubview(fixedTitleLabel)
        addSubview(figureFitlabel)
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
        
    }
}

