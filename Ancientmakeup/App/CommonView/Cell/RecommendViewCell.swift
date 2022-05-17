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
    
    //MARK: - 懒加载以及变量
    
    private let RecommendCellID = "RecommendCellID"
    
    private lazy var topContentView:UIView = {
        let view = UIView()
        view.backgroundColor = SkinColor
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var little:UIImageView = {
        return littleWinterSweet
    }()
    
    private lazy var large:UIImageView = {
        return largeWinterSweet
    }()
    
    //妆容名称
    private lazy var makeupTitleLabel:UILabel = {
        let label = UILabel()
        label.font = Title3Font
        label.text = "桃花妆"
        return label
    }()
    
    //妆容图像
    private lazy var makeupImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "wintersweet_title")
        return imageView
    }()
    
    
    private lazy var bottomContentView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addShadow()
        view.layer.cornerRadius = 20
        return view
    }()
    
    ///妆容描述
    private lazy var makeupContentLabel:UILabel = {
        let label = UILabel()
        label.font = MainBodyFont
        label.textColor = DeepGrayColor
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = ScreenWidth - fitWidth(width: 80)
        label.text = "比酒晕妆稍浅，妆色浅而艳如桃花，流行于隋唐时期。比酒晕妆稍浅，妆色浅而艳如桃花，流行于隋唐时期。比酒晕妆稍浅，妆色浅而艳如桃花，流行于隋唐时期。比酒晕妆稍浅，妆色浅而艳如桃花，流行于隋唐时期。"
        return label
    }()
    
    ///推荐标题
    private lazy var recommendTitleLabel:UILabel = {
        let label = UILabel()
        label.font = LittleFont
        label.textColor = .black
        label.text = "推荐指数"
        return label
    }()

    ///推荐指数
    var starsNum:Int = 5
    
    ///推荐星星
    private lazy var starsView:UIView = {
        let view = UIView()
        //配置星星
        for i in 0 ..< starsNum{
            var itemX = CGFloat(i) * fitWidth(width: 23)
            let imageView = UIImageView(frame: CGRect(x: itemX, y: 0, width: fitWidth(width: 18), height: fitWidth(width: 18)))
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "star_red")
            view.addSubview(imageView)
        }
        return view
    }()

}

//MARK: - UI
extension RecommendViewCell{
    func initView(){
        contentView.addSubview(topContentView)
        contentView.addSubview(bottomContentView)
        topContentView.addSubview(makeupTitleLabel)
        topContentView.addSubview(makeupImageView)
        topContentView.addSubview(little)
        topContentView.addSubview(large)
        topContentView.sendSubviewToBack(little)
        topContentView.sendSubviewToBack(large)
        bottomContentView.addSubview(makeupContentLabel)
        bottomContentView.addSubview(recommendTitleLabel)
        bottomContentView.addSubview(starsView)
        contentView.sendSubviewToBack(bottomContentView)
        initLayout()
        
        bottomContentView.layoutIfNeeded()
        let maxY = recommendTitleLabel.frame.maxY + 30
        bottomContentView.snp.updateConstraints { make in
            make.height.equalTo(maxY)
        }
    }
    
    func initLayout(){
        topContentView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(fitHeight(height: 30))
            make.left.equalTo(self).offset(fitWidth(width: 30))
            make.right.equalTo(self).offset(-fitWidth(width: 30))
            make.height.equalTo(150)
        }
        
        makeupTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(topContentView).offset(fitWidth(width: 20))
            make.centerY.equalTo(topContentView)
        }
        
        little.snp.makeConstraints { make in
            make.top.equalTo(makeupTitleLabel.snp.bottom).offset(5)
            make.left.equalTo(fitWidth(width: 80))
            make.width.height.equalTo(fitWidth(width: 30))
        }
        
        large.snp.makeConstraints { make in
            make.left.equalTo(little.snp.right).offset(fitWidth(width: 5))
            make.height.width.equalTo(fitWidth(width: 100))
            make.top.equalTo(topContentView).offset(fitHeight(height: 25))
        }
        
        makeupImageView.snp.makeConstraints { make in
            make.bottom.equalTo(topContentView)
            make.right.equalTo(topContentView)
            make.height.equalTo(fitWidth(width: 200))
        }
        
        bottomContentView.snp.makeConstraints { make in
            make.top.equalTo(topContentView.snp.bottom).offset(-50)
            make.left.equalTo(self).offset(fitWidth(width: 20))
            make.right.equalTo(self).offset(-fitWidth(width: 20))
            make.height.equalTo(fitHeight(height: 160))
        }
        
        makeupContentLabel.snp.makeConstraints { make in
            make.top.equalTo(topContentView.snp.bottom).offset(20)
            make.left.equalTo(bottomContentView).offset(fitWidth(width: 20))
            make.right.equalTo(bottomContentView).offset(-fitWidth(width: 20))
        }
        
        recommendTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(fitWidth(width: 20))
            make.top.equalTo(makeupContentLabel.snp.bottom).offset(10)
        }
        
        starsView.snp.makeConstraints { make in
            make.left.equalTo(recommendTitleLabel.snp.right).offset(fitWidth(width: 8))
            make.top.equalTo(recommendTitleLabel)
        }
    }
}
