//
//  MakeupCardView.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/6/24.
//

import UIKit

enum MoveType {
    case left
    case right
}

class MakeupCardView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 懒加载以及变量
    open weak var delegate:MakeupCardViewDelegate?
    open weak var dataSource:MakeupCardViewDataSource?
    private lazy var shadowView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hexStr: "0xD8D8D8")
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        return view
    }()
   
    open var thresholdValue:CGFloat = (ScreenWidth - fitWidth(width: 80)) / 2
    //items
    private lazy var items = [MakeupCardItem]()
    private lazy var itemDict = Dictionary<String, MakeupCardItem>()
    private var originalTransfrom:CGAffineTransform?
}

//MARK: - UI
extension MakeupCardView{
    func initView(){
        backgroundColor = .clear
    }
    
    func initLayout(){
        
    }
    
    func configureItems(){
        let number = min(numberOfItmes(), 4)
        for i in 0 ..< number{
            configureItem(index: i)
        }
        items.first?.delegate = self
    }
    
    func dequeueReusableItem(WithIdentifier identifier:String,forIndex:NSInteger) -> MakeupCardItem{
        return itemDict[identifier] ?? MakeupCardItem()
    }
    
    ///移除顶部视图
    func removeTopView(from move:MoveType){
        
    }
    
    func updateItems(item:MakeupCardItem,index:NSInteger){
        items.removeFirst()
        //末尾添加item 并且添加在view上
        items.first?.delegate = self
        configureItem(index: index,isInsert: true)
    }
    
    func configureItem(index:NSInteger,isInsert:Bool = false){
        let item = makeupItem(in: index)
        let edge = edge(in: index)
        let f = CGRect(
            x: edge.left,
            y: edge.top,
            width: frame.width - edge.left - edge.right
          , height: frame.height - edge.top - edge.bottom)
        item.frame = f
        item.index = index
        item.originalFrame = f
        if index != 0{
            item.originalOffset = -50
        }
        if isInsert{
            item.originalOffset = -50 
            sendSubviewToBack(shadowView)
        }
        insertSubview(item, at: 0)
        if index == numberOfItmes() - 1{
            shadowView.frame = CGRect(x:2 * edge.left + 10, y: 5, width: frame.width - 4 * edge.left, height: frame.height - 4 * edge.top)
            addSubview(shadowView)
            sendSubviewToBack(shadowView)
        }
        
        items.append(item)
    }
    
    func reloadData(){
        configureItems()
    }
    
    func makeupItem(in index:NSInteger) -> MakeupCardItem{
        let item = dataSource?.makeupCardView(self, itemFor: index)
        return item ?? MakeupCardItem()
    }
    
    func edge(in index:NSInteger) -> UIEdgeInsets{
        let edge = delegate?.makeupCardView(self, edgeForItemAtIndex: index)
        return edge ?? UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func numberOfItmes() -> NSInteger{
        let number = dataSource?.makeupCardViewNumberOfItems(self)
        return number ?? 0
    }

}

extension MakeupCardView:MakeupCardItemDelegate{
    func removeFromSuperViewDidEnd(item: MakeupCardItem,index:NSInteger) {
        item.removeFromSuperview()
        //添加新的View到视图中
        itemDict[item.identifier ?? ""] = item
        updateItems(item: item,index:index)
        UIView.animate(withDuration: 0.3, delay: 0, options: []) {
            self.shadowView.alpha = 1.0
        } completion: { flag in
        }
    }
    
    func makeupItem(item: MakeupCardItem, slidingValue: CGFloat) {
        let ratio = 50 * -(slidingValue / thresholdValue)
        for (index,item) in items.enumerated(){
            //处理后面的view
            if index == 0{
                continue
            }
            var temp = item.originalOffset
            temp -= ratio
            item.offset = temp
            shadowView.alpha = 1 + ratio * 0.01
        }
    }
}

protocol MakeupCardViewDelegate:NSObjectProtocol {
    ///标示item 到父视图的边界
    func makeupCardView(_ makeupCardView:MakeupCardView,edgeForItemAtIndex:NSInteger) -> UIEdgeInsets
}

protocol MakeupCardViewDataSource:NSObjectProtocol {
    func makeupCardView(_ makeupCardView:MakeupCardView,itemFor index:Int) -> MakeupCardItem
    
    func makeupCardViewNumberOfItems(_ makeupCardView:MakeupCardView) -> NSInteger
}
