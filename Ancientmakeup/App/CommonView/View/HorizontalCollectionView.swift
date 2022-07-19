//
//  HorizontalCollectionView.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/6/21.
//

import UIKit

///水平显示上图下文字的CollectionView
class HorizontalCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    convenience init(isLesson:Bool = false){
        let layout = HorizontalLayout()
        self.init(frame: .zero, collectionViewLayout: layout)
        if isLesson{
            organs.append(.adorn)
        }
        initView()
    }
    
    convenience init(datas:[String]){
        let layout = HorizontalLayout()
        self.init(frame: .zero, collectionViewLayout: layout)
        cellType = .dynasty
        self.datas = datas
        initView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 懒加载以及变量
    
    var datas = [String]()
    
    var cellType : TPBWCollectionViewCellType = .organs
    
    var isLesson:Bool = false
    
    private lazy var organs:[OragnsType] = {
        var datas = [OragnsType]()
        datas.append(.face)
        datas.append(.eyebrow)
        datas.append(.eye)
        datas.append(.mouse)
        datas.append(.nose)
        return datas
    }()
    
    weak var horizontalDelegate:HorizontalCollectionViewDelegate?
    
    let TPBWCollectionViewCellID = "TPBWCollectionViewCellID"
    
}

//MARK: - UI
extension HorizontalCollectionView{
    func initView(){
        delegate = self
        dataSource = self
        register(TPBWCollectionViewCell.self, forCellWithReuseIdentifier: TPBWCollectionViewCellID)
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
}

extension HorizontalCollectionView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if cellType == .organs{
            return organs.count
        }
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TPBWCollectionViewCellID, for: indexPath) as! TPBWCollectionViewCell
        if cellType == .organs{
            cell.type = .organs
            cell.contentType = organs[indexPath.item]
        }else{
            cell.type = .dynasty
            cell.titleLabel.text = datas[indexPath.item]
            cell.configureCircleImageView()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TPBWCollectionViewCell
        cell.isSelected = true
        //回传index
        horizontalDelegate?.collectionView(self, didSelectedIn: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: fitWidth(width: 80), height: collectionView.bounds.height)
    }
    
}

protocol HorizontalCollectionViewDelegate:NSObjectProtocol {
    func collectionView(_ horizontalCollectionView:HorizontalCollectionView,didSelectedIn index:NSInteger)
}
