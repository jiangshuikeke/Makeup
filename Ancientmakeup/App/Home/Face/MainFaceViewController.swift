//
//  MainFaceViewController.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/8.
//

import UIKit

///作为脸型分析报告的主视图
class MainFaceViewController: BaseTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        faceImageView.image = figureImage
    }
    
    deinit{
        timer.invalidate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
        
    }
    
    // MARK: - 懒加载以及变量
    
    //存储传来的图像
    var figureImage:UIImage?

    //开始分析
    private lazy var myItems:[DIYTabBarItem] = {
       var data = [DIYTabBarItem]()
       let face = makeItem(title: "开始分析", image:"analyze_black", selectedImage: nil, tag: 0)
        data.append(face)
       return data
    }()
    
    //分析报告 妆容推荐
    private lazy var mainItems:[DIYTabBarItem] = {
        var data = [DIYTabBarItem]()
        let report = makeItem(title: "分析报告", image: "analysis_black", selectedImage: "analysis_white", tag: 1)
        let recommend = makeItem(title: "妆容推荐", image: "recommend_black", selectedImage: "recommend_white", tag: 2)
        data.append(contentsOf: [report,recommend])
        return data
    }()
    
    //五官视图
    private lazy var mouseView:OrgansView = {
        return OrgansView(type: .mouse, title: "标准唇")
    }()
    
    private lazy var eyeView:OrgansView = {
        return OrgansView(type: .eye, title: "杏眼")
    }()
    
    private lazy var noseView:OrgansView = {
        return OrgansView(type: .nose, title: "标准鼻")
    }()
    
    private lazy var eyebrowView:OrgansView = {
        return OrgansView(type: .eyebrow, title: "柳叶眉")
    }()
    
    private lazy var faceView:OrgansView = {
        return OrgansView(type: .face, title: "鹅蛋脸")
    }()
    
    private lazy var faceImageView:UIImageView = {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: ScreenWidth, height: ScreenHeight)))
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    //向下箭头
    private lazy var downArrowImageView0:UIImageView = {
        let img = UIImageView(image: UIImage(named: "down_arrow_clear"))
        img.isHidden = true
        return img
    }()
    
    private lazy var downArrowImageView1:UIImageView = {
        let img = UIImageView(image: UIImage(named: "down_arrow_white"))
        img.isHidden = true
        return img
    }()
    
    private var re = false
    
    private lazy var timer:Timer = {
        let timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(downArrowAnimation), userInfo: nil, repeats: true)
        return timer
    }()
    
}

// MARK: - UI
extension MainFaceViewController{
    func initView(){
        view.tag = 1
        navigationController?.isNavigationBarHidden = true
        navBarView.title = "脸型分析"
        
        view.backgroundColor = SkinColor
        diyTabBar.roundedRect.isHidden = true
        diyTabBar.myItems = myItems
        view.addSubview(downArrowImageView0)
        view.addSubview(downArrowImageView1)
        //添加五官
        view.addSubview(eyeView)
        view.addSubview(noseView)
        view.addSubview(eyebrowView)
        view.addSubview(mouseView)
        view.addSubview(faceView)
        view.addSubview(faceImageView)
        view.sendSubviewToBack(faceImageView)
        initLayout()

    }
    
    func initLayout(){
        downArrowImageView0.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalTo(diyTabBar.snp.top).offset(-40)
        }
        
        downArrowImageView1.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(downArrowImageView0.snp.bottom).offset(-8)
        }
        
        eyeView.snp.makeConstraints { make in
            make.height.equalTo(fitHeight(height: 45))
            make.width.equalTo(fitWidth(width: 120))
            make.left.equalTo(view).offset(fitWidth(width: 20))
            make.bottom.equalTo(diyTabBar.snp.top)
        }
        
        noseView.snp.makeConstraints { make in
            make.height.equalTo(fitHeight(height: 45))
            make.width.equalTo(fitWidth(width: 120))
            make.left.equalTo(view).offset(fitWidth(width: 20))
            make.top.equalTo(eyeView.snp.bottom)
        }
        
        eyebrowView.snp.makeConstraints { make in
            make.height.equalTo(fitHeight(height: 45))
            make.width.equalTo(fitWidth(width: 120))
            make.right.equalTo(view).offset(-fitWidth(width: 20))
            make.bottom.equalTo(diyTabBar.snp.top)
        }
        
        mouseView.snp.makeConstraints { make in
            make.height.equalTo(fitHeight(height: 45))
            make.width.equalTo(fitWidth(width: 120))
            make.right.equalTo(view).offset(-fitWidth(width: 20))
            make.top.equalTo(eyebrowView.snp.bottom)
        }
        
        faceView.snp.makeConstraints { make in
            make.height.equalTo(fitHeight(height: 45))
            make.width.equalTo(fitWidth(width: 120))
            make.right.equalTo(view).offset(-fitWidth(width: 20))
            make.top.equalTo(mouseView.snp.bottom)
        }
    }
    
    //展现五官视图
    func displayOrangsView(){
        organsViewIsHidden(isHidden: false)
        
        eyeView.snp.updateConstraints { make in
            make.bottom.equalTo(diyTabBar.snp.top).offset(-fitHeight(height: 180))
        }
        
        noseView.snp.updateConstraints { make in
            make.top.equalTo(eyeView.snp.bottom).offset(fitHeight(height: 10))
        }

        eyebrowView.snp.updateConstraints { make in
            make.bottom.equalTo(diyTabBar.snp.top).offset(-fitHeight(height: 180))
        }
        
        mouseView.snp.updateConstraints { make in
            make.top.equalTo(eyebrowView.snp.bottom).offset(fitHeight(height: 10))
        }
        
        faceView.snp.updateConstraints { make in
            make.top.equalTo(mouseView.snp.bottom).offset(fitHeight(height: 10))
        }
        
        UIView.animate(withDuration: 1.0, delay: 0, options: []) {
            self.view.layoutIfNeeded()
        } completion: { flag in
            
        }
    }
    @objc
    func downArrowAnimation(){
        if re{
            downArrowImageView1.image = UIImage(named: "down_arrow_white")
            downArrowImageView0.image = UIImage(named: "down_arrow_clear")
        }else{
            downArrowImageView1.image = UIImage(named: "down_arrow_clear")
            downArrowImageView0.image = UIImage(named: "down_arrow_white")
        }
        re = !re
    }
    
    //配置Controllers
    func configureViewControllers(){
        if viewControllers == nil{
            //TODO: - 图像不存在时
            let analysisVC = UINavigationController(rootViewController: AnalysisViewController(image: figureImage ?? UIImage()))
            let recommendVC = UINavigationController(rootViewController: RecommendViewController())
            viewControllers = [analysisVC,recommendVC]
        }
    }
    
    //显示隐藏五官View
    func organsViewIsHidden(isHidden:Bool){
        eyeView.isHidden = isHidden
        noseView.isHidden = isHidden
        eyebrowView.isHidden = isHidden
        faceView.isHidden = isHidden
        mouseView.isHidden = isHidden
    }
}

//MARK: - 按键事件
extension MainFaceViewController{
    override func itemClick(sender: UITapGestureRecognizer) {
        let view = sender.view
        let tag = view?.tag
        if tag == 0{
            //1.动态显示五官类型
            displayOrangsView()
            downArrowImageView0.isHidden = false
            downArrowImageView1.isHidden = false
            timer.fire()
            
            //2.切换tabbar内容
            diyTabBar.myItems = mainItems
        }else{
            diyTabBar.roundedRect.isHidden = false
            organsViewIsHidden(isHidden: true)
            configureViewControllers()
            items = mainItems
            //3.切换Controller
            let index = tag! - 1
            diyTabBar.currentIndex = index
            clearSelected()
            self.selectedIndex = index
            //4.停止计时器
            if timer.isValid{
                timer.invalidate()
            }
            downArrowImageView0.isHidden = true
            downArrowImageView1.isHidden = true
        }
       
    }
}

//MARK：- 回退
//extension MainFaceViewController:NavBarViewDelegate{
//    func back() {
//        
//    }
//}

