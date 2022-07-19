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
        if first{
            collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            first = false
        }
        var contentSize = contentTableView.contentSize
        contentSize.height += collectionViewMinY - navBarView.frame.maxY + fitHeight(height: 40) + StatusHeight
        contentTableView.contentSize = contentSize
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
        let view = UIScrollView(frame: CGRect(origin: .zero, size: CGSize(width: ScreenWidth, height: fitHeight(height: 320))))
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
        view.layer.cornerRadius = 150
        return view
    }()
    
    private lazy var makeupFigureImageView:UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "page2")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var contentTableView:UITableView = {
        let view = UITableView(frame: CGRect(x: 0, y: fitHeight(height: 300), width: ScreenWidth, height: ScreenHeight + navBarView.frame.height + 105), style: .plain)
        view.backgroundColor = .white
        view.drawTopCurve(color: .white)
        view.register(RecommendViewCell.self, forCellReuseIdentifier: RecommendCellID)
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        //减缓滑动速度
        view.decelerationRate = .fast
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
        
        let tang = DynastyMakeup(dict: ["name":"唐代","content":"唐五代是中国面妆史上最为繁盛的时期。在这一时期，出现了许多时髦切流行一时的面妆。主要分为红妆和胡妆。"])
        tang.makeups = [winter]
        let song = DynastyMakeup(dict: ["name":"宋代","content":"宋代妇女由于受礼教束缚颇深，总体风格较之唐代素雅、端庄，称为“薄妆”、“淡妆”、或“素妆”；但崇尚华丽、新颖之风并未减弱。","makeups":[["name":"飞霞妆","content":"","recommendationRate":4,"figureImage":"fly"]]])
        let ming = DynastyMakeup(dict: ["name":"明代"])
        let qing = DynastyMakeup(dict: ["name":"清代"])
        datas.append(tang)
        datas.append(song)
        datas.append(ming)
        datas.append(qing)
        return datas
    }()
    
    private var currentIndex:NSInteger = 0
    
    
    let TPBWCollectionViewCellID = "TPBWCollectionViewCellID"
    
    private let RecommendCellID = "RecommendCellID"
    private var first = false
}

//MARK: - UI
extension DynastyMakeupController{
    func initView(){
        first = true
        navBarView.title = "国风试妆"
        view.addSubview(topContentView)
        view.sendSubviewToBack(topContentView)
        topContentView.addSubview(blackCircleView)
        topContentView.addSubview(makeupFigureImageView)
        topContentView.addSubview(collectionView)
        view.addSubview(contentTableView)
        initLayout()
    }
    
    func initLayout(){
        blackCircleView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(fitHeight(height: 32) + NavBarViewHeight + StatusHeight)
            make.height.width.equalTo(300)
        }
        makeupFigureImageView.snp.makeConstraints { make in
            make.top.equalTo(8 + NavBarViewHeight + StatusHeight)
            make.height.equalTo(300)
            make.left.equalTo(view).offset(fitWidth(width: 20))
            make.right.equalTo(view).offset(-fitWidth(width: 20))
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(contentTableView.snp.top)
            make.height.equalTo(105)
        }
    }
    
    func backViewAlpha(alpha:CGFloat){
        blackCircleView.alpha = alpha
        makeupFigureImageView.alpha = alpha
    }
    
    func enterDetailPage(makeup:Makeup){
        let vc = RecommendDetailViewController(makeup: makeup)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DynastyMakeupController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas[currentIndex].makeups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecommendCellID, for: indexPath) as! RecommendViewCell
        cell.makeup = datas[currentIndex].makeups[indexPath.item]
        cell.selectionStyle = .none
        cell.enterDetail = { makeup in
            self.enterDetailPage(makeup: makeup)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        enterDetailPage(makeup: datas[currentIndex].makeups[indexPath.item])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        //手指下滑为正 手指上滑为负
        if offsetY > 0 && collectionViewMinY <= navBarView.frame.maxY{
            return
        }
        if offsetY < 0 && collectionViewMaxY >= collectionView.frame.maxY{
            return
        }
        //手指下滑 tableview的frame也发生变化
        contentTableView.frame.origin.y -= offsetY
        //并且上部内容也需要滚动
        topContentView.contentOffset.y += offsetY
        //MARK: - 关键代码 使得滑动更加顺畅 需要研究原因
        contentTableView.contentOffset.y = 0
        //背景图也需要改变透明度
        let rate = (collectionViewMinY - navBarView.frame.maxY) / (collectionView.frame.minY - navBarView.frame.maxY)
        backViewAlpha(alpha: rate)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        headerView.dynasty = datas[currentIndex]
        return headerView.headerHeight
    }
}

extension DynastyMakeupController:HorizontalCollectionViewDelegate{
    func collectionView(_ horizontalCollectionView: HorizontalCollectionView, didSelectedIn index: NSInteger) {
        currentIndex = index
        contentTableView.reloadData()
    }
}


