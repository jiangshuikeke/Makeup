//
//  MainViewController.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/4/15.
//

import UIKit
import SnapKit
//作为主ViewController
class MainViewController :BaseTabBarController{

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - 懒加载
    private lazy var myItems : [DIYTabBarItem] = {
        var datas = [DIYTabBarItem]()
        let home = makeItem(title: "华妆", image: "home", tag: 0)
        let community = makeItem(title: "社区", image: "community", tag: 1)
        
        let market = makeItem(title: "集市", image: "shop", tag: 2)
        let personal = makeItem(title: "个人", image: "personal", tag: 3)
        
        //TODO: - 先禁止用户点击
//        community.isUserInteractionEnabled = false
        market.isUserInteractionEnabled = false
//        personal.isUserInteractionEnabled = false
        datas.append(home)
        datas.append(community)
        datas.append(market)
        datas.append(personal)
        return datas
    }()
    
    
}

//MARK: - UI
private extension MainViewController{
    func initView(){
        view.tag = 0
        navBarView.removeFromSuperview()
        configureViewController()
        diyTabBar.myItems = myItems
        items = myItems
    }
    
    //配置VC
    func configureViewController(){
        let home = HomeViewController()
        let homeVC = UINavigationController(rootViewController: home)
        homeVC.title = "首页"
        let communityVC = UINavigationController(rootViewController: DiscoverViewController())
        communityVC.title = "社区"
        let personalVC = UINavigationController(rootViewController: PersonalViewController())
        personalVC.title = "个人"
        let marketVC = UINavigationController(rootViewController: MarketViewController())
        marketVC.title = "集市"
        self.viewControllers = [homeVC,communityVC,marketVC,personalVC]
    }
    
    
}


