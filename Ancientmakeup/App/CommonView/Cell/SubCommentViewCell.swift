//
//  SubCommentViewCell.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/6.
//

import UIKit

///子评论Cell
class SubCommentViewCell: CommentViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    
    
   

}

//MARK: - UI
extension SubCommentViewCell{
    override func initView() {
        contentView.backgroundColor = LightGrayColor
        iconImageView.layer.cornerRadius = 12
        contentView.addSubview(iconImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(contentLabel)
        setLayout()
    }
    
    func setLayout(){
        iconImageView.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(fitWidth(width: 23) + 32)
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView)
            make.left.equalTo(iconImageView.snp.right).offset(fitWidth(width: 3))
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(nicknameLabel)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(3)
        }
    }
}
