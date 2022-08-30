//
//  RecommendViewCell.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/11.
//

import UIKit

///推荐妆容Cellq
class RecommendViewCell: UITableViewCell {
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: RecommendCellID)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        if !detailButton.frame.isEmpty && detailButton.contentView.subviews.isEmpty{
            let view = DoubleITView(frame: detailButton.bounds, title: "查看详情", textColor: BlackColor, leftImage: UIImage(named: "makeup_detail")!, rightImage: UIImage(named: "next_dotted")!)
            detailButton.contentView.addSubview(view)
        }
    }
    //MARK: - 懒加载以及变量
    private let RecommendCellID = "RecommendCellID"
        
    open var makeup:Makeup?{
        didSet{
            makeupTitleLabel.title = makeup?.name
            starsNum = makeup?.recommendationRate ?? 5
            let cardName = (makeup?.figureImage)! + "_card"
            backView.image = UIImage(named: cardName)
        }
    }
    //妆容名称
    private lazy var makeupTitleLabel:ITButton = ITButton()

    ///妆容图像
    private lazy var makeupImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    ///推荐标题
    private lazy var recommendTitleLabel:UILabel = {
        let label = UILabel()
        label.font = MainBodyFont
        label.textColor = .black
        label.text = "热度"
        label.sizeToFit()
        return label
    }()

    ///推荐指数
    var starsNum:Int = 5 {
        didSet{
            configureStarView()
        }
    }
    
    ///推荐星星
    private lazy var starsView:UIView = {
        return UIView()
    }()
    
    var cellHeight:CGFloat?
    
    private lazy var likeButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "like_white"), for: .normal)
        button.configuration?.imagePadding = 12
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        button.backgroundColor = BlackColor
        button.addTarget(self, action: #selector(likeMakeup), for: .touchUpInside)
        return button
    }()
    
    private lazy var detailButton:UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemMaterialLight)
        let view = UIVisualEffectView(effect:blur)
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(enterDetailPage)))
        return view
    }()
    
    private lazy var backView:UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: fitHeight(height: 290)))
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    //进入详细界面block
    var enterDetail:((_ makeup:Makeup) -> Void)?
}

//MARK: - UI
extension RecommendViewCell{
    func initView(){
        //40作为间距
        contentView.addSubview(backView)
        
        contentView.addSubview(makeupTitleLabel)
        contentView.addSubview(recommendTitleLabel)
        contentView.addSubview(starsView)
        //
        contentView.addSubview(likeButton)
        contentView.addSubview(detailButton)
        //
        contentView.sendSubviewToBack(backView)
        initLayout()
        
        contentView.addShadow()
    }
    
    func initLayout(){
        makeupTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(backView).offset(fitHeight(height: 90))
            make.left.equalTo(backView).offset(fitWidth(width: 24))
        }
        
        recommendTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(makeupTitleLabel).offset(fitWidth(width: 12))
            make.top.equalTo(makeupTitleLabel.snp.bottom).offset(15)
        }
        
        starsView.snp.makeConstraints { make in
            make.top.equalTo(recommendTitleLabel).offset(-2)
            make.left.equalTo(recommendTitleLabel.snp.right).offset(fitWidth(width: 5))
        }
        
        likeButton.snp.makeConstraints { make in
            make.left.equalTo(recommendTitleLabel)
            make.bottom.equalTo(backView).offset(-fitHeight(height: 22))
            make.height.width.equalTo(fitWidth(width: 56))
        }
        
        detailButton.snp.makeConstraints { make in
            make.left.equalTo(likeButton.snp.right).offset(fitWidth(width: 15))
            make.top.equalTo(likeButton)
            make.right.equalTo(backView).offset(-fitWidth(width: 27))
            make.bottom.equalTo(likeButton)
        }
        
//        makeupImageView.snp.makeConstraints { make in
//            make.right.equalTo(backView)
//            make.bottom.equalTo(backView)
//            make.height.equalTo(fitHeight(height: 275))
//            make.width.equalTo(fitWidth(width: 335))
//        }
        

    }
    
    func configureStarView(){
        //配置星星
        if !starsView.subviews.isEmpty{
            for subview in starsView.subviews{
                subview.removeFromSuperview()
            }
        }
        for i in 0 ..< starsNum{
            let itemX = CGFloat(i) * fitWidth(width: 16)
            let imageView = UIImageView(frame: CGRect(x: itemX, y: fitHeight(height: 3), width: fitWidth(width: 13), height: fitWidth(width: 13)))
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "star_red")
            starsView.addSubview(imageView)
        }
    }
}

//MARK: - 按键事件
extension RecommendViewCell{
    @objc
    func likeMakeup(){
        print("收藏了")
    }
    
    @objc
    func enterDetailPage(){
        if enterDetail != nil && makeup != nil{
            enterDetail!(makeup!)
        }

    }
}

