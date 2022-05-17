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
    
    //MARK: - 懒加载
    private lazy var myItems : [DIYTabBarItem] = {
        var datas = [DIYTabBarItem]()
        let home = makeItem(title: "首页", image: "home", selectedImage: "home_selected", tag: 0)
        let community = makeItem(title: "社区", image: "community", selectedImage: "community_selected", tag: 1)
        let personal = makeItem(title: "个人", image: "personal", selectedImage: "personal_selected", tag: 2)
        datas.append(home)
        datas.append(community)
        datas.append(personal)
        return datas
    }()
}

//MARK: - UI
private extension MainViewController{
    func initView(){
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
        self.viewControllers = [homeVC,communityVC,personalVC]
    }
    
    
}


