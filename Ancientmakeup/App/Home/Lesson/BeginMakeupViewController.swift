//
//  BeginMakeupViewController.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/7/4.
//

import UIKit
import AVFoundation

///开始妆容教学
class BeginMakeupViewController: BaseViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        organsCollectionView.selectItem(at: IndexPath(row: 1, section: 0), animated: true, scrollPosition: .left)
    }
    
    convenience init(makeup:Makeup){
        self.init()
        self.makeup = makeup
    }
    
    //MARK: - 懒加载以及变量
    private lazy var organsCollectionView:HorizontalCollectionView = {
        let view = HorizontalCollectionView(isLesson: true)
        view.horizontalDelegate = self
        return view
    }()
    
    private lazy var verticalView:UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
        view.frame = CGRect(x: 0, y: StatusHeight + NavBarViewHeight + 160, width: fitWidth(width: 50), height: ScreenHeight - (StatusHeight + NavBarViewHeight + 160) )
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topRight], cornerRadii: CGSize(width: 20, height: 20))
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        view.layer.mask = shape
        return view
    }()
    
    private lazy var labels = [UILabel]()
    
    private lazy var figureImageView:UIImageView = {
        let view = UIImageView(image: UIImage(named: "eyebrow_lesson"))
        view.frame = self.view.frame
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var stepView:MakeupStepView = {
        let view = MakeupStepView()
        view.isHidden = true
        return view
    }()
    
    private lazy var toolView:ToolView = {
        let view = ToolView()
        view.step = currentPart?.step
        view.isHidden = true
        return view
    }()

    private lazy var stepButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("1", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        return button
    }()
    
    private lazy var mediaView:MediaView = {
        var filePath = Bundle.main.path(forResource: "winter_lesson", ofType: "mp4")
        let view = MediaView(path: filePath!)
        view.isHidden = true
        return view
    }()
    
    
    //Datas
    private lazy var modules:[String] = {
        return ["交互教学","视频演示","工具"]
    }()
    
    private var makeup:Makeup?
    
    private var headStep:LessonStep?
    ///当前选中的Part
    private var currentPart:MakeupPart?
}

//MARK: - UI
private extension BeginMakeupViewController{
    func initView(){
        currentPart = makeup?.parts?[0]
        view.backgroundColor = SkinColor
        navBarView.title = "妆容教学"
        navBarView.titleLabel.textColor = .white
        view.addSubview(organsCollectionView)
        view.addSubview(verticalView)
        view.addSubview(figureImageView)
        view.sendSubviewToBack(figureImageView)
        view.addSubview(stepView)
        view.addSubview(toolView)
        view.addSubview(stepButton)
        view.addSubview(mediaView)
        figureImageView.image = UIImage(named: currentPart?.step?.figureImage ?? "error")
        configurationVerticalView()
        initLayout()
    }
    
    func initLayout(){
        organsCollectionView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.top.equalTo(navBarView.snp.bottom).offset(8)
            make.height.equalTo(105)
        }
    
        stepView.snp.makeConstraints { make in
            make.left.equalTo(verticalView.snp.right).offset(fitWidth(width: 35))
            make.bottom.equalTo(view).offset(-fitHeight(height: 115))
            make.height.equalTo(275)
            make.right.equalTo(view).offset(-fitWidth(width: 20))
        }
        
        stepButton.snp.makeConstraints { make in
            make.left.equalTo(stepView).offset(50)
            make.bottom.equalTo(stepView.snp.top).offset(-50)
            make.height.width.equalTo(40)
        }
        
        mediaView.snp.makeConstraints { make in
            make.left.equalTo(toolView)
            make.bottom.equalTo(view).offset(-200)
            make.height.equalTo(170)
            make.width.equalTo(265)
        }
        
        toolView.snp.makeConstraints { make in
            make.left.equalTo(verticalView.snp.right).offset(fitWidth(width: 20))
            make.bottom.equalTo(view).offset(-40)
            make.height.equalTo(170)
            make.right.equalTo(view).offset(-fitWidth(width: 20))
        }
    }
    
    func selectModule(in index:NSInteger){
        for label in labels{
            label.textColor = .white
        }
        let label = labels[index]
        label.textColor = EssentialColor
        switch index{
        case 0:
            stepView.isHidden = false
            toolView.isHidden = true
            stepButton.isHidden = false
            mediaView.isHidden = true
            break
        case 1:
            toolView.isHidden = true
            stepView.isHidden = true
            stepButton.isHidden = true
            mediaView.isHidden = false
            break
        case 2:
            stepButton.isHidden = true
            toolView.isHidden = false
            stepView.isHidden = true
            mediaView.isHidden = true
            break
        default:
            break
        }
    }
    
    ///根据当前part重新刷新UI
    func reloadViews(){
        //背景更换
        if headStep != nil,headStep?.next != nil{
            headStep = headStep!.next!
        }else{
            headStep = currentPart?.step
        }
        
        figureImageView.image = UIImage(named: headStep!.figureImage ?? "error")
        toolView.step = headStep
        stepView.step = headStep
        //修改步骤按钮
        stepButton.setTitle("\(headStep!.number + 1)", for: .normal)
    }
    
    func configurationVerticalView(){
        let moduleHeight:CGFloat = verticalView.frame.height / CGFloat(modules.count)
        
        for (index,module) in modules.enumerated(){
            //配置Label
            let itemY:CGFloat = CGFloat(index) * moduleHeight
            let label = UILabel(frame: CGRect(x: 0, y: itemY, width: verticalView.frame.width / 2 , height: moduleHeight))
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.textAlignment = .center
            label.textColor = LightGrayColor
            label.text = module
            label.center.x = verticalView.center.x
            label.tag = index
            if index == 0{
                label.textColor = EssentialColor
            }
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseModule(sender:))))
            labels.append(label)
            verticalView.contentView.addSubview(label)
        }
    }

}

//MARK: - 按键事件
private extension BeginMakeupViewController{
    @objc
    func chooseModule(sender:UITapGestureRecognizer){
        let view = sender.view
        if let index = view?.tag{
            selectModule(in: index)
        }
    }
    
    @objc
    func nextStep(){
        stepView.isHidden = false
        reloadViews()
    }
}

//MARK: - horizontalDelegate
extension BeginMakeupViewController:HorizontalCollectionViewDelegate{
    func collectionView(_ horizontalCollectionView: HorizontalCollectionView, didSelectedIn index: NSInteger) {
        headStep = nil
        if index == 1{
            currentPart = makeup?.parts?[0]
        }else{
            currentPart = makeup?.parts?[1]
        }
        reloadViews()
    }
}
