//
//  BaseScrollViewController.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/4/19.
//

import UIKit

///作为滚动ViewController基类实现下拉刷新，上拉加载更多

protocol BaseScrollViewControllerData {
    func refreshData()
    func loadMoreData()
}

class BaseScrollViewController: UIViewController {
   
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    private lazy var scrollview:UIScrollView = {
        let scrollView = UIScrollView(frame: UIScreen.main.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
}

//MARK: - UI
extension BaseScrollViewController{
    func initView(){
        initLayout()
    }
    
    func initLayout(){
        
    }
}
