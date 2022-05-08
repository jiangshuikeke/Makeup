//
//  MainFaceViewController.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/8.
//

import UIKit

///作为脸型分析报告的主视图
class MainFaceViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - 懒加载以及变量
    private lazy var diyTabBar : DIYTabBar = {
        let view = DIYTabBar(frame: .zero)
        return view
    }()
    
   
}

// MARK: - UI
extension MainFaceViewController{
    
}
