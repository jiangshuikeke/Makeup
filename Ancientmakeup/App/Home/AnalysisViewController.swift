//
//  AnalysisViewController.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/7.
//

import UIKit

///分析报告
class AnalysisViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let user = UserDefaults.standard
        guard let index = user.value(forKey: "index") as? Int else{
            organs[0].isSelected = true
            return
        }
        organs[index].isSelected = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //填充人物图像
        figureImageView.image = figureImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let user = UserDefaults.standard
        //存储当前选中
        for (index,organ) in organs.enumerated(){
            if organ.isSelected{
                user.set(index, forKey: "index")
                break
            }
        }
        
    }
    
    //MARK: - 懒加载以及变量
    
    var figureImage:UIImage?
    
    private lazy var topContentView:UIView = {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: ScreenWidth, height: fitHeight(height: 300))))
        view.backgroundColor = SkinColor
        view.addCurve(color: SkinColor)
        return view
    }()
    
    //人物图像
    private lazy var figureImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //五官滚动图
    private lazy var organsScrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var organs:[OrgansTopView] = {
        var views = [OrgansTopView]()
        views.append(OrgansTopView(type: .face))
        views.append(OrgansTopView(type: .eyebrow))
        views.append(OrgansTopView(type: .eye))
        views.append(OrgansTopView(type: .mouse))
        views.append(OrgansTopView(type: .nose))
        return views
    }()
    
    private lazy var contentScrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = LightGrayColor
        return scrollView
    }()
    
    //固定标题
    private lazy var analysisLabel:UILabel = {
        let label = UILabel()
        label.text = "你的脸型分析结果"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .black
        return label
    }()
    
    //五官名称
    private lazy var organTitleLabel:UILabel = {
        let label = UILabel()
        let view = UIView(frame: CGRect(origin: label.center, size: CGSize(width: 10, height: 10)))
        view.layer.cornerRadius = 5
        view.backgroundColor = EssentialColor
        label.addSubview(view)
        label.text = "柳叶眉"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .black
        return label
    }()
    
    //五官图像
    private lazy var organsImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "eyebrow_test")
        return imageView
    }()
    
    //五官描述
    private lazy var organsContentLabel:UILabel = {
        let label = UILabel()
        label.text = "又称秀雅眉，眉头到眉峰倾斜向上，眉峰略靠后在整条眉毛的3/4处，是最有福气的眉形之一，同时百搭任何脸型。"
        label.font = MainBodyFont
        label.textColor = DeepGrayColor
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = ScreenWidth - fitWidth(width: 36) * 2
        return label
    }()
}

extension AnalysisViewController{
    func initView(){
        view.addSubview(topContentView)
        topContentView.addSubview(organsScrollView)
        topContentView.addSubview(figureImageView)
        view.addSubview(contentScrollView)
        view.sendSubviewToBack(contentScrollView)
        contentScrollView.addSubview(analysisLabel)
        contentScrollView.addSubview(organTitleLabel)
        contentScrollView.addSubview(organsImageView)
        contentScrollView.addSubview(organsContentLabel)
        configureScrollView()
        initLayout()
        organsScrollView.layoutIfNeeded()
        organsScrollView.contentSize = CGSize(width: organs.last?.frame.maxX ?? ScreenWidth, height: 100)
        contentScrollView.layoutIfNeeded()
        contentScrollView.contentSize = CGSize(width: ScreenWidth, height: organsContentLabel.frame.maxY)
    }
    
    func initLayout(){
        organsScrollView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.top.equalTo(view).offset(fitHeight(height: 200))
            make.height.equalTo(105)
        }
        
        contentScrollView.snp.makeConstraints { make in
            make.top.equalTo(topContentView.snp.bottom)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        analysisLabel.snp.makeConstraints { make in
            make.left.equalTo(view).offset(fitWidth(width: 20))
            make.top.equalTo(contentScrollView).offset(fitHeight(height: 30))
        }
        
        organTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(analysisLabel)
            make.top.equalTo(analysisLabel.snp.bottom).offset(fitHeight(height: 8))
        }
        
        organsImageView.snp.makeConstraints { make in
            make.left.equalTo(view).offset(fitWidth(width: 32))
            make.right.equalTo(view).offset(-fitWidth(width: 32))
            make.top.equalTo(organTitleLabel.snp.bottom).offset(5)
            make.height.equalTo(fitHeight(height: 90))
        }
        
        organsContentLabel.snp.makeConstraints { make in
            make.left.right.equalTo(organsImageView)
            make.top.equalTo(organsImageView.snp.bottom).offset(10)
        }
    }
    
    //配置五官
    func configureScrollView(){
        let originOffset = fitWidth(width: 20)
        for (index,organ) in organs.enumerated(){
            let itemX:CGFloat = CGFloat(index * (72 + 15)) + originOffset
            organ.frame = CGRect(x: itemX, y:15, width: 72, height: 72)
            organ.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickOrgansView(sender:))))
            organsScrollView.addSubview(organ)
        }
    }
    
    //取消其他选中项
    func clearAllSelected(){
        for organ in organs{
            if organ.isSelected{
                organ.isSelected = false
                break
            }
        }
    }
}

//MARK: - 按键事件
extension AnalysisViewController{
    @objc func clickOrgansView(sender:UITapGestureRecognizer){
        let view = sender.view as! OrgansTopView
        if !view.isSelected{
            //1.视图样式改变
            clearAllSelected()
            view.isSelected = true
            //2.切换内容
        }
        
    }
}
