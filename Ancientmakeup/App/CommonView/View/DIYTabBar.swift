//
//  DIYTabBar.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/4/15.
//

import UIKit

class DIYTabBar: UITabBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
    
    //MARK: - 懒加载&&变量
    var myItemHeight : CGFloat{
        return frame.height - 6
    }
    var myItemWidth : CGFloat?
    
    var roundedRect : UIView = {
        let view = UIView()
        view.backgroundColor = EssentialColor
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    var myItems : [DIYTabBarItem] = [DIYTabBarItem]()
    {
//        设置items后进行布局
        didSet{
            if myItems.count > 0{
                initView()
            }
        }
    }
    
    
    //当前的位置 默认为0
    var currentIndex : Int = 0{
        didSet{
            //移动矩形位置
            moveRectToIndex()
        }
    }
    
    private lazy var blurView:UIVisualEffectView = {
        let view = self.blurView(radius: 20)
        return view
    }()
   
}

//MARK: - UI
private extension DIYTabBar{
    func initView(){
        //移除所有items
        for sub in subviews{
            if sub.isKind(of: DIYTabBarItem.self){
                sub.removeFromSuperview()
            }
        }
        addSubview(roundedRect)
        sendSubviewToBack(roundedRect)
        layoutIfNeeded()
        //自己配置TabBarItems
        myItemWidth = frame.width / CGFloat(myItems.count)
        configureItem()
        configureRect()
    }
    
    
    //配置当前圆角矩形位置
    func configureRect(){
        roundedRect.frame = CGRect(x: fitWidth(width: 5), y: 3, width:(myItemWidth! - fitWidth(width: 10)) , height: myItemHeight)
    }
    
    //配置每一个Item
    func configureItem(){
        //设置每一个Item的位置大小
        for (index,item) in myItems.enumerated(){
            let itemX = CGFloat(index) * myItemWidth!
            item.frame = CGRect(x: itemX, y:0, width: myItemWidth!, height: myItemHeight)
            addSubview(item)
        }
        
    }
    //移动圆角矩形
    func moveRectToIndex(){
        let itemX = CGFloat(currentIndex) * (myItemWidth ?? 0) + 5
        UIView.animate(withDuration: 0.5) {
            self.roundedRect.frame.origin.x = itemX
        }completion: {[weak self] flag in
            guard let self = self else{
                return
            }
            self.myItems[self.currentIndex].isSelected = true
        }
    }

}
