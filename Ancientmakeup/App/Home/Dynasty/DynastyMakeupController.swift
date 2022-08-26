//
//  DynastyMakeupController.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/6/21.
//

import UIKit

///国风试妆
class DynastyMakeupController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        contentTableView.drawTopCurve(by: headerView.headerHeight + fitHeight(height: 325) * CGFloat(cellNum), color: .white)
    }
    
    
    //MARK: - 懒加载以及变量
    
    //显示朝代
    private lazy var collectionView:UICollectionView = {
        let collectionView = HorizontalCollectionView(datas: dynasties)
        collectionView.horizontalDelegate = self
        return collectionView
    }()
    
    private lazy var dynasties:[String] = {
        var names = [String]()
        for dynasty in datas{
            names.append(dynasty.name ?? "无定义")
        }
        return names
    }()
    
    private lazy var topContentView:UIScrollView = {
        let view = UIScrollView(frame: CGRect(origin:.zero, size: CGSize(width: ScreenWidth, height: ScreenHeight)))
        view.backgroundColor = SkinColor
        view.isScrollEnabled = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private lazy var blackCircleView:UIView = {
        let view = UIView()
        view.backgroundColor = BlackColor
        view.layer.masksToBounds = true
        view.layer.cornerRadius = fitWidth(width: 150)
        return view
    }()
    
    private lazy var makeupFigureImageView:UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var contentTableView:UITableView = {
        let view = UITableView(frame: CGRect(x: 0, y: fitHeight(height: 290), width: ScreenWidth, height: ScreenHeight - NavBarViewHeight), style: .plain)
        view.backgroundColor = .white
        view.register(RecommendViewCell.self, forCellReuseIdentifier: RecommendCellID)
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        
        //减缓滑动速度
//        view.decelerationRate = .fast
        view.tableHeaderView = headerView
        return view
    }()

    private var collectionViewMinY:CGFloat {
        return collectionView.convert(collectionView.bounds, to: view).minY
    }
    
    private var collectionViewMaxY:CGFloat {
        return collectionView.convert(collectionView.bounds, to: view).maxY
    }
    
    private lazy var headerView:DynastyHeaderView = {
        let header = DynastyHeaderView()
        return header
    }()
    
    private lazy var datas:[DynastyMakeup] = {
        var datas = [DynastyMakeup]()
        let winter = modelForMakeup()
        if let han = PlistManager.shared.loadDynsaty(name: "汉代"),
           let tang = PlistManager.shared.loadDynsaty(name: "唐代"),
           let song = PlistManager.shared.loadDynsaty(name: "宋代"),
           let ming = PlistManager.shared.loadDynsaty(name: "明代"){
            datas.append(contentsOf: [han,tang,song,ming])
        }
        return datas
    }()
    
    //下拉的时候最大放大倍数
    private var maxScale:CGFloat = 1.3
    
    private var currentIndex:NSInteger = 0
    private var fixedCollectionViewMinY:CGFloat = 1
    
    let TPBWCollectionViewCellID = "TPBWCollectionViewCellID"
    private let DynastyHeaderViewID = "DynastyHeaderViewID"
    private let RecommendCellID = "RecommendCellID"
    private var first = false
    private var cellNum:Int = 0
}

//MARK: - UI
extension DynastyMakeupController{
    func initView(){
        isPreHasTab = true
        view.tag = 0
        first = true
        navBarView.title = "国风试妆"
        view.addSubview(topContentView)
        view.sendSubviewToBack(topContentView)
        topContentView.addSubview(blackCircleView)
        topContentView.addSubview(makeupFigureImageView)
        topContentView.addSubview(collectionView)
        view.addSubview(contentTableView)
        initLayout()
        updateHeaderView()
        makeupFigureImageView.image = UIImage(named: datas[currentIndex].image!)
        topContentView.layoutIfNeeded()
        fixedCollectionViewMinY = collectionView.frame.minY
        collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
    func initLayout(){
        blackCircleView.snp.makeConstraints { make in
            make.center.equalTo(makeupFigureImageView)
            make.height.width.equalTo(fitWidth(width: 300))
        }
        makeupFigureImageView.snp.makeConstraints { make in
            make.top.equalTo(navBarView.snp.bottom).offset(fitHeight(height: 21))
            make.height.equalTo(300)
            make.left.equalTo(view).offset(fitWidth(width: 20))
            make.right.equalTo(view).offset(-fitWidth(width: 20))
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(contentTableView.snp.top)
            make.height.equalTo(fitHeight(height: 105))
        }
    }
    
    func updateHeaderView(){
        headerView.dynasty = datas[currentIndex]
        contentTableView.sectionHeaderHeight = headerView.headerHeight
        headerView.frame.size = CGSize(width: ScreenWidth, height: headerView.headerHeight)
    }
    
    func backViewAlpha(alpha:CGFloat){
        blackCircleView.alpha = alpha
        makeupFigureImageView.alpha = alpha
    }
    
    func enterDetailPage(makeup:Makeup){
        let vc = RecommendDetailViewController(makeup: makeup)
        vc.view.tag = 0
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DynastyMakeupController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellNum = datas[currentIndex].makeups!.count
        return cellNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecommendCellID, for: indexPath) as! RecommendViewCell
        cell.makeup = datas[currentIndex].makeups![indexPath.item]
        cell.selectionStyle = .none
        cell.enterDetail = { makeup in
            self.enterDetailPage(makeup: makeup)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return fitHeight(height: 320)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        enterDetailPage(makeup: datas[currentIndex].makeups![indexPath.item])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
//        手指下滑为负 手指上滑为正
        if offsetY > 0 && collectionViewMinY <= navBarView.frame.maxY{
            return
        }

        if offsetY < 0 && collectionViewMaxY >= fitHeight(height: 300){
            //根据当前的偏移量来放大视图
            let con = contentTableView.convert(contentTableView.frame, to: view)
            let ration = (con.origin.y - contentTableView.frame.origin.y) / contentTableView.frame.origin.y
            let scale = min(ration, maxScale)

            makeupFigureImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            blackCircleView.transform = CGAffineTransform(scaleX: scale, y: scale)
            return
        }
        
        //手指下滑 tableview的frame也发生变化
        contentTableView.frame.origin.y -= offsetY
        //并且上部内容也需要滚动
        topContentView.contentOffset.y += offsetY
        //TODO: - 关键代码 使得滑动更加顺畅 需要研究原因
        contentTableView.contentOffset.y =  0
        //背景图也需要改变透明度
        let rate = (collectionViewMinY - navBarView.frame.maxY) / (fixedCollectionViewMinY - navBarView.frame.maxY)
        backViewAlpha(alpha: rate)
    }
}

extension DynastyMakeupController:HorizontalCollectionViewDelegate{
    func collectionView(_ horizontalCollectionView: HorizontalCollectionView, didSelectedIn index: NSInteger) {
        currentIndex = index
        makeupFigureImageView.image = UIImage(named: datas[currentIndex].image!)
        contentTableView.reloadData()
    }
}


