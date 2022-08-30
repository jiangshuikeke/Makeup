//
//  RecommendViewController.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/8.
//

import UIKit

///妆容推荐
class RecommendViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //显示推荐妆容
        contentTableView.reloadData()
        contentTableView.drawTopCurve(height: fitHeight(height: 300) * CGFloat(cellNum) + fitHeight(height: 100) + NavBarViewHeight, color: .white)
    }
    
    //MARK: - 懒加载以及变量
    public var landmark:FaceLandmark?
    private var cellNum:NSInteger = 1
    
    //内容
    private lazy var contentTableView:UITableView = {
        let view = UITableView(frame: CGRect(x: 0, y: NavBarViewHeight, width: ScreenWidth, height: ScreenHeight - NavBarViewHeight), style: .plain )
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        view.register(RecommendViewCell.self, forCellReuseIdentifier: RecommendCellID)
        view.dataSource = self
        view.delegate = self
        view.estimatedRowHeight = 300
        return view
    }()
    
    
    private let RecommendCellID = "RecommendCellID"
    
    private lazy var datas = [Makeup]()
    private lazy var plistManager = PlistManager()

}

extension RecommendViewController{
    func initView(){
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = SkinColor
        view.addSubview(contentTableView)
        view.sendSubviewToBack(contentTableView)
        initLayout()
        processLandmark()
    }
    
    func initLayout(){
    }
    
    func pushViewControllerWith(makeup:Makeup){
        hiddenTabbar(isHidden: true,tag: 1)
        let detail = RecommendDetailViewController(makeup: makeup)
        detail.view.tag = 1
        detail.isPreHasTab = true
        navigationController?.pushViewController(detail, animated: true)
    }
    
    func processLandmark(){
        guard let landmark = landmark else{
            print("推荐妆容中的lanmark为空")
            return
        }
        //获取妆容风格
        let style = landmark.style
        let makeups = plistManager.loadMakeups(style: style)
        //根据热点进行排序
        datas = makeups.sorted{$0.recommendationRate > $1.recommendationRate}
        contentTableView.tableHeaderView = RecommendHeaderView(title: style)
    }
}

extension RecommendViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellNum = datas.count
        return cellNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecommendCellID, for: indexPath) as! RecommendViewCell
        //取消选中样式
        cell.selectionStyle = .none
        cell.makeup = datas[indexPath.item]
        cell.enterDetail = { [weak self] makeup in
            guard let self = self else{
                return
            }
            self.pushViewControllerWith(makeup: makeup)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return fitHeight(height: 290)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //跳转到详细界面
        pushViewControllerWith(makeup: datas[indexPath.item])
    }
}
