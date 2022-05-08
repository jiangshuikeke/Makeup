//
//  BaseTabBarViewController.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/8.
//

import UIKit

class BaseTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareForTabBarController()
    }
    
    deinit{
        //移除通知
        NotificationCenter.default.removeObserver(self, name: PushViewControllerTabbarIsHidden, object: nil)
    }
    
    //MARK: - 懒加载以及变量
    
    //自定义Tabbar
    var diyTabBar:DIYTabBar = {
        let bar = DIYTabBar(frame: .zero)
        bar.layer.cornerRadius = 20
        bar.layer.masksToBounds = true
        return bar
    }()
    
    //items
    var items:[DIYTabBarItem]? {
        didSet{
            items![0].isSelected = true
        }
    }
    
}

//MARK: - UI
extension BaseTabBarViewController{
    
    func prepareForTabBarController(){
        //1.使用自定义Tabbar
        tabBar.removeFromSuperview()
        //2.注册通知
        registerNotification()
        //3.
        view.addSubview(diyTabBar)
        initLayout()
       
    }
    
    func initLayout(){
        diyTabBar.snp.makeConstraints { make in
            make.left.equalTo(view).offset(fitWidth(width: 20))
            make.right.equalTo(view).offset(-fitWidth(width: 20))
            make.bottom.equalTo(view).offset(-fitHeight(height: 30))
            make.height.equalTo(fitHeight(height: 80))
            
        }
    }
    
    //配置每一个item
    func makeItem(title:String,image:String,selectedImage:String?   ,tag:Int) -> DIYTabBarItem{
        let ima = UIImage(named: image)
        let item = DIYTabBarItem(image: ima, title: title, selectedImage: selectedImage)
        item.isUserInteractionEnabled = true
        item.tag = tag
        let tap = UITapGestureRecognizer(target: self, action: #selector(itemClick(sender:)))
        item.addGestureRecognizer(tap)
        return item
    }
    
    func registerNotification(){
        NotificationCenter.default.addObserver(forName: PushViewControllerTabbarIsHidden, object: nil, queue: nil) { [weak self] notification in
            guard let self = self else{
                return
            }
            let bool = notification.object as! Bool
            self.diyTabBar.isHidden = bool
        }
    }
}

//MARK: - 私有方法处理
extension BaseTabBarViewController{
    //将所有的item标记为未选择
    func clearSelected(){
        for it in items!{
            it.isSelected = false
        }
    }
}

//MARK: - 按键事件处理
extension BaseTabBarViewController{
    @objc func itemClick(sender:UITapGestureRecognizer){
        let item = sender.view as! DIYTabBarItem
        diyTabBar.currentIndex = item.tag
        clearSelected()
        self.selectedIndex = item.tag
    }
}

