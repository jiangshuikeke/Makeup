//
//  SegmentView.swift
//  ScorllviewTest
//
//  Created by 陈沈杰 on 2022/4/22.
//

import UIKit

///用来控制切换不同的视图
class SegmentView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(titles:[String]){
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: ScreenWidth - fitWidth(width: 40), height: 30)))
        self.titles = titles
        initView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureLabels()
        configureRoundedRect()
    }
    
    //MARK: - 懒加载以及变量
    
    weak open var delegate:SegmentViewDelegate?
    ///作为标题
    private lazy var titles = [String]()
    ///与标题对应的Label
    private var labels = [UILabel](){
        didSet{
            itemWidth = self.frame.width / CGFloat(labels.count)
        }
    }
    
    ///作为滑动圆角矩形块
    private lazy var roundedRect : UIView = {
        let v = UIView()
        v.layer.cornerRadius = 10
        v.center.y = self.center.y
        v.layer.masksToBounds = true
        v.backgroundColor = EssentialColor
        return v
    }()
    
    ///当前选中
    public var currentIndex:Int = 0{
        didSet{
            didSelected()
        }
    }
    
    ///每个item的间距
    private var itemEdge:CGFloat = 0
    
    ///每一个item的宽度
    private var itemWidth:CGFloat = 0
   
}

//MARK: - UI
extension SegmentView{
    func initView(){
        backgroundColor = SkinColor
        layer.cornerRadius = 10
        layer.masksToBounds = true
        addSubview(roundedRect)
        addLabels()
    }
    
    func addLabels(){
        var index = 0
        labels = [UILabel]()
        for title in titles{
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.text = title
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            label.tag = index
            index += 1
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickItem(sender:))))
            labels.append(label)
            self.addSubview(label)
        }
    }
    
    func configureLabels(){
        for (index,label) in labels.enumerated(){
            label.frame = CGRect(x: CGFloat(index) * itemWidth, y: 0, width: itemWidth, height: self.frame.height)
        }
        assert(labels.count > 0,"至少有一个标题")
        if labels.count > 1{
            itemEdge = labels[1].center.x - labels[0].center.x
        }else{
            itemEdge = labels[0].center.x
        }
        
    }
    
    ///配置滑块位置
    func configureRoundedRect(){
        let rectWidth:CGFloat = itemWidth - 2 * fitWidth(width: 2)
        let rectHeight:CGFloat = self.frame.height - 2 * fitWidth(width: 2)
        roundedRect.frame = CGRect(origin:.zero , size: CGSize(width: rectWidth, height: rectHeight))
        
        //根据当前的位置
        let currentCenter = labels[currentIndex].center
        roundedRect.center.x = currentCenter.x
        roundedRect.center.y = currentCenter.y
    }
    
    func moveRoundedRect(offset:CGFloat){
        let index = Int(offset / ScreenWidth)
        let k = itemEdge / ScreenWidth
        let x = offset * k + labels[0].center.x
        roundedRect.center.x = x
        if offset.truncatingRemainder(dividingBy: ScreenWidth) == 0{
            currentIndex = index
        }
    }
    
    func didSelected(){
        for label in labels{
            label.textColor = .black
        }
        labels[currentIndex].textColor = .white
    }
    
    @objc func clickItem(sender:Any){
        guard let gesture = sender as? UITapGestureRecognizer else {
            return
        }
        let v = gesture.view!
        delegate?.didSeleted(self, index: v.tag)
       
    }
}

protocol SegmentViewDelegate:NSObjectProtocol{
    func didSeleted(_ segment:SegmentView,index:Int)
}


