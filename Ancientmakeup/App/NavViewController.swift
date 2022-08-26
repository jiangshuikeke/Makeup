//
//  NavViewController.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/4/28.
//

import UIKit
///作为新用户的导航页
class NavViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 懒加载以及变量
    
    
    private lazy var scrollView:UIScrollView = {
        let view = UIScrollView()
        view.contentSize = CGSize(width: CGFloat(pageNum) * ScreenWidth, height: ScreenHeight - fitHeight(height: 180))
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.delegate = self
        return view
    }()
    
    ///页数
    private let pageNum = 3
    
    ///页数管理
    private lazy var pageControll : UIPageControl = {
        let page = UIPageControl()
        page.numberOfPages = pageNum
        page.currentPageIndicatorTintColor = EssentialColor
        page.pageIndicatorTintColor = .white
        return page
    }()
    
    ///跳过按钮
    private lazy var skipButton : UIButton = {
        let skip = UIButton(type: .system)
        skip.addTarget(self, action: #selector(enterApp), for: .touchUpInside)
        skip.setTitle("跳过", for: .normal)
        skip.tintColor = .white
        skip.titleLabel?.font = ButtonFont
        return skip
    }()
    
    ///next按钮
    private lazy var nextButton : UIButton = {
        let nextBt = UIButton(type: .custom)
        nextBt.setImage(UIImage(named: "right_arrow"), for: .normal)
        nextBt.layer.cornerRadius = fitWidth(width: 22)
        nextBt.layer.masksToBounds = true
        nextBt.layer.backgroundColor = LightGrayColor.cgColor
        nextBt.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        return nextBt
    }()
    
    private lazy var enterButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("开始探索", for: .normal)
        button.tintColor = .white
        button.layer.backgroundColor = EssentialColor.cgColor
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.isHidden = true
        button.addTarget(self, action: #selector(enterApp), for: .touchUpInside)
        return button
    }()
    
    private lazy var pageOne : NavView = {
        return NavView(image: UIImage(named: "page0")!, title: "中国古代化妆史话科普", content: "基于传世史料或出土文书中的记载，以古人眼光解读当时真实的妆束时尚。")
    }()
    
    private lazy var pageTwo : NavView = {
        return NavView(image: UIImage(named: "page1")!, title: "为己而容，脸型分析", content: "中华文化包罗万象，随着朝代更迭不断花样翻新，分析你的脸型，寻找最适合你的妆容朝代。")
    }()
    
    private lazy var pageThree : NavView = {
       return NavView(image: UIImage(named: "page2")!, title: "穿越千年，国风试妆教学", content: "约束与创新并行不悖，结合古代化妆手法流程，沉浸式打造国潮妆容。")
    }()
    
    
}

//MARK: - UI
extension NavViewController{
    func initView(){
        view.backgroundColor = BlackColor
        view.addSubview(scrollView)
        scrollView.addSubview(pageOne)
        scrollView.addSubview(pageTwo)
        scrollView.addSubview(pageThree)
        view.addSubview(skipButton)
        view.addSubview(nextButton)
        view.addSubview(pageControll)
        view.addSubview(enterButton)
        initScrollView()
        initLayout()
    }
    
    func initLayout(){
        scrollView.snp.makeConstraints { make in
            make.left.equalTo(view)
            make.width.equalTo(ScreenWidth)
            make.top.equalTo(view).offset(-StatusHeight)
            make.bottom.equalTo(view).offset(-fitHeight(height: 180))
        }
        
        pageControll.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom)
            make.centerX.equalTo(view)
        }
        
        skipButton.snp.makeConstraints { make in
            make.left.equalTo(view).offset(fitWidth(width: 36))
            make.bottom.equalTo(view).offset(-fitHeight(height: 45))
            make.height.equalTo(fitHeight(height: 25))
            make.width.equalTo(fitWidth(width: 35))
        }
        
        nextButton.snp.makeConstraints { make in
            make.right.equalTo(view).offset(-fitWidth(width: 36))
            make.centerY.equalTo(skipButton)
            make.height.equalTo(fitWidth(width: 45))
            make.width.equalTo(fitWidth(width: 45))
        }
        
        enterButton.snp.makeConstraints { make in
            make.left.equalTo(view).offset(fitWidth(width: 36))
            make.right.equalTo(view).offset(-fitWidth(width: 36))
            make.top.equalTo(pageControll.snp.bottom).offset(35)
            make.height.equalTo(fitHeight(height: 64))
        }
    }
    
    ///添加导航图
    func initScrollView(){
        var itemX:CGFloat = 0
        let pages:[NavView] = NSArray(array: [pageOne,pageTwo,pageThree]) as! [NavView]
        for i in 0 ..< pageNum{
            itemX = ScreenWidth * CGFloat(i)
            pages[i].frame.origin.x = itemX
        }
    }
    
    ///替换视图进入应用
    func isDisplayEnter(flag:Bool){
        enterButton.isHidden = flag
        skipButton.isHidden = !flag
        nextButton.isHidden = !flag
    }
    
}

//MARK: - Scorllview Delegate
extension NavViewController:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let index = offsetX / ScreenWidth
        if offsetX.truncatingRemainder(dividingBy: ScreenWidth) == 0{
            pageControll.currentPage = Int(index)
            let flag = Int(index) == pageNum - 1 ?false:true
            isDisplayEnter(flag: flag)
        }
    }
}

//MARK: - 按键事件
extension NavViewController{
    ///加载下一个导航页
    @objc func nextPage(){
        //获取当前偏移量
        let offsetX = scrollView.contentOffset.x
        let nextX = min(offsetX + ScreenWidth,CGFloat((pageNum - 1)) * ScreenWidth )
        scrollView.scrollRectToVisible(CGRect(x: nextX, y: 0, width: ScreenWidth, height: ScreenHeight), animated: true)
    }
    
    @objc func enterApp(){
        NotificationCenter.default.post(name: SwitchRootViewControllerNotification, object: nil)
    }
}
