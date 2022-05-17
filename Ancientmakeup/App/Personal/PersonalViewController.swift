//
//  PersonalViewController.swift
//  ScorllviewTest
//
//  Created by 陈沈杰 on 2022/4/20.
//

import UIKit

/*
 TODO: - 内容的高度不适配的原因在于：
 一开始的进行瀑布流高度设置的时候高度随机了一次，并且进行了存储
 在CollectionView返回Cell的时候高度又随机了一次，但是应用的是第一次随机出来的高度
 解决方法：
 高度并不是一个随机值而是一个根据宽度等比例缩放的数值
 需要有一个实体类去存储数据使得高度也可以被存储
 */

class PersonalViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: ScreenWidth, height:ScreenHeight +  segmentView.frame.maxY)
    }
    
    deinit
    {
        removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            //根据collectionView的偏移量来移动scrollView
        let point = change?[.newKey] as! CGPoint
        let offset = point.y
        if offset < 0 {
                collectionView.isScrollEnabled = false
        }
            
}
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    //MARK: - 懒加载以及变量
    private lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView(frame: view.frame)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var horizontalScrollView:UIScrollView = {
        let scrollView = UIScrollView(frame: view.frame)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: ScreenWidth * CGFloat(pageNum), height: ScreenHeight)
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var headerView:PersonalHeaderView = {
        return PersonalHeaderView(frame: .zero)
    }()
    
    private lazy var collectionView:UICollectionView = {
        let layout = WaterfallFlowLayout(count: count)
        layout.delegate = self
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = LightGrayColor
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: NewsCollectionViewCellId)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private lazy var segmentView:SegmentView = {
        let view = SegmentView(titles: ["关注","发现","个人"])
        view.currentIndex = 0
        view.delegate = self
        return view
    }()
    
    ///是否悬停
    private var isHover = false
    ///页面数量
    private var pageNum = 3
    ///Cell ID
    private let NewsCollectionViewCellId = "NewsCollectionViewCellId"
    ///item 个数
    private let count = 5
    
    ///存储Cell信息
    private var items:[NewsCollectionViewCell] = [NewsCollectionViewCell]()

    
}

//MARK: - UI
extension PersonalViewController{
    func initView(){
        navigationController?.isNavigationBarHidden = true
        scrollView.backgroundColor = LightGrayColor
        view.addSubview(scrollView)
        scrollView.addSubview(headerView)
        scrollView.addSubview(segmentView)
        scrollView.addSubview(horizontalScrollView)
        horizontalScrollView.addSubview(collectionView)
        headerView.sizeToFit()
        prepareForCollectionView()
        initLayout()
    }
    
    func initLayout(){
        segmentView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(fitHeight(height: 13))
            make.left.equalTo(view).offset(fitWidth(width: 20))
            make.right.equalTo(view).offset(-fitWidth(width: 20))
            make.height.equalTo(fitHeight(height: 35))
        }
        horizontalScrollView.snp.makeConstraints { make in
            make.left.equalTo(view)
            make.top.equalTo(segmentView.snp.bottom)
            make.height.equalTo(ScreenHeight)
            make.width.equalTo(ScreenWidth)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(horizontalScrollView)
            make.top.equalTo(horizontalScrollView)
            make.height.equalTo(view.frame.height - fitHeight(height: 90))
            make.width.equalTo(ScreenWidth)
        }
       
    }
    
    func prepareForCollectionView(){
        collectionView.addObserver(self, forKeyPath: "contentOffset", options: [NSKeyValueObservingOptions.new], context: nil)
    }
}

//MARK: - collectionViewDelegate
extension PersonalViewController:UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //TODO: - 需要根据内容去调节
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCellId, for: indexPath)
//        let cell = items[indexPath.row]
        cell.layer.cornerRadius = 10
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: 10).cgPath
        cell.layer.shadowColor = LightBlackColor.cgColor
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowOffset = CGSize(width: 2, height: 2)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //跳转到详细界面
        hiddenTabbar(by: true)
        navigationController?.pushViewController(NewDetailViewController(), animated: true)
    }

}

//MARK: - ScrollViewDelegate
extension PersonalViewController:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let offset = scrollView.contentOffset
        
        if scrollView.isEqual(horizontalScrollView){
            let offsetX = scrollView.contentOffset.x
            segmentView.moveRoundedRect(offset: offsetX)
            return
        }
        
        if offset.y >= headerView.frame.maxY - fitHeight(height: 5){
            if !isHover{
                segmentView.snp.remakeConstraints { make in
                    make.top.equalTo(view).offset(StatusHeight)
                    make.left.equalTo(view).offset(fitWidth(width: 20))
                    make.right.equalTo(view).offset(-fitWidth(width: 20))
                    make.height.equalTo(fitHeight(height: 35))
                }
                isHover = true
            }
           
            collectionView.isScrollEnabled = true
        }else{
            if isHover{
                segmentView.snp.remakeConstraints { make in
                    make.top.equalTo(headerView.snp.bottom).offset(fitHeight(height: 13))
                    make.left.equalTo(view).offset(fitWidth(width: 20))
                    make.right.equalTo(view).offset(-fitWidth(width: 20))
                    make.height.equalTo(fitHeight(height: 35))
                }
                isHover = false
            }
            
            collectionView.isScrollEnabled = false
        }
        
    }
    
   
}

//MARK: - SegmentDelegate
extension PersonalViewController:SegmentViewDelegate{
    func didSeleted(_ segment: SegmentView, index: Int) {
        //滚动视图
        horizontalScrollView.scrollRectToVisible(CGRect(x: CGFloat(index)*ScreenWidth, y: 0, width: ScreenWidth, height: ScreenHeight), animated: true)
    }
}

//MARK: - WaterfallFlowLayoutDelegate
extension PersonalViewController:WaterfallFlowLayoutDelegate{
    func waterfallFlowLayout(_ waterFlowLayout: WaterfallFlowLayout, heightForCellInIndexPath indexPath: IndexPath) -> CGFloat {
        let cell = NewsCollectionViewCell(frame: CGRect(origin: .zero, size: CGSize(width: fitWidth(width: 160), height: 0)))
        items.append(cell)
        
        
        return items[indexPath.row].cellHeight
    }
}
