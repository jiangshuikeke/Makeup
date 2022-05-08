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

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    // MARK: - 懒加载以及变量
   
}

extension BaseViewController:NavBarViewDelegate{
    func back() {
        if view.tag == 0{
            navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: PushViewControllerTabbarIsHidden, object: false)
        }
        
    }
}
