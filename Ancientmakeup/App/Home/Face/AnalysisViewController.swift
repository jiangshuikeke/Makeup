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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        figureImageView.image = figureImage
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let maxY = organsContentLabel.convert(organsContentLabel.frame, to: view).maxY
        contentScrollView.contentSize = CGSize(width: ScreenWidth, height: maxY)
    }
    
    //MARK: - 懒加载以及变量
    var landmark:FaceLandmark?
    var figureImage:UIImage?
    
    let organsImageWidth:CGFloat = 0.7 * ScreenWidth
    private lazy var topContentView:UIScrollView = {
        let view = UIScrollView(frame: CGRect(origin: .zero, size: CGSize(width: ScreenWidth, height: fitHeight(height: 320))))
        view.backgroundColor = SkinColor
        view.isScrollEnabled = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    //人物图像
    private lazy var figureImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
        
    //使用tableview展现五官
    private lazy var collectionView:HorizontalCollectionView = {
        let view = HorizontalCollectionView(isLesson: false)
        view.horizontalDelegate = self
        return view
    }()
    
    private lazy var contentScrollView:UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: fitHeight(height: 280), width: ScreenWidth, height: ScreenHeight))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = LightGrayColor
        scrollView.drawTopCurve(color: .white)
        scrollView.bounces = false
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
    private lazy var organTitleLabel:ITButton = ITButton()
    
    //五官图像
    private lazy var organsImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    //五官描述
    private lazy var organsContentLabel:UILabel = {
        let label = UILabel()
        label.font = MainBodyFont
        label.textColor = DeepGrayColor
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = ScreenWidth - fitWidth(width: 20) * 2
        return label
    }()
    
    private var first = false
    private var plistManager:PlistManager = PlistManager()
    
    let TPBWCollectionViewCellID = "TPBWCollectionViewCellID"

}

extension AnalysisViewController{
    func initView(){
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
        collectionView.layoutIfNeeded()
        contentScrollView.layoutIfNeeded()
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
        refreshContentWith(organs: (landmark?.face)!)
    }
    
    func initLayout(){
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(contentScrollView.snp.top)
            make.height.equalTo(fitHeight(height: 105))
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
            make.height.equalTo(fitHeight(height: 41))
        }
        
        organTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(analysisLabel)
            make.top.equalTo(analysisLabel.snp.bottom).offset(fitHeight(height: 8))
            make.height.equalTo(fitHeight(height: 41))
        }
        
        organsImageView.snp.makeConstraints { make in
            make.left.equalTo(organTitleLabel)
            make.top.equalTo(organTitleLabel.snp.bottom).offset(5)
            make.height.equalTo(fitHeight(height: 160))
            make.width.equalTo(organsImageWidth)
        }
        
        organsContentLabel.snp.makeConstraints { make in
            make.left.equalTo(organTitleLabel)
            make.top.equalTo(organsImageView.snp.bottom).offset(10)
        }
    }
    
    func refreshContentWith(organs:Organs){
        organTitleLabel.title = organs.name ?? "无定义"
        //根据图像大小来适配当前ImageView
        guard let image = organs.image else{
            print("未获取到当前五官图像")
            return
        }
        let imageSize = image.size
        //检查长宽
        var width:CGFloat = organsImageWidth
        var height:CGFloat = 0
        if imageSize.height > imageSize.width{
            height = organsImageWidth
            width = height * 0.618
        }else{
            height = organsImageWidth * 0.618
        }
        organsImageView.snp.updateConstraints { make in
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
        
        organsImageView.image = image
        //使得内容行距为8
        let line = NSMutableParagraphStyle()
        line.lineSpacing = 8
        organsContentLabel.attributedText = NSAttributedString(string: plistManager.readValueFor(organs.name!, type: organs.type!) ?? "该五官没有定义", attributes: [.font:MainBodyFont,.paragraphStyle:line])
        organsContentLabel.sizeToFit()
    }
}

//MARK: - 按键事件
extension AnalysisViewController:HorizontalCollectionViewDelegate{
    //根据点击来切换底部内容
    func collectionView(_ horizontalCollectionView: HorizontalCollectionView, didSelectedIn index: NSInteger) {
        let currentOrgans:Organs?
        guard let landmark = landmark else{
            print("未获取到五官的特征")
            return
        }
        switch index{
            case 0:
                currentOrgans = landmark.face
                break
            case 1:
                currentOrgans = landmark.rightEyebrow
                break
            case 2:
                currentOrgans = landmark.rightEye
                break
            case 3:
                currentOrgans = landmark.mouth
                break
            case 4:
                currentOrgans = landmark.nose
                break
            default:
                currentOrgans = landmark.face
                print("选择五官的时候出现错误")
        }
        refreshContentWith(organs: currentOrgans!)
    }
    
   
}
