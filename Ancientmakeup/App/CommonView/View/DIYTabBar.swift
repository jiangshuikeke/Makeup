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
        //自己配置TabBarItems
        myItemWidth = frame.width / CGFloat(myItems.count)
        configureItem()
        configureRect()
    }
    
    //MARK: - 懒加载&&变量
    var myItemHeight : CGFloat{
        return frame.height - fitHeight(height: 10)
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
                layoutIfNeeded()
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
   
}

//MARK: - UI
private extension DIYTabBar{
    func initView(){
        for item in myItems {
            addSubview(item)
        }
        addSubview(roundedRect)
        sendSubviewToBack(roundedRect)
        
    }
    
    
    //配置当前圆角矩形位置
    func configureRect(){
        roundedRect.frame = CGRect(x: fitWidth(width: 5), y: fitHeight(height: 5), width:(myItemWidth! - fitWidth(width: 10)) , height: myItemHeight)
    }
    
    //配置每一个Item
    func configureItem(){
        //设置每一个Item的位置大小
        for (index,item) in myItems.enumerated(){
            let itemX = CGFloat(index) * myItemWidth!
            item.frame = CGRect(x: itemX, y:0, width: myItemWidth!, height: myItemHeight)
        }
        
    }
    //移动圆角矩形
    func moveRectToIndex(){
        let itemX = CGFloat(currentIndex) * (myItemWidth ?? 0) + fitWidth(width: 3)
        UIView.animate(withDuration: 0.5) {
            self.roundedRect.frame.origin.x = itemX
        }completion: {[weak self] flag in
            let strongSel = self
            strongSel?.myItems[strongSel?.currentIndex ?? 0].isSelected = true
        }
    }

}
