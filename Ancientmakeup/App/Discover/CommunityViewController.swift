//
//  CommunityViewController.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/3.
//

import UIKit

///社区动态显示
class CommunityViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    //MARK: - 懒加载以及变量
    
    
    //暂定轮播图
    private lazy var bannerView:BannerView = {
        let view = BannerView(frame: .zero)
        return view
    }()

}
