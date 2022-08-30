//
//  TeachingViewController.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/7/4.
//

import UIKit
///妆容教学
class TeachingViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    convenience init(makeup:Makeup){
        self.init()
        self.makeup = makeup
        setStepImageName()
    }
    //MARK: - 懒加载以及变量
    public var backImageName:String?
    
    private lazy var scrollView:UIScrollView = {
        let view = UIScrollView(frame: CGRect(x: 0, y: StatusHeight + NavBarViewHeight, width: ScreenWidth, height: ScreenHeight))
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.backgroundColor = .clear
        view.delegate = self
        return view
    }()
    
    private lazy var figureImageView:UIImageView = {
        let view = UIImageView(frame: view.frame)
        return view
    }()
    
    private lazy var pageController:UIPageControl = {
        let view = UIPageControl()
        view.pageIndicatorTintColor = EssentialColor
        view.numberOfPages = steps.count
        return view
    }()
    
    private lazy var blurView:UIVisualEffectView = {
        let effect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let view = UIVisualEffectView(effect:effect)
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var beginMakeupButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("开始化妆", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.backgroundColor = EssentialColor
        button.addTarget(self, action: #selector(enterbeginMakeupPage), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var steps = [String]()
    
    private var makeup:Makeup?
}

//MARK: - UI
private extension TeachingViewController{
    func initView(){
        navBarView.title = "妆容教学"
        view.backgroundColor = SkinColor
        //背景人物图像
        view.addSubview(figureImageView)
        view.sendSubviewToBack(figureImageView)
        view.addSubview(scrollView)
        view.addSubview(pageController)
        view.addSubview(beginMakeupButton)
        scrollView.addSubview(blurView)
        initLayout()
        navBarView.configureRightButton(imageName: "home", name: nil)
        navBarView.rightButton.addTarget(self, action: #selector(backToHome), for: .touchUpInside)
        configurationScrollView()
    }
    
    func initLayout(){
        blurView.snp.makeConstraints { make in
            make.left.equalTo(view).offset(fitWidth(width: 20))
            make.right.equalTo(view).offset(-fitWidth(width: 20))
            make.top.equalTo(navBarView.snp.bottom).offset(fitHeight(height: 50))
            make.bottom.equalTo(view).offset(-fitHeight(height: 150))
        }
        
        pageController.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(blurView.snp.bottom).offset(20)
        }
        
        beginMakeupButton.snp.makeConstraints { make in
            make.left.equalTo(fitWidth(width: 20))
            make.right.equalTo(-fitWidth(width: 20))
            make.height.equalTo(fitHeight(height: 64))
            make.bottom.equalTo(view).offset(-fitHeight(height: 24))
        }
    }
    
    //获取每一个步骤的图片名
    func setStepImageName(){
        for i in 0 ..< makeup!.step{
            let makeupName = makeup!.figureImage!
            steps.append(makeupName + "_step\(i)")
        }
    }
    
    func configurationScrollView(){
        scrollView.contentSize = CGSize(width: ScreenWidth * CGFloat(steps.count), height: ScreenHeight)
        let itemY:CGFloat = 0
        let itemWidth = ScreenWidth - fitWidth(width: 50)
        let itemHeight = ScreenHeight - fitHeight(height: 150) - NavBarViewHeight
        for (index,step) in steps.enumerated(){
            let itemX = CGFloat(index) * ScreenWidth + fitWidth(width: 25)
            let imageView = UIImageView(image: UIImage(named: step))
            imageView.frame = CGRect(x: itemX, y: itemY, width: itemWidth, height: itemHeight)
            imageView.contentMode = .scaleAspectFit
            scrollView.addSubview(imageView)
        }
    }
}

//MARK: - scrollview delegate
extension TeachingViewController:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let page = offsetX / ScreenWidth
        pageController.currentPage = Int(page)
        if Int(page) == steps.count - 1{
            beginMakeupButton.isHidden = false
        }else{
            beginMakeupButton.isHidden = true
        }
    }
}

//MARK: - 按键事件
extension TeachingViewController{
    @objc
    func enterbeginMakeupPage(){
        guard let makeup = makeup else{
            return
        }
        let data = makeup.mutableCopy()
        let vc = BeginMakeupViewController(makeup: data as! Makeup)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func backToHome(){
        navigationController?.popToRootViewController(animated: true)
        hiddenTabbar(isHidden: false, tag: 0)
    }
}
