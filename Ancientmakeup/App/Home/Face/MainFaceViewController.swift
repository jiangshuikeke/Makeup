//
//  MainFaceViewController.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/8.
//

import UIKit
//0.判断当前的图像中存在多少人脸
//1.需要进行背景模糊
//2.进行五官的区域划分
//3.
///作为脸型分析报告的主视图
class MainFaceViewController: BaseTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        faceImageView.image = displayImage
        //1.分析人脸数量
        progressImage()
    }
    
    deinit{
        timer.invalidate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
    
    // MARK: - 懒加载以及变量
    
    //用来存储原始照片进行分析
    var figureImage:CGImage?
    //用来存储需要展示的人像照片
    var displayImage:UIImage?
    //需要修正的方向
    var orientation:CGImagePropertyOrientation?
    //是否可以分析
    private var isAnalysis:Bool = true

    //开始分析
    private lazy var myItems:[DIYTabBarItem] = {
       var data = [DIYTabBarItem]()
       let face = makeItem(title: "开始分析", image:"analyze_black", tag: 0)
        data.append(face)
       return data
    }()
    
    //分析报告 妆容推荐
    private lazy var mainItems:[DIYTabBarItem] = {
        var data = [DIYTabBarItem]()
        let report = makeItem(title: "分析报告", image: "analysis_black", tag: 1)
        let recommend = makeItem(title: "妆容推荐", image: "recommend_black", tag: 2)
        data.append(contentsOf: [report,recommend])
        return data
    }()
    
    //五官视图
    private lazy var mouthView:OrgansView = {
        return OrgansView(type: .mouth, title: "标准唇")
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
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: NavBarViewHeight), size: CGSize(width: ScreenWidth, height: ScreenHeight - NavBarViewHeight - fitHeight(height: 130))))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //向下箭头
    private lazy var downArrowImageView0:UIImageView = {
        let img = UIImageView(image: UIImage(named: "down_arrow_white")?.withTintColor(.clear))
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
    
    private var landmark:FaceLandmark?{
        didSet{
            //配置view
            eyeView.title = landmark?.eye?.name
            faceView.title = landmark?.face?.name
            eyebrowView.title = landmark?.eyebrow?.name
            mouthView.title = landmark?.mouth?.name
            noseView.title = landmark?.nose?.name
            //1.动态显示五官类型
            displayOrangsView()
            downArrowImageView0.isHidden = false
            downArrowImageView1.isHidden = false
            timer.fire()
            print(landmark?.style)
        }
    }
    
    private lazy var visionManager:VisionManager = VisionManager()
    
    private lazy var indicatorView:IndicatorView = IndicatorView(title:"分析中")
    
}

// MARK: - UI
extension MainFaceViewController{
    func initView(){
        //
        view.tag = 1
        navigationController?.isNavigationBarHidden = true
        navBarView.title = "脸型分析"
        
        view.backgroundColor = SkinColor
        diyTabBar.roundedRect.isHidden = true
        diyTabBar.myItems = myItems
        view.addSubview(downArrowImageView0)
        view.addSubview(downArrowImageView1)
        //缓冲
        view.addSubview(indicatorView)
        //添加五官
        view.addSubview(eyeView)
        view.addSubview(noseView)
        view.addSubview(eyebrowView)
        view.addSubview(mouthView)
        view.addSubview(faceView)
        view.addSubview(faceImageView)
        view.addSubview(indicatorView)
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
        
        mouthView.snp.makeConstraints { make in
            make.height.equalTo(fitHeight(height: 45))
            make.width.equalTo(fitWidth(width: 120))
            make.right.equalTo(view).offset(-fitWidth(width: 20))
            make.top.equalTo(eyebrowView.snp.bottom)
        }
        
        faceView.snp.makeConstraints { make in
            make.height.equalTo(fitHeight(height: 45))
            make.width.equalTo(fitWidth(width: 120))
            make.right.equalTo(view).offset(-fitWidth(width: 20))
            make.top.equalTo(mouthView.snp.bottom)
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
        
        mouthView.snp.updateConstraints { make in
            make.top.equalTo(eyebrowView.snp.bottom).offset(fitHeight(height: 10))
        }
        
        faceView.snp.updateConstraints { make in
            make.top.equalTo(mouthView.snp.bottom).offset(fitHeight(height: 10))
        }
        indicatorView.stopAnimating()
        
        UIView.animate(withDuration: 1.0, delay: 0, options: []) {
            self.view.layoutIfNeeded()
        } completion: { flag in
            
        }
    }
    @objc
    func downArrowAnimation(){
        if re{
            downArrowImageView1.image = UIImage(named: "down_arrow_white")
            downArrowImageView0.image = UIImage(named: "down_arrow_white")?.withTintColor(.clear)
        }else{
            downArrowImageView1.image = UIImage(named: "down_arrow_white")?.withTintColor(.clear)
            downArrowImageView0.image = UIImage(named: "down_arrow_white")
        }
        re = !re
    }
    
    //配置Controllers
    func configureViewControllers(){
        if viewControllers == nil{
            //TODO: - 图像不存在时
            let analysisVC = UINavigationController(rootViewController: AnalysisViewController(image: displayImage ?? UIImage(),landmark: landmark))
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
        mouthView.isHidden = isHidden
    }
    
    //分析人脸数量
    func progressImage(){
        let number = visionManager.numberOfFace(cgImage: figureImage!)
        //不存在人脸或者说人脸数量大于1 无法进行探测
        if number == 0 || number > 1{
            let alert = UIAlertController(errorMessage: "当前未检测到人脸或人脸数量过多")
            present(alert, animated: true)
            isAnalysis = false
        }
    }
}

//MARK: - 按键事件
extension MainFaceViewController{
    override func itemClick(sender: UITapGestureRecognizer) {
        let view = sender.view
        let tag = view?.tag
        if tag == 0{
            if isAnalysis{
                indicatorView.startAnimating()
                //2.切换tabbar内容
                diyTabBar.myItems = mainItems
                //3.进行五官的类别的分析
                //3.1 进行五官的切分
                guard let cgImage = figureImage else{
                    print("figureImage no cgImage")
                    return
                }
                landmark = visionManager.visionFaceLandmark(cgImage: cgImage, orientation: orientation)
            }
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

