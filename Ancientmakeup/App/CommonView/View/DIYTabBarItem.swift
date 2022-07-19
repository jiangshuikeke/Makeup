//
//  DIYTabBarItem.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/4/16.
//

import UIKit

class DIYTabBarItem: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(image:UIImage?,title:String?,selectedImage:String?){
        self.init(frame: .zero)
        self.image = image
        self.imageView.image = image?.withTintColor(DeepGrayColor)
        self.title = title
        titleLabel.text = title
        self.selectedImage = selectedImage
        initView()
    }
    
    convenience init(image:UIImage?,title:String?,tintColor:UIColor){
        self.init(frame: .zero)
        self.image = image
        self.title = title
        imageView.image = image?.withTintColor(tintColor)
        color = tintColor
        titleLabel.text = title
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 懒加载
    private var imageBorder : CGFloat = fitWidth(width: 23)
    private var selectedImage:String?
    private var image:UIImage?
    private lazy var imageView:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    private var color:UIColor?
    private var title:String?
    private var titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    var isSelected : Bool = false{
        didSet{
            //更改选择图片
            if isSelected{
                imageView.image = image?.withTintColor(.white)
                titleLabel.textColor = .white
            }else{
                imageView.image = image?.withTintColor(color!)
                titleLabel.textColor = .black
            }
        }
    }
}

//MARK: - UI
extension DIYTabBarItem{
    func initView(){
        addSubview(imageView)
        if title != nil{
            addSubview(titleLabel)
            titleLabel.snp.makeConstraints({ make in
                make.centerX.equalTo(self)
                make.top.equalTo(imageView.snp.bottom).offset(2)
            })
        }else{
            imageBorder = fitWidth(width: 100)
        }
        initLayout()
    }
    
    func initLayout(){
        imageView.snp.makeConstraints({ make in
            if title != nil{
                make.centerX.equalTo(self)
                make.centerY.equalTo(self).offset(-fitHeight(height: 3))
            }else{
                make.centerX.equalTo(self)
                make.centerY.equalTo(self).offset(fitHeight(height: 3))
            }
           
            make.width.height.equalTo(imageBorder)
        })
    }
    
   
}
