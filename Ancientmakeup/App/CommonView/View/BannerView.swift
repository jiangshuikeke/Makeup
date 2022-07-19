//
//  BannerView.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/6/28.
//

import UIKit

///轮播图
class BannerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        if timer.isValid{
            timer.invalidate()
        }
    }
    
    //MARK: - 懒加载以及变量
    private lazy var scrollView:UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.delegate = self
        return view
    }()
    
    private lazy var pageController:UIPageControl = {
        let control = UIPageControl()
        control.currentPage = number / 2
        control.numberOfPages = number
        control.pageIndicatorTintColor = EssentialColor
        return control
    }()
    
    open weak var dataSoure:BannerViewDataSoure?
    
    //存放轮播
    private var items = [String]()
    
    private var imageViews = [UIImageView]()
    
    open lazy var timer:Timer = {
        let timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(loop), userInfo: nil, repeats: true)
        return timer
    }()
    
    private var number:NSInteger{
        return dataSoure?.numberOfItems(in: self) ?? 3
    }
    
    private let itemWidth:CGFloat = ScreenWidth - fitWidth(width: 40)
    
    private let itemHeight:CGFloat = 140
    
    private let itemLineSpacing:CGFloat = 20
    
    private var currentIndex:NSInteger = 1
}

//MARK: - UI
private extension BannerView{
    func initView(){
        addSubview(scrollView)
        addSubview(pageController)
        configureContentView()
        initLayout()
        startLoop()
    }
    
    func initLayout(){
        pageController.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(-8)
        }
    }
    
    func item(in index:NSInteger) -> UIImageView{
        let itemX = CGFloat(index) * ScreenWidth + itemLineSpacing
        let image = UIImageView(frame: CGRect(x: itemX, y: 0, width: itemWidth, height: itemHeight))
        image.layer.masksToBounds = true
        image.layer.cornerRadius = itemHeight / 10
        image.image = UIImage(color: UIColor().randColor)
        image.tag = index
        return image
    }
}

extension BannerView{
    @objc
    func startLoop(){
        timer.fire()
    }
    
    func stopLoop(){
        if timer.isValid{
            timer.invalidate()
        }
    }
    
    @objc
    func loop(){
        //获取当前偏移量
        scrollView.scrollRectToVisible(CGRect(x: CGFloat(currentIndex) * ScreenWidth, y: 0, width: ScreenWidth, height: itemHeight), animated: true)
        currentIndex += 1
    }
    
    func configureContentView(){
        scrollView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: itemHeight)
        var firstImageView:UIImageView
        var endImageView:UIImageView
        for i in 1 ... number{
            let imageView = item(in: i)
            if i == 1{
                firstImageView = item(in: number + 1)
                firstImageView.image = imageView.image
                scrollView.addSubview(firstImageView)
            }
            if i == number{
                endImageView = item(in: 0)
                endImageView.image = imageView.image
                scrollView.addSubview(endImageView)
            }
            imageViews.append(imageView)
            scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSize(width: CGFloat(number + 2) * ScreenWidth, height: itemHeight)
        
        //滚动到中间位置
        scrollView.contentOffset.x = ScreenWidth
    }
    
    func contentOffsetChange(by offsetX:CGFloat){
        let page = ceil(offsetX / ScreenWidth)
        pageController.currentPage = Int(page - 1)
        if page == 0{
            scrollView.contentOffset.x = offsetX + CGFloat(number) * ScreenWidth
        }else if Int(page) == number + 1{
            scrollView.contentOffset.x = offsetX - CGFloat(number) * ScreenWidth
        }
        currentIndex = Int(page)
    }

    
}

extension BannerView:UIScrollViewDelegate{
    //滚动的时候左右两边的视图需要改变大小
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentOffsetChange(by: scrollView.contentOffset.x)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentOffsetChange(by: scrollView.contentOffset.x)
    }
    
    //用户拖拽时停止轮播
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer.fireDate = Date.distantFuture
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        timer.fireDate = Date(timeIntervalSinceNow:1)
    }
}

protocol BannerViewDataSoure:NSObjectProtocol {
    func numberOfItems(in bannerView:BannerView) -> NSInteger
}

protocol BannerViewDelegate:NSObjectProtocol {
    
}
