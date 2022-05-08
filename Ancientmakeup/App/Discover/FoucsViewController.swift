//
//  FoucsViewController.swift
//  ScorllviewTest
//
//  Created by 陈沈杰 on 2022/4/27.
//

import UIKit
///我的关注界面
class FoucsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - 懒加载以及变量
    
    private lazy var collectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: WaterfallFlowLayout(count: 10))
        return view
    }()
}

