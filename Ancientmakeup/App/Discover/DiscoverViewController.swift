//
//  DiscoverViewController.swift
//  ScorllviewTest
//
//  Created by 陈沈杰 on 2022/4/20.
//

import UIKit
///发现
class DiscoverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bannerView.reloadViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bannerView.stopLoop()
    }

    
    //MARK: - 懒加载以及变量
    private lazy var backgroundView:RoundedRectView = RoundedRectView(frame: CGRect(origin: .zero, size: CGSize(width: ScreenWidth, height: 100)), type: .BottomRounded, radius: 30, color: SkinColor)
    
    private lazy var searchBar:UISearchBar = {
        let search = UISearchBar()
        guard let field = search.value(forKey: "searchField") as? UITextField else{
            return search
        }
        field.backgroundColor = .clear
        search.backgroundImage = UIImage(color: .white)
        search.layer.cornerRadius = fitHeight(height: 15)
        search.layer.masksToBounds = true
        search.setImage(UIImage(named: "search"), for: .search, state: .normal)
        return search
    }()
    
    //分页管理视图
    private lazy var segmentView:SegmentView = {
        let view = SegmentView(titles: ["关注","发现"])
        view.currentIndex = 1
        return view
    }()
    
    //分页
    private lazy var horizontalScrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: 2 * ScreenWidth, height: ScreenHeight)
        return scrollView
    }()
    
    //轮播图
    private lazy var bannerView:BannerView = {
        let view = BannerView(frame: .zero)
        view.dataSoure = self
        return view
    }()
    
    //发布动态按键
    private lazy var releaseButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "release_button"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    //动态内容
//    private lazy var contentCollectionView:UICollectionView = {
//        let layout = WaterfallFlowLayout(count: 4)
//        layout.delegate = self
//
//    }（）
    
    private var images = [UIImage(named: "discover_0")]

}

//MARK: - UI
extension DiscoverViewController{
    func initView(){
        navigationController?.isNavigationBarHidden = true
        view.addSubview(backgroundView)
        view.addSubview(searchBar)
        view.addSubview(releaseButton)
        view.addSubview(segmentView)
        view.addSubview(horizontalScrollView)
        view.backgroundColor = LightGrayColor
        horizontalScrollView.addSubview(bannerView)
        navigationController?.isNavigationBarHidden = true
        initLayout()
    }
    
    func initLayout(){
        searchBar.snp.makeConstraints { make in
            make.left.equalTo(view).offset(fitWidth(width: 20))
            make.right.equalTo(view).offset(-fitWidth(width: 55))
            make.bottom.equalTo(backgroundView.snp.bottom).offset(-10)
            make.height.equalTo(fitHeight(height: 37))
        }
        
        releaseButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchBar)
            make.left.equalTo(searchBar.snp.right).offset(fitWidth(width: 16))
            make.width.height.equalTo(fitWidth(width: 20))
        }
        
        segmentView.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.bottom).offset(10)
            make.left.equalTo(fitWidth(width: 20))
            make.right.equalTo(-fitWidth(width: 20))
            make.height.equalTo(fitHeight(height: 30))
        }
        
        horizontalScrollView.snp.makeConstraints { make in
            make.top.equalTo(segmentView.snp.bottom).offset(10)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        bannerView.snp.makeConstraints { make in
            make.top.equalTo(horizontalScrollView)
            make.left.right.equalTo(view)
            make.height.equalTo(140)
        }
    }
}

//MARK: - BannerView的代理
extension DiscoverViewController:BannerViewDataSoure{
    func numberOfItems(in bannerView: BannerView) -> NSInteger {
        return 1
    }
    
    func imageForDisplay(in index: NSInteger) -> UIImage {
        return images[index]!
    }
}

extension DiscoverViewController:WaterfallFlowLayoutDelegate{
    func waterfallFlowLayout(_ waterFlowLayout: WaterfallFlowLayout, heightForCellInIndexPath indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
