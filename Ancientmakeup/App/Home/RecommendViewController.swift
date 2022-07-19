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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    deinit{
    
    }
    
    //MARK: - 懒加载以及变量
    private lazy var backView:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: StatusHeight + NavBarViewHeight, width: ScreenWidth, height: 10))
        view.addCurve(color: SkinColor)
        return view
    }()
    
    //内容
    private lazy var contentTableView:UITableView = {
        let view = UITableView(frame: .zero, style: .plain )
        view.showsVerticalScrollIndicator = false
        view.separatorStyle = .none
        view.register(RecommendViewCell.self, forCellReuseIdentifier: RecommendCellID)
        view.dataSource = self
        view.delegate = self
        view.estimatedRowHeight = 300
        view.tableHeaderView = RecommendHeaderView(type: .analysis)
        return view
    }()
    
    
    private let RecommendCellID = "RecommendCellID"
    
    private lazy var datas:[Makeup] = {
        var datas = [Makeup]()
        let winter = modelForMakeup()
        datas.append(winter)
        let dict = ["name":"酒晕妆","content":"24","recommendationRate":4,"figureImage":"wine"] as [String : Any]
        let other = Makeup(dict: dict)
        datas.append(other)
        return datas
    }()

}

extension RecommendViewController{
    func initView(){
        view.backgroundColor = SkinColor
        view.addSubview(backView)
        view.addSubview(contentTableView)
        view.sendSubviewToBack(contentTableView)
        initLayout()
    }
    
    func initLayout(){
        contentTableView.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.bottom)
            make.bottom.equalTo(view)
            make.left.right.equalTo(view)
        }
    }
    
    func pushViewControllerWith(makeup:Makeup){
        hiddenTabbar(isHidden: true,tag: 1)
        let detail = RecommendDetailViewController(makeup: makeup)
        navigationController?.pushViewController(detail, animated: true)
    }
}

extension RecommendViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
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
        return 300
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //跳转到详细界面
        pushViewControllerWith(makeup: datas[indexPath.item])
    }
}
