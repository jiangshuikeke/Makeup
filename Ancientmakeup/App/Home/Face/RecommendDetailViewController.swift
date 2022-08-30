//
//  RecommendDetailViewController.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/13.
//

import UIKit
import PhotosUI

///推荐妆容详细界面
class RecommendDetailViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    convenience init(makeup:Makeup){
        self.init()
        self.makeup = makeup
        descriptions = makeup.characteristics
    }
    
    //MARK: - 懒加载以及变量
    private lazy var titleLabel:ITButton = ITButton()
    
    //描述
    private lazy var descriptionView:UIView = {
        return UIView()
    }()
    
    private lazy var figureImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var topContentView:UIScrollView = {
        let view = UIScrollView(frame: CGRect(origin: .zero, size: CGSize(width: ScreenWidth, height: ScreenHeight)))
        view.backgroundColor = SkinColor
        return view
    }()
    
    private lazy var contentScrollView:UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: fitHeight(height: 380), width: ScreenWidth, height: ScreenHeight))
        scrollView.backgroundColor = LightGrayColor
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.drawTopCurve(color: .white)
        return scrollView
    }()
    
    //底部视图
    private lazy var bottomView:UIView = {
        let view = UIView()
        return view
    }()

    private lazy var cameraButton:UIButton = {
        var con = UIButton.Configuration.filled()
        con.image = UIImage(named: "camera_white")
        con.title = "试妆"
        con.baseForegroundColor = .white
        con.imagePadding = 8
        con.baseBackgroundColor = EssentialColor
        let button = UIButton(configuration: con, primaryAction: nil)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tryMakeuping(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var teachingButton:DoubleITView = {
        let view = DoubleITView(frame: .zero, title: "开始教学", textColor: .white, leftImage: UIImage(named: "makeup_detail_white")!, rightImage: UIImage(named: "next_dotted_white")!)
        view.backgroundColor = BlackColor
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(enterLessonPage(sender:))))
        return view
    }()
    
    private lazy var fixedTitleLabel:ITButton = ITButton(title:"妆容史话")
    
    private lazy var contentLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = ScreenWidth - fitWidth(width: 40)
        label.textColor = DeepGrayColor
        return label
    }()
    
    private var makeup:Makeup?
    
    open var descriptions = [String]()
}

//MARK: - UI
extension RecommendDetailViewController{
    func initView(){
        navBarView.title = "妆容详情"
        view.addSubview(topContentView)
        topContentView.addSubview(titleLabel)
        topContentView.addSubview(descriptionView)
        topContentView.addSubview(figureImageView)
        topContentView.sendSubviewToBack(figureImageView)
        view.addSubview(contentScrollView)
        view.sendSubviewToBack(topContentView)
        contentScrollView.addSubview(fixedTitleLabel)
        contentScrollView.addSubview(contentLabel)
        
        view.addSubview(cameraButton)
        view.addSubview(teachingButton)
        initLayout()
        setContentLabelText(content: makeup!.content ?? "无描述")
        figureImageView.image = UIImage(named: makeup!.figureImage ?? "error")
        titleLabel.title = makeup?.name
        configureDescriptionView()
        
    }
    
    func initLayout(){
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(fitWidth(width: 20))
            make.top.equalTo(navBarView.snp.bottom).offset(fitHeight(height: 72))
        }
        
        figureImageView.snp.makeConstraints { make in
            make.width.equalTo(fitWidth(width: 300))
            make.height.equalTo(fitHeight(height: 320))
            make.bottom.equalTo(contentScrollView.snp.top)
            make.right.equalTo(view)
        }
        
        fixedTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(view).offset(fitWidth(width: 20))
            make.top.equalTo(contentScrollView).offset(fitWidth(width: 30))
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(fixedTitleLabel)
            make.top.equalTo(fixedTitleLabel.snp.bottom).offset(fitWidth(width: 20))
        }
        
        cameraButton.snp.makeConstraints { make in
            make.left.equalTo(view).offset(fitWidth(width: 20))
            make.bottom.equalTo(view).offset(-35)
            make.height.equalTo(70)
            make.width.equalTo(fitWidth(width: 120))
        }
        
        teachingButton.snp.makeConstraints { make in
            make.left.equalTo(cameraButton.snp.right).offset(fitWidth(width: 15))
            make.top.equalTo(cameraButton)
            make.right.equalTo(view).offset(-fitWidth(width: 20))
            make.height.equalTo(cameraButton)
        }
    }
    
    func configureDescriptionView(){
        var itemY:CGFloat = 0
        for (_,description) in descriptions.enumerated(){
            let label = ITButton(image: "black_ring", font: MainBodyFont)
            label.title = description
            label.frame = CGRect(x: 0, y: itemY, width: fitWidth(width: 180), height: fitHeight(height: 32))
            label.sizeToFit()
            itemY += label.frame.height + 8.0
            descriptionView.addSubview(label)
        }
        
        descriptionView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(fitHeight(height: 20))
        }
    }
    
    func setContentLabelText(content:String){
        let line = NSMutableParagraphStyle()
        line.lineSpacing = 8
        let attr = [NSAttributedString.Key.font:MainBodyFont,NSAttributedString.Key.paragraphStyle : line]
        contentLabel.attributedText =  NSAttributedString.init(string: content, attributes: attr)
        contentLabel.sizeToFit()
        contentScrollView.contentSize = CGSize(width: ScreenWidth, height: contentLabel.frame.maxY + DIYTabBarHeight + fitHeight(height: 20))
    }
    
}

//MARK: - 按键事件
extension RecommendDetailViewController{
    @objc
    func enterLessonPage(sender:UITapGestureRecognizer){
        //判断当前是否有step
        guard ((makeup?.parts) != nil) else{
            let alert = UIAlertController(errorMessage: "当前妆容教程正在开发中")
            present(alert, animated: true, completion: nil)
            return
        }
        let vc = TeachingViewController(makeup: makeup!)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func tryMakeuping(sender:UITapGestureRecognizer){
        guard let filter = makeup?.filter else{
            let alert = UIAlertController(errorMessage: "设计师正在设计妆容滤镜...")
            present(alert, animated: true, completion: nil)
            return
        }
        
        let vc = TryMakeupViewController()
        //TODO: - 更换贴图
        vc.filterName = filter
        navigationController?.pushViewController(vc, animated: true)
    }
}

