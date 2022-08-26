//
//  IndicatorView.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/8/10.
//

import UIKit

class IndicatorView: UIView {
   
    convenience init(title:String){
        self.init()
        frame = CGRect(x: (ScreenWidth - border) / 2, y: (ScreenHeight - border) / 2, width: border, height: border)
        titleLabel.text = title
        isHidden = true
        initView()
    }
    
    //MARK: - 懒加载以及变量
    let border:CGFloat = fitWidth(width: 144)
    private lazy var indicatorView:UIActivityIndicatorView = UIActivityIndicatorView(style:.large)

    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = MainBodyFont
        label.textColor = .white
        return label
    }()
}

//MARK: - UI
private extension IndicatorView{
    func initView(){
        layer.cornerRadius = 15.0
        layer.masksToBounds = true
        backgroundColor = DeepGrayColor
        indicatorView.color = .white
        addSubview(indicatorView)
        addSubview(titleLabel)
        initLayout()
    }
    
    func initLayout(){
        indicatorView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-fitHeight(height: 10))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(indicatorView.snp.bottom).offset(fitHeight(height: 8))
            make.centerX.equalTo(self)
        }
    }
}

extension IndicatorView{
    func startAnimating(){
        if !indicatorView.isAnimating{
            isHidden = false
            indicatorView.startAnimating()
        }
    }
    
    func stopAnimating(){
        if indicatorView.isAnimating{
            isHidden = true
            indicatorView.stopAnimating()
        }
    }
}
