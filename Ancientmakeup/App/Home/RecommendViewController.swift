//
//  RecommendViewController.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/8.
//

import UIKit

///妆容推荐VC
class RecommendViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()
    
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
        view.tableHeaderView = RecommendHeaderView(frame: CGRect(origin: .zero, size: CGSize(width: ScreenWidth, height: fitHeight(height: 100))))
        return view
    }()
    
    
    private let RecommendCellID = "RecommendCellID"
    

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
}

extension RecommendViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecommendCellID, for: indexPath)
        //取消选中样式
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //跳转到详细界面
    }
}
