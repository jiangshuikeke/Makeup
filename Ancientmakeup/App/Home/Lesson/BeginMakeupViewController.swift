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
        
    }
    
    convenience init(makeup:Makeup){
        self.init()
        self.makeup = makeup
        currentPart = makeup.parts?.first
    }
    
    //点击屏幕事件处理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nextStep()
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
        let view = UIImageView(frame: view.frame)
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
        view.addSubview(mediaView)
        configurationVerticalView()
        initLayout()
        organsCollectionView.layoutIfNeeded()
        organsCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
        selectModule(in: 0)
        navBarView.configureRightButton(imageName: "home", name: nil,imageColor: .white)
        navBarView.rightButton.addTarget(self, action: #selector(backToHome), for: .touchUpInside)
        reloadViews()
    }
    
    func initLayout(){
        organsCollectionView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.top.equalTo(navBarView.snp.bottom).offset(8)
            make.height.equalTo(105)
        }
    
        stepView.snp.makeConstraints { make in
            make.left.equalTo(verticalView.snp.right).offset(fitWidth(width: 35))
            make.bottom.equalTo(view).offset(-fitHeight(height: 88))
            make.height.equalTo(fitHeight(height: 275))
            make.right.equalTo(view).offset(-fitWidth(width: 20))
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
        stepView.isHidden = true
        toolView.isHidden = true
        mediaView.isHidden = true
        switch index{
        case 0:
            stepView.isHidden = false
            break
        case 1:
            mediaView.isHidden = false
            break
        case 2:
            toolView.isHidden = false
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
        reloadViews()
    }
    
    @objc
    func backToHome(){
        navigationController?.popToRootViewController(animated: true)
        hiddenTabbar(isHidden: false, tag: 0)
    }
}

//MARK: - horizontalDelegate
extension BeginMakeupViewController:HorizontalCollectionViewDelegate{
    func collectionView(_ horizontalCollectionView: HorizontalCollectionView, didSelectedIn index: NSInteger) {
        headStep = nil
        currentPart = makeup?.parts?[index]
        reloadViews()
    }
}
