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
    }

    //MARK: - 懒加载以及变量
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
        let view = UIImageView(image: UIImage(named: "chenlitaohua2"))
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
    
    private lazy var steps:[String] = {
        return ["step1","step2","step3","step5"]
    }()
    
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
        view.layoutIfNeeded()
        configurationScrollView()
    }
    
    func initLayout(){
        figureImageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        blurView.snp.makeConstraints { make in
            make.left.equalTo(view).offset(fitWidth(width: 20))
            make.right.equalTo(view).offset(-fitWidth(width: 20))
            make.top.equalTo(navBarView.snp.bottom).offset(50)
            make.bottom.equalTo(view).offset(-150)
        }
        
        pageController.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(blurView.snp.bottom).offset(20)
        }
        
        beginMakeupButton.snp.makeConstraints { make in
            make.left.equalTo(fitWidth(width: 20))
            make.right.equalTo(-fitWidth(width: 20))
            make.top.equalTo(pageController.snp.bottom).offset(7)
            make.bottom.equalTo(view).offset(-13)
        }
    }
    
    func configurationScrollView(){
        scrollView.contentSize = CGSize(width: ScreenWidth * CGFloat(steps.count), height: ScreenHeight)
        let itemY:CGFloat = 50
        let itemWidth = ScreenWidth - fitWidth(width: 50)
        let itemHeight = blurView.frame.height
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
}
