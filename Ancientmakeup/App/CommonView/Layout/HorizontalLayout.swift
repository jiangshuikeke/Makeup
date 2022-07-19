//
//  HorizontalLayout.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/6/20.
//

import UIKit

//水平单列滚动视图
class HorizontalLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        scrollDirection = .horizontal
        sectionInset = UIEdgeInsets(top: 0, left: fitWidth(width: 10), bottom: 0, right: 0)
        minimumLineSpacing = fitWidth(width: 10)
    }

}
