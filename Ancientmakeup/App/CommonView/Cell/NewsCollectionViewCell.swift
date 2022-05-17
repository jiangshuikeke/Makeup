//
//  NewsCollectionViewCell.swift
//  ScorllviewTest
//
//  Created by 陈沈杰 on 2022/4/19.
//
import UIKit
///动态
class NewsCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 懒加载与变量
    
    ///发布的图像
    private lazy var imageView:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = EssentialColor
        return image
    }()
    
    ///标题
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = extraMediumFont
        label.text = "来试试看来试试看"
        label.preferredMaxLayoutWidth = ScreenWidth - 2 * fitWidth(width: 10)
        label.numberOfLines = 2
        return label
    }()
    
    ///昵称
    private lazy var nicknameLabel:UILabel = {
        let label = UILabel()
        label.font = LittleFont
        label.text = "bLacKpinK"
        return label
    }()
    
    ///头像
    private lazy var iconImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = fitWidth(width: 8)
        imageView.backgroundColor = EssentialColor
        return imageView
    }()
    
    ///爱心
    private lazy var likeIconImageView:UIImageView = {
        let like = UIImageView()
        like.image = UIImage(named: "like")
        like.contentMode = .scaleAspectFit
        like.isUserInteractionEnabled = true
        like.backgroundColor = EssentialColor
        return like
    }()
    
    ///点赞数
    private lazy var likeNumLabel:UILabel = {
        let label = UILabel()
        label.font = LittleFont
        label.text = "189"
        return label
    }()
    
    ///底部视图
    private lazy var bottomView:UIView = {
        let view = UIView()
        view.backgroundColor = LightGrayColor
        return view
    }()
    
    
    
    ///cell 高度
    public var cellHeight:CGFloat{
        contentView.layoutSubviews()
        let height = imageView.frame.height + titleLabel.frame.height +
        bottomView.frame.height +
        fitHeight(height: 20)
    
        return height
    }
    
    ///cell 宽度
    public var cellWidth:CGFloat{
        get{
            return (ScreenWidth - 2 * fitWidth(width: 20) - fitWidth(width: 15)) / 2
        }
    }
    
    private lazy var backLayer:CAShapeLayer = {
        let lay = CAShapeLayer()
//        lay.fillColor = UIColor.black.cgColor
        lay.shadowRadius = 10
        lay.shadowOffset = CGSize(width: 0, height: 2)
        lay.shadowColor = UIColor.black.cgColor
        lay.shadowOpacity = 0.6
        return lay
    }()
    
}

extension NewsCollectionViewCell{
    func initView(){
        backgroundColor = LightGrayColor
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(likeIconImageView)
        contentView.addSubview(likeNumLabel)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
//        contentView.addSubview(bottomView)
        initLayout()
        
    }
    
    func initLayout(){
        imageView.snp.makeConstraints { make in
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.top.equalTo(contentView)
//            let height:Int = Int((arc4random() % 30)+120)
            let height = 150
            make.height.equalTo(CGFloat(height))
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(fitHeight(height: 8))
            make.height.equalTo(fitHeight(height: 36))
            make.left.equalTo(contentView).offset(fitWidth(width: 10))
            make.right.equalTo(contentView).offset(-fitWidth(width: 10))
        }
        
        iconImageView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(fitHeight(height: 6))
            make.height.equalTo(fitWidth(width: 16))
            make.width.equalTo(fitWidth(width: 16))

        }

        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconImageView)
            make.left.equalTo(iconImageView.snp.right).offset(fitWidth(width: 2))
            make.right.equalTo(likeIconImageView.snp.left).offset(-fitWidth(width: 2))
            make.height.equalTo(fitHeight(height: 20))
        }

        likeIconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(iconImageView)
            make.left.equalTo(nicknameLabel.snp.right).offset(fitWidth(width: 2))
            make.width.equalTo(fitWidth(width: 15))
            make.height.equalTo(fitWidth(width: 15))
        }

        likeNumLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconImageView)
            make.left.equalTo(likeIconImageView.snp.right).offset(fitWidth(width: 2))
        }
    

//        bottomView.snp.makeConstraints { make in
//            make.top.equalTo(iconImageView.snp.bottom).offset(fitHeight(height: 5))
//            make.left.equalTo(contentView)
//            make.height.equalTo(fitHeight(height: 15))
//            make.width.equalTo(contentView)
//        }
    }
}
