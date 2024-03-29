//
//  BaseTabBarViewController.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/8.
//

import UIKit
import CoreMedia

class BaseTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareForTabBarController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //NOTE: - 系统自带的tabbar需要在这个方法中去移除，在使用SceneDelegate设置rootViewController的时候以下方法会调用两次，导致虽然一开始的ViewDidLoad的时候将Tabbar移除了但是第二次调用的时候tabbar依然存在。使用Storyboard设置rootViewController的时候以下方法只调用了一次，而tabbar已经被移除。
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tabBar.removeFromSuperview()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit{
        //移除通知
        NotificationCenter.default.removeObserver(self, name: PushViewControllerTabbarIsHidden, object: nil)
    }
    
    //MARK: - 懒加载以及变量
    open lazy var navBarView:NavBarView = {
        let view = NavBarView(title: nil)
        view.delegate = self
        return view
    }()
    
    //自定义Tabbar
    var diyTabBar:DIYTabBar = {
        let bar = DIYTabBar(frame: .zero)
        bar.layer.cornerRadius = 20
        bar.layer.masksToBounds = true
        return bar
    }()
    
    public lazy var bottomView:RoundedRectView = {
        return RoundedRectView(frame: CGRect(x: 0, y: ScreenHeight - BottomViewHeight, width: ScreenWidth, height: BottomViewHeight), type: .TopRounded, radius: 30, color: SkinColor)
    }()
    
    //items
    var items:[DIYTabBarItem]? {
        didSet{
            items![0].isSelected = true
        }
    }
    
}

//MARK: - UI
extension BaseTabBarController{
    
    func prepareForTabBarController(){
        //1.使用自定义Tabbar
//        tabBar.removeFromSuperview()
        //2.注册通知
        registerNotification()
        //3.
        view.addSubview(bottomView)
        view.addSubview(diyTabBar)
        view.addSubview(navBarView)
        setTabBarLayout()
       
    }
    
    func setTabBarLayout(){
        diyTabBar.snp.makeConstraints { make in
            make.left.equalTo(view).offset(fitWidth(width: 20))
            make.right.equalTo(view).offset(-fitWidth(width: 20))
            make.bottom.equalTo(view).offset(-fitHeight(height: 20))
            make.height.equalTo(DIYTabBarHeight)
        }
    }
    
    //配置每一个item
    func makeItem(title:String?,image:String,tag:Int) -> DIYTabBarItem{
        let ima = UIImage(named: image)
        let item = DIYTabBarItem(image: ima, title: title, tintColor: DeepGrayColor)
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
            if let tag = notification.userInfo?["tag"] as? NSInteger,
            let bool = notification.object as? Bool{
                if tag == self.view.tag{
                    if bool{
                        self.hideTabbar()
                    }else{
                        self.showTabbar()
                    }
                    self.navBarView.isHidden = bool
                }
            }
            
        }
    }
}

//MARK: - 私有方法处理
extension BaseTabBarController{
    //将所有的item标记为未选择
    func clearSelected(){
        for it in items!{
            it.isSelected = false
        }
    }
    
    func showTabbar(){
        diyTabBar.snp.updateConstraints { make in
            make.bottom.equalTo(view).offset(-fitHeight(height: 20))
        }
        bottomView.frame.origin.y = ScreenHeight - BottomViewHeight
        animateLayout()
    }
    
    func hideTabbar(){
        diyTabBar.snp.updateConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(DIYTabBarHeight + fitHeight(height: 20))
        }
        bottomView.frame.origin.y = ScreenHeight
        animateLayout()
    }
    
    func animateLayout(){
        UIView.animate(withDuration: 0.3, delay: 0, options: []) {
            self.view.layoutIfNeeded()
        } completion: { flag in }
    }
}

extension BaseTabBarController:NavBarViewDelegate{
    func back() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - 按键事件处理
extension BaseTabBarController{
    @objc func itemClick(sender:UITapGestureRecognizer){
        let item = sender.view as! DIYTabBarItem
        diyTabBar.currentIndex = item.tag
        clearSelected()
        self.selectedIndex = item.tag
    }
}

