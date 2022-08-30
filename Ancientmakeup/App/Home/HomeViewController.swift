//
//  HomeViewController.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/4/16.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        hiddenTabbar(isHidden: false,tag: 0)
    }
    
    
    //MARK: -懒加载变量
    
    ///背景视图
    private lazy var roundedRect : RoundedRectView = {
        return RoundedRectView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: fitHeight(height: 160)),type: .BottomRounded,radius: 30,color: SkinColor)
        
    }()
    
    ///欢迎文案
    private lazy var helloLabel:UILabel = {
        //20,105
       let label = UILabel(frame: CGRect(x: 0, y: 0, width: fitWidth(width: 330), height: fitHeight(height: 41)))
        label.font = UIFont.boldSystemFont(ofSize: 34)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    ///功能组件
    private lazy var faceComponent : ComponentView = {
        let view = ComponentView(image: "face", title: "脸型分析")
        view.tag = 0
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickComponentView(sender:))))
        return view
    }()
    
    private lazy var nationalComponent : ComponentView = {
        let view = ComponentView(image: "national", title: "国风试妆")
        view.backgroundColor = EssentialColor
        view.tag = 1
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickComponentView(sender:))))
        return view
    }()
    
    private lazy var cardView:MakeupCardView = {
        let view = MakeupCardView(frame: .zero)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private lazy var iconImageView:UIImageView = {
        let view = UIImageView(image: UIImage(named: "icon"))
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 22
        view.layer.masksToBounds = true
        view.backgroundColor = BlackColor
        return view
    }()
    
    
    ///data
    private lazy var storys:[MakeupStory] = {
        var datas = [MakeupStory]()
        let winter = MakeupStory(dict: ["name":"梅花妆","content":"「寿阳公主人日卧于含章殿檐下，梅花落公主额上，成五出花，拂之不去。……宫女奇其异，竞效之，今梅花妆是也」","image":"page1"])
        let fly = MakeupStory(dict: ["name":"飞霞妆","content":"「美人妆，面既施粉，复以燕支晕掌中，施之两颊，浓者为酒晕妆，浅者为桃花妆，薄薄施朱，以粉罩之，为飞霞妆」","image":"page0"])
        let white = MakeupStory(dict: ["name":"白妆","content":"单以白粉涂敷面颊，不施胭脂，也叫玉颜。这如玉一般的素洁颜容之美，代表美好品德的玉的光润莹洁和肤色融合在一起。","image":"page2"])
        let flower = MakeupStory(dict: ["name":"花钿","content":"花钿是古时汉族妇女脸上的一种花饰，即用金翠珠宝制成的花形首饰。花钿有红、绿、黄三种颜色，以红色为最多，以金、银等制成花形，蔽于脸上，是唐代比较流行的一种首饰。","image":"page3"])
        datas.append(winter)
        datas.append(fly)
        datas.append(white)
        datas.append(flower)
        return datas
    }()
    
    private let MakeupCardCellID = "MakeupCardCellID"
}

//MARK: - UI
private extension HomeViewController{
    func initView(){
        navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = LightGrayColor
//        view.addSubview(iconImageView)
        view.addSubview(roundedRect)
        //背景以及欢迎
        view.sendSubviewToBack(roundedRect)
        view.addSubview(helloLabel)
        //功能组件UI
        view.addSubview(faceComponent)
        view.addSubview(nationalComponent)
        //妆容部分UI
        view.addSubview(cardView)
        
//        view.addSubview(bottomView)
        
        countNowQuantum()
        initLayout()
        cardView.layoutIfNeeded()
        cardView.reloadData()
    }
    
    func initLayout(){
        let offset:CGFloat = faceComponent.frame.height / 2
//        let border:CGFloat = (ScreenWidth - 2 * faceComponent.frame.width - fitWidth(width: 5)) / 2
        
//        iconImageView.snp.makeConstraints { make in
//            make.left.equalTo(helloLabel)
//            make.top.equalTo(view).offset(StatusHeight)
//            make.height.width.equalTo(fitHeight(height: 44))
//        }
        
        helloLabel.snp.makeConstraints { make in
            make.left.equalTo(view).offset(fitWidth(width: 20))
            make.right.equalTo(-fitWidth(width: 20))
            make.bottom.equalTo(faceComponent.snp.top).offset(-15)
        }
        
        faceComponent.snp.makeConstraints { make in
            make.width.equalTo(fitWidth(width: 165))
            make.height.equalTo(fitHeight(height: 97))
            make.top.equalTo(roundedRect.snp.bottom).offset(-offset)
            make.left.equalTo(view).offset(fitWidth(width: 20))
        }
        nationalComponent.snp.makeConstraints { make in
            make.width.equalTo(fitWidth(width: 165))
            make.height.equalTo(fitHeight(height: 97))
            make.left.equalTo(faceComponent.snp.right).offset(fitWidth(width: 5))
            make.top.equalTo(faceComponent)
        }
        
        cardView.snp.makeConstraints { make in
            make.left.equalTo(view).offset(fitWidth(width: 20))
            make.right.equalTo(view).offset(-fitWidth(width: 20))
            make.top.equalTo(nationalComponent.snp.bottom).offset(fitHeight(height: 8))
            make.bottom.equalTo(view).offset(-fitHeight(height: 20) - DIYTabBarHeight)
        }
    
    }
    
    ///计算当前的时间段
    func countNowQuantum(){
        //凌晨：0时至5时；早晨：5时至8时；上午：8时至11时；中午：11时至13时；下午：13时至16时；傍晚：16时至19时；晚上：19时至24时。
        helloLabel.text = Date.currentQuantum
    }
}

//MARK: - 自定义Delegate
extension HomeViewController:MakeupCardViewDelegate,MakeupCardViewDataSource{
    func makeupCardViewNumberOfItems(_ makeupCardView: MakeupCardView) -> NSInteger {
        return storys.count
    }
    
    func makeupCardView(_ makeupCardView: MakeupCardView, itemFor index: Int) -> MakeupCardItem {
        let item = MakeupCardItem(frame: .zero)
        item.story = storys[index]
        return item
    }
    
    func makeupCardView(_ makeupCardView: MakeupCardView, edgeForItemAtIndex: NSInteger) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
}

//按键事件
extension HomeViewController{
    @objc func clickComponentView(sender:UITapGestureRecognizer){
        let view = sender.view
        //切换到不同的界面
        hiddenTabbar(isHidden: true,tag: 0)
        if view?.tag == 0 {
            navigationController?.pushViewController(FaceAnalyzeViewController(), animated: true)
        }else{
            navigationController?.pushViewController(DynastyMakeupController(), animated: true)
        }
    }
}
