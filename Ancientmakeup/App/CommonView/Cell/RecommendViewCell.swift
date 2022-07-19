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
    
    override var frame: CGRect{
        get{
            return super.frame
        }
        set{
            var temp = newValue
            temp.origin.x += fitWidth(width: 20)
            temp.size.width -= fitWidth(width: 40)
            super.frame = temp
        }
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
            makeupTitleLabel.setTitle(makeup?.name, for: .normal)
            starsNum = makeup?.recommendationRate ?? 5
            makeupImageView.image = UIImage(named: makeup?.figureImage ?? "error")
        }
    }
    //妆容名称
    private lazy var makeupTitleLabel:UIButton = {
        let label = ITButton(title: "桃花妆", alignment: .left)
        return label
    }()

    ///妆容图像
    private lazy var makeupImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "wintersweet_title")
        return imageView
    }()
    
    ///推荐标题
    private lazy var recommendTitleLabel:UILabel = {
        let label = UILabel()
        label.font = LittleFont
        label.textColor = .black
        label.text = "推荐指数"
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
    
    private lazy var backView:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 60, width: ScreenWidth - fitWidth(width: 40), height: 200))
        view.backgroundColor = SkinColor
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
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
        contentView.addSubview(makeupImageView)
        //
        contentView.addSubview(likeButton)
        contentView.addSubview(detailButton)
        //
        contentView.sendSubviewToBack(makeupImageView)
        contentView.sendSubviewToBack(backView)
        initLayout()
        
        contentView.addShadow()
    }
    
    func initLayout(){
        makeupTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(backView).offset(25)
            make.left.equalTo(backView).offset(fitWidth(width: 15))
        }
        
        recommendTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(makeupTitleLabel)
            make.top.equalTo(makeupTitleLabel.snp.bottom).offset(15)
        }
        
        starsView.snp.makeConstraints { make in
            make.top.equalTo(recommendTitleLabel).offset(-2)
            make.left.equalTo(recommendTitleLabel.snp.right).offset(5)
        }
        
        likeButton.snp.makeConstraints { make in
            make.left.equalTo(makeupTitleLabel)
            make.bottom.equalTo(backView).offset(-10)
            make.height.width.equalTo(64)
        }
        
        detailButton.snp.makeConstraints { make in
            make.left.equalTo(likeButton.snp.right).offset(fitWidth(width: 15))
            make.top.equalTo(likeButton)
            make.right.equalTo(backView).offset(-fitWidth(width: 15))
            make.bottom.equalTo(likeButton)
        }
        
        makeupImageView.snp.makeConstraints { make in
            make.right.equalTo(backView)
            make.bottom.equalTo(backView)
            make.height.equalTo(280)
            make.width.equalTo(240)
        }
        

    }
    
    func configureStarView(){
        //配置星星
        if !starsView.subviews.isEmpty{
            for subview in starsView.subviews{
                subview.removeFromSuperview()
            }
        }
        for i in 0 ..< starsNum{
            let itemX = CGFloat(i) * fitWidth(width: 23)
            let imageView = UIImageView(frame: CGRect(x: itemX, y: 0, width: fitWidth(width: 20), height: fitWidth(width: 20)))
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

