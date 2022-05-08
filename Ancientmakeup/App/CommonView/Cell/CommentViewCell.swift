//
//  TableViewCell.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/6.
//

import UIKit

///评论Cell
class CommentViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    
    //评论评论者的
    private lazy var tableView:UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.dataSource = self
        table.isScrollEnabled = false
        table.separatorStyle = .none
        table.register(SubCommentViewCell.self, forCellReuseIdentifier: SubCommentViewCellID)
        return table
    }()
    
    //评论者icon
    lazy var iconImageView:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 15
        image.layer.masksToBounds = true
        image.backgroundColor = .blue
        return image
    }()
    
    //评论者昵称
    lazy var nicknameLabel:UILabel = {
        let label = UILabel()
        label.text = "嘻嘻哈哈"
        label.textColor = BlackColor
        return label
    }()
    
    //评论内容
    lazy var contentLabel:UILabel = {
        let label = UILabel()
        label.preferredMaxLayoutWidth = ScreenWidth - 2 * fitWidth(width: 20)
        label.numberOfLines = 0
        label.font = MainBodyFont
        label.text = "123134532sfqrqsrqwasdfqwradfgwhfiuaib"
        return label
    }()
    
    //ID
    private let CommentViewCellID = "CommentViewCellID"
    //ID
    private let SubCommentViewCellID = "SubCommentViewCellID"
    
    var cellHeight:CGFloat {
        layoutIfNeeded()
        return contentLabel.frame.maxY + 15
    }
}

//MARK: - UI
extension CommentViewCell{
    @objc func initView(){
        contentView.backgroundColor = LightGrayColor
        contentView.addSubview(iconImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(tableView)
        initLayout()
    }

    func initLayout(){
        iconImageView.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(fitWidth(width: 20))
            make.height.equalTo(32)
            make.width.equalTo(32)
            make.top.equalTo(contentView).offset(8)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(fitWidth(width: 3))
            make.top.equalTo(iconImageView)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            make.left.equalTo(nicknameLabel)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.bottom.equalTo(contentView)
                }
    }
}

//MARK: - UITableViewDelegate
extension CommentViewCell:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubCommentViewCellID, for: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
