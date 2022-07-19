//
//  BaseViewController.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/7.
//

import UIKit

///响应回退
class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(navBarView)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    // MARK: - 懒加载以及变量
    open lazy var navBarView:NavBarView = {
        let view = NavBarView(title: nil)
        view.delegate = self
        return view
    }()
    
}

extension BaseViewController:NavBarViewDelegate{
    @objc
    func back() {
        navigationController?.popViewController(animated: true)
    }
}
