//
//  NewDetailViewController.swift
//  ScorllviewTest
//
//  Created by 陈沈杰 on 2022/4/27.
//

import UIKit
///动态详细界面
class NewDetailViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    

    //MARK: - 懒加载以及变量
    
//    private lazy var backView:UIView = {
//        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: ScreenWidth, height: 120)))
//        view.backgroundColor = SkinColor
//        let shape = CAShapeLayer()
//        shape.path = UIBezierPath(arcCenter: navBarView.center, radius: 60, startAngle: 0, endAngle: Double.pi, clockwise: true).cgPath
//        shape.fillColor = SkinColor.cgColor
//        view.layer.addSublayer(shape)
//
//        return view
//    }()
    
    private lazy var viewScrollView:UIScrollView = {
        let scrollView = UIScrollView(frame: view.frame)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self
        return scrollView
    }()
    
    
    //标题
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "七夕"
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 28)
        return label
    }()
    
    //图片张数
    private let pageNum:CGFloat = 3
    
    //滚动图
    private lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        //根据图像张数显示
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: ScreenWidth * pageNum, height: fitHeight(height: 300))
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        return scrollView
    }()
    
    //页数控制器
    private lazy var pageController:UIPageControl = {
        let page = UIPageControl()
        page.numberOfPages = Int(pageNum)
        page.currentPageIndicatorTintColor = EssentialColor
        page.pageIndicatorTintColor = GrayColor
        return page
    }()
    
    //内容
    private lazy var contentLabel:UILabel = {
        let content = UILabel()
        content.preferredMaxLayoutWidth = ScreenWidth - 2 * fitWidth(width: 20)
        content.numberOfLines = 0
        content.textAlignment = .left
        content.textColor = DeepGrayColor
        content.font = MainBodyFont
        content.text = "#七夕妆容 #国风创意\n" +
        "烟外柳丝湖外⽔，⼭眉澹碧⽉眉黄。\n" +
        "超级简单的古风妆，中国传统情人节，七夕画它再合适不过了！体验不一样的感觉。"
        return content
    }()
    
    //发布时间
    private lazy var timeLabel:UILabel = {
        let label = UILabel()
        label.textColor = DeepGrayColor
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "1小时前"
        return label
    }()
    
    //喜欢按钮
    private lazy var likeButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "like"), for: .normal)
        return button
    }()
    
    //喜欢数量
    private lazy var likeNum:UILabel = {
        let label = UILabel()
        label.textColor = DeepGrayColor
        label.font = MainBodyFont
        label.textAlignment = .left
        label.text = "123"
        return label
    }()
    
    //添加按钮
    private lazy var addButton:UIButton = {
        let button = UIButton(type: .contactAdd)
        button.tintColor = .black
        return button
    }()
    
    //分割线
    private lazy var divisionView:UIView = {
        let view = UIView()
        view.backgroundColor = GrayColor
        return view
    }()
    
    //评论数量
    private lazy var commentNumLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.text = "共25条评论"
        return label
    }()
    
    //评论区
    private lazy var commentTableView:UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.showsHorizontalScrollIndicator = false
        table.showsVerticalScrollIndicator = false
        table.dataSource = self
        table.register(CommentViewCell.self, forCellReuseIdentifier: NewDetailCommentCellID)
        table.isScrollEnabled = false
        table.backgroundColor = LightGrayColor
        table.separatorStyle = .none
        table.estimatedRowHeight = 200
        table.rowHeight = 300
        return table
    }()
    
    //底部视图
    private lazy var bottomView:DetailBottomView = {
        return DetailBottomView(frame: .zero)
    }()
    
    //ID
    private let NewDetailCommentCellID = "NewDetailCommentCellID"
    

}

//MARK: - UI
extension NewDetailViewController{
    func initView(){
        view.backgroundColor = LightGrayColor
        navBarView = NavBarView(icon: nil, nickname: "Peter")
        navBarView.delegate = self
        view.addSubview(navBarView)
        view.addSubview(viewScrollView)
        viewScrollView.addSubview(titleLabel)
        viewScrollView.addSubview(scrollView)
        viewScrollView.addSubview(pageController)
        viewScrollView.addSubview(contentLabel)
        viewScrollView.addSubview(timeLabel)
        viewScrollView.addSubview(likeButton)
        viewScrollView.addSubview(likeNum)
        viewScrollView.addSubview(addButton)
        viewScrollView.addSubview(divisionView)
        viewScrollView.addSubview(commentNumLabel)
        viewScrollView.addSubview(commentTableView)
        view.addSubview(bottomView)
        
        prepareForScrollView()
        initLayout()
        
       
        viewScrollView.layoutIfNeeded()
//        commentTableView.layoutIfNeeded()
        viewScrollView.contentSize = CGSize(width: ScreenWidth, height: divisionView.frame.maxY + ScreenHeight)
    }
    
    func initLayout(){
        viewScrollView.snp.makeConstraints { make in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(navBarView.snp.bottom)
            make.bottom.equalTo(view)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(viewScrollView).offset(fitHeight(height: 40))
            make.left.equalTo(view).offset(fitWidth(width: 20))
            make.height.equalTo(41)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(fitHeight(height: 10))
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(fitHeight(height: 300))
        }
        
        pageController.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(scrollView.snp.bottom).offset(fitHeight(height: 10))
            make.height.equalTo(10)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(pageController.snp.bottom).offset(fitHeight(height: 10))
            make.left.equalTo(view).offset(fitWidth(width: 20))
            make.right.equalTo(view).offset(-fitWidth(width: 20))
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.left.equalTo(view).offset(fitWidth(width: 20))
        }
        
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(timeLabel)
            make.right.equalTo(view).offset(-fitWidth(width: 20))
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
        
        likeNum.snp.makeConstraints { make in
            make.centerY.equalTo(timeLabel)
            make.right.equalTo(addButton.snp.left).offset(-fitWidth(width: 20))
        }
        
        likeButton.snp.makeConstraints { make in
            make.centerY.equalTo(timeLabel)
            make.right.equalTo(likeNum.snp.left).offset(-fitWidth(width: 5))
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
        
        
        
        divisionView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp_bottom).offset(fitHeight(height: 40))
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(fitHeight(height: 1))
        }
        
        commentNumLabel.snp.makeConstraints { make in
            make.left.equalTo(view).offset(fitWidth(width: 20))
            make.top.equalTo(divisionView.snp.bottom).offset(10)
        }
        
        commentTableView.snp.makeConstraints { make in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(commentNumLabel.snp.bottom).offset(fitHeight(height: 10))
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints { make in
            make.bottom.equalTo(view).offset(-45)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(60)
        }
    }
    
    //配置图片视图
    func prepareForScrollView(){
        //TODO: - 需要用实体类替换
        var itemX:CGFloat = 0
        for i in 0 ..< Int(pageNum){
            itemX = ScreenWidth * CGFloat(i) + fitWidth(width: 20)
            let imageView = UIImageView(frame: CGRect(x: itemX, y: 0, width: ScreenWidth - 2 * fitWidth(width: 20), height: fitHeight(height: 300)))
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "page\(i)")
            imageView.layer.cornerRadius = 10
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 1.0
            scrollView.addSubview(imageView)
        }
    }
}


//MARK: - ScrollViewDelegate
extension NewDetailViewController:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isEqual(viewScrollView){
            if scrollView.contentOffset.y >= divisionView.frame.maxY {
                commentTableView.isScrollEnabled = true
            }
        }else{
            let index = scrollView.contentOffset.x / ScreenWidth
            pageController.currentPage = Int(index)
        }
    }
}

//MARK: - TableViewDelegate
extension NewDetailViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewDetailCommentCellID, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
}
