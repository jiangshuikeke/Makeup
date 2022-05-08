//
//  WaterfallFlowLayout.swift
//  ScorllviewTest
//
//  Created by 陈沈杰 on 2022/4/19.
//

import UIKit

///瀑布流布局
class WaterfallFlowLayout: UICollectionViewFlowLayout {
    override init(){
        super.init()
    }
    //通过设定每一个item的属性来实现瀑布流的效果
    init(count:Int) {
        self.count = count
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    override func prepare() {
        super.prepare()
        //滚动方向为垂直
        self.scrollDirection = .vertical
        self.minimumInteritemSpacing = fitWidth(width: 15)
        self.minimumLineSpacing = fitHeight(height: 15)
        var height:(one:CGFloat,two:CGFloat) = (0,0)
        for i in 0..<count{
            //设定只有一个组
            let index = IndexPath(row: i, section: 0)

            //随机高度
//            let randHeight:CGFloat = delegate?.waterfallFlowLayout(self, heightForCellInIndexPath: index) ?? 0
            let itemHeight:CGFloat = delegate?.waterfallFlowLayout(self, heightForCellInIndexPath: index) ?? 0
            let attr = UICollectionViewLayoutAttributes(forCellWith: index)
            //哪列高度小就将item放在该列下面
            var col = 0
            if height.one <= height.two{
                height.one += itemHeight + self.minimumLineSpacing
                col = 0
            }else{
                height.two += itemHeight + self.minimumLineSpacing
                col = 1
            }
            let itemX:CGFloat = col == 0 ? fitWidth(width: 20):fitWidth(width: 20) + itemWidth + fitWidth(width: 15)
            let itemY:CGFloat = col == 0 ? height.one - itemHeight : height.two - itemHeight
            attr.frame = CGRect(x: itemX, y: itemY, width: itemWidth, height: itemHeight)
            atrributeArray.append(attr)
        }

        maxHeight = max(height.one, height.two)
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return atrributeArray
    }

    override var collectionViewContentSize: CGSize{
        return CGSize(width: ScreenWidth, height: maxHeight + fitHeight(height: 35) + StatusHeight + self.minimumLineSpacing)
    }
    
    
   
    //MARK: - 懒加载以及变量
    
    ///布局中的item数量
    private var count = 0
    
    ///布局存放每一个item的属性
    public var atrributeArray:Array<UICollectionViewLayoutAttributes> = [UICollectionViewLayoutAttributes]()
    
    let itemWidth = (ScreenWidth - 2*fitWidth(width: 20) - fitWidth(width: 15)) / 2
    
    ///item边距
    private let sectionInsets = UIEdgeInsets(top: fitHeight(height: 15), left: fitWidth(width: 20), bottom: fitHeight(height: 15), right: fitWidth(width: 20))
    
    //记录每一列当前的高度
//    private var height:(one:CGFloat,two:CGFloat) = (0,0)
    ///最大高度
    private var maxHeight:CGFloat = 0
    
    ///委托
    weak open var delegate : WaterfallFlowLayoutDelegate?
}

protocol WaterfallFlowLayoutDelegate:NSObjectProtocol{
    ///动态高度
    func waterfallFlowLayout(_ waterFlowLayout:WaterfallFlowLayout,heightForCellInIndexPath indexPath:IndexPath) -> CGFloat
}
