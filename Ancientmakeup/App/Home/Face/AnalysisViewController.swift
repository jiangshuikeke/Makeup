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
    
    convenience init(image:UIImage){
        self.init()
        figureImageView.image = image
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //填充人物图像        
        if first{
            collectionView.selectItem(at: IndexPath(item: 1, section: 0), animated: true, scrollPosition: .left)
            first = false
        }
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK: - 懒加载以及变量
    
    var figureImage:UIImage?
    
    private lazy var topContentView:UIScrollView = {
        let view = UIScrollView(frame: CGRect(origin: .zero, size: CGSize(width: ScreenWidth, height: fitHeight(height: 300))))
        view.backgroundColor = SkinColor
        view.isScrollEnabled = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    //人物图像
    private lazy var figureImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
        
    //使用tableview展现五官
    private lazy var collectionView:HorizontalCollectionView = {
        return HorizontalCollectionView(isLesson: false)
    }()
    
    private lazy var contentScrollView:UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: fitHeight(height: 280), width: ScreenWidth, height: ScreenHeight))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = LightGrayColor
        scrollView.drawTopCurve(color: .white)
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
    private lazy var organTitleLabel:ITButton = {
        return ITButton(title: "柳叶眉", alignment: .left)
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
    
    private var first = false
    
    let TPBWCollectionViewCellID = "TPBWCollectionViewCellID"

}

extension AnalysisViewController{
    func initView(){
        first = true
        view.addSubview(topContentView)
        topContentView.addSubview(collectionView)
        topContentView.addSubview(figureImageView)
        topContentView.sendSubviewToBack(figureImageView)
        view.addSubview(contentScrollView)
        contentScrollView.addSubview(analysisLabel)
        contentScrollView.addSubview(organTitleLabel)
        contentScrollView.addSubview(organsImageView)
        contentScrollView.addSubview(organsContentLabel)
        initLayout()
        contentScrollView.layoutIfNeeded()
        contentScrollView.contentSize = CGSize(width: ScreenWidth, height: organsContentLabel.frame.maxY)
    }
    
    func initLayout(){
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(contentScrollView.snp.top)
            make.height.equalTo(105)
        }
        
        figureImageView.snp.makeConstraints { make in
            make.bottom.equalTo(contentScrollView.snp.top)
            make.top.equalTo(view).offset(NavBarViewHeight + StatusHeight)
            make.centerX.equalTo(view)
            make.width.equalTo(fitWidth(width: 200))
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
}

//MARK: - 按键事件
extension AnalysisViewController{
   
}
