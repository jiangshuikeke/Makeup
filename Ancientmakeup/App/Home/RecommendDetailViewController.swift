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
    }
    
    //MARK: - 懒加载以及变量
    private lazy var titleLabel:ITButton = {
        return ITButton(title: "桃花妆", alignment: .left)
    }()
    
    //描述
    private lazy var descriptionView:UIView = {
        return UIView()
    }()
    
    private lazy var figureImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "wintersweet_title")
        return imageView
    }()
    
    private lazy var topContentView:UIScrollView = {
        let view = UIScrollView(frame: CGRect(origin: .zero, size: CGSize(width: ScreenWidth, height: fitHeight(height: 400))))
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
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "camera_white"), for: .normal)
        button.setTitle("试妆", for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        button.backgroundColor = EssentialColor
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
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
    
    private lazy var fixedTitleLabel:ITButton = {
        let label = ITButton(title: "妆容史话", alignment: .left)
        return label
    }()
    
    private lazy var contentLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = ScreenWidth - fitWidth(width: 40)
        label.textColor = DeepGrayColor
        return label
    }()
    
    private var makeup:Makeup?
    
    open var descriptions = ["额头画上花钿","胭脂范围扩大到眼上和太阳穴","双颊酒窝处画或粘贴上面靥"]
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
        titleLabel.setTitle(makeup?.name, for: .normal)
        configureDescriptionView()
        
    }
    
    func initLayout(){
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(fitWidth(width: 20))
            make.top.equalTo(navBarView.snp.bottom).offset(90)
        }
        
        figureImageView.snp.makeConstraints { make in
            make.bottom.equalTo(contentScrollView.snp.top).offset(40)
            make.right.equalTo(view)
            make.height.equalTo(540)
            make.width.equalTo(300)
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
    
    override func back() {
        hiddenTabbar(isHidden: false, tag: 1)
        super.back()
    }
    
    func configureDescriptionView(){
        let itemX = 20
        for (index,description) in descriptions.enumerated(){
            let itemY = index * 40
            let label = UILabel(frame: CGRect(origin: CGPoint(x: itemX, y: itemY), size: .zero))
            label.font = ExtraLittleFont
            label.text = description
            label.textColor = .black
//            label.numberOfLines = 0
//            label.preferredMaxLayoutWidth = 50
            label.sizeToFit()
           
            descriptionView.addSubview(label)
        }
        
        descriptionView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(60)
        }
    }
    
    func setContentLabelText(content:String){
        let line = NSMutableParagraphStyle()
        line.lineSpacing = 8
        let attr = [NSAttributedString.Key.font:MainBodyFont,NSAttributedString.Key.paragraphStyle : line]
        contentLabel.attributedText =  NSAttributedString.init(string: content, attributes: attr)
        contentLabel.sizeToFit()
    }
    
}

//MARK: - 按键事件
extension RecommendDetailViewController{
    @objc
    func enterLessonPage(sender:UITapGestureRecognizer){
        let vc = TeachingViewController(makeup: makeup!)
        navigationController?.pushViewController(vc, animated: true)
    }
}

