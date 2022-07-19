//
//  MakeupCardView.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/6/23.
//

import UIKit
import CoreMedia

///小卡片
class MakeupCardItem: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    convenience init(makeup:MakeupStory,identifier:String){
        let fr = CGRect(x: 0, y: 0, width: ScreenWidth - fitWidth(width: 40), height: ScreenHeight - fitHeight(height: 260))
        self.init(frame: fr)
        self.identifier = identifier
        story = makeup
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !makeupTitleView.frame.isEmpty{
            let label = UILabel(frame: makeupTitleView.bounds)
            label.textAlignment = .center
            if nil != story{
                label.text = story?.name
            }
            label.textColor = EssentialColor
            label.font = UIFont.boldSystemFont(ofSize: 23)
            makeupTitleView.contentView.addSubview(label)
        }
    }
    
    //MARK: - 懒加载以及变量
    
    open var index:NSInteger?
    
    open weak var delegate:MakeupCardItemDelegate?
    
    ///妆容图像
    private lazy var makeupImageView:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "page0")
        return image
    }()
    
    ///妆容标题
    private lazy var makeupTitleView:UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.layer.cornerRadius = 10
        blurView.layer.masksToBounds = true
        return blurView
    }()
    
    ///妆容内容
    private lazy var makeupContentLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "「寿阳公主人日卧于含章殿檐下，梅花落公主额上，成五出花，拂之不去。皇后留之，看得几时，经三日，洗之乃落，宫女奇其异，竞效之，今梅花妆是也」\n——《太平御览》"
        label.textAlignment = .left
        label.preferredMaxLayoutWidth = ScreenWidth - 2 * fitWidth(width: 65)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.textColor = DeepGrayColor
        label.font = MainBodyFont
        return label
    }()
    
    private lazy var panGesture:UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panCardCell(sender:)))
        return gesture
    }()
    
    var originalFrame:CGRect = .zero
    //阀值 默认为item的一半 超过这个阀值了切换view
    open var thresholdValue:CGFloat = (ScreenWidth - fitWidth(width: 80)) / 2
    private var moveType:MoveType = .left
    
    private lazy var backView:UIView = {
        let view = UIView()
        view.backgroundColor = SkinColor
        view.layer.cornerRadius = 130
        view.layer.masksToBounds = true
        return view
    }()
    
    //移动时偏移量
    private var offsetX:CGFloat {
        return frame.midX - originalFrame.midX
    }
    
    private var offsetY:CGFloat {
        return frame.midY - originalFrame.midY
    }
    
    var identifier:String?
    var story:MakeupStory? {
        didSet{
            makeupImageView.image = UIImage(named: story!.image!)
            makeupContentLabel.text = story?.content
        }
    }
    
    //TODO: - 放大的逻辑需要理清
    open var originalOffset:CGFloat = 0{
        didSet{
            transform = CGAffineTransform(scaleX: 1 + originalOffset / 500, y: 1+originalOffset/500)
        }
    }
    
    open var offset:CGFloat = 0{
        didSet{
            transform = CGAffineTransform(scaleX: 1 + offset / 500, y: 1+offset / 500)
        }
    }
}

//MARK: - UI
extension MakeupCardItem{
    func initView(){
        backgroundColor = .orange
        //添加拖拽手势
        addGestureRecognizer(panGesture)
        addSubview(makeupImageView)
        addSubview(makeupTitleView)
        addSubview(makeupContentLabel)
        addSubview(backView)
        sendSubviewToBack(backView)
        initLayout()
        layer.cornerRadius = 30
        layer.masksToBounds = true
        backgroundColor = .white
    }
    
    func initLayout(){
        makeupImageView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(30)
            make.height.equalTo(fitHeight(height: 230))
            make.left.equalTo(self).offset(fitWidth(width: 34))
            make.right.equalTo(self).offset(-fitWidth(width: 34))
        }
        
        backView.snp.makeConstraints { make in
            make.center.equalTo(makeupImageView)
            make.height.width.equalTo(260)
        }
        
        makeupTitleView.snp.makeConstraints { make in
            make.top.equalTo(makeupImageView.snp.bottom).offset(-fitHeight(height: 35))
            make.height.equalTo(fitHeight(height: 45))
            make.left.equalTo(self).offset(fitWidth(width: 65))
            make.right.equalTo(self).offset(-fitWidth(width: 65))
            
        }
        
        makeupContentLabel.snp.makeConstraints { make in
            make.top.equalTo(makeupTitleView.snp.bottom).offset(fitHeight(height: 8))
            make.left.equalTo(self).offset(fitWidth(width: 36))
            make.right.equalTo(self).offset(-fitWidth(width: 36))
            make.bottom.equalTo(self).offset(-fitHeight(height: 8))
        }
    }
    
    ///判断item位置是否越界
    func isItemBreakBounds() -> Bool{
       
        if abs(offsetX) > thresholdValue || abs(offsetY) > thresholdValue{
            //判断移动方向
            if frame.midX - originalFrame.midX < 0{
                moveType = .left
            }else{
                moveType = .right
            }
            return true
        }
        return false
    }
    
    ///从父视图中移除
    func removeItem(){
        var nowFrame:CGRect = frame
        if moveType == .left{
            nowFrame.origin.x = -ScreenWidth
        }else{
            nowFrame.origin.x = ScreenWidth
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: []) {
            self.frame = nowFrame
        } completion: { flag in
            //通知主视图子控件移除
            self.delegate?.removeFromSuperViewDidEnd(item: self,index: self.index ?? 0)
        }
    }
    
    ///获取当前偏移量用来改变下一个item的大小
    private var slidingValue:CGFloat {
        //获取最大偏移量
        let res = max(abs(offsetX),abs(offsetY))
        //最大返回阈值
        return min(res,thresholdValue)
    }
}

//MARK: - gesture
extension MakeupCardItem{
    @objc
    func panCardCell(sender:UIPanGestureRecognizer){
        
        let offsetX = sender.translation(in: self.superview).x
        let offsetY = sender.translation(in: self.superview).y
        if sender.state == .changed{
            let view = sender.view!
            view.center = CGPoint(x: view.center.x + offsetX, y: view.center.y + offsetY )
            sender.setTranslation(.zero, in: self)
            delegate?.makeupItem(item: self, slidingValue: slidingValue)
        }else if sender.state == .ended{
            //是否越界
            if isItemBreakBounds(){
                //越界移除
                removeItem()
            }else{
                //回归原位
                UIView.animate(withDuration: 0.3, delay: 0, options: []) {
                    self.frame = self.originalFrame
                } completion: { flag in }
            }
        }
    }
}

protocol MakeupCardItemDelegate:NSObjectProtocol {
    func makeupItem(item:MakeupCardItem,slidingValue:CGFloat)
    func removeFromSuperViewDidEnd(item:MakeupCardItem,index:NSInteger)
}
