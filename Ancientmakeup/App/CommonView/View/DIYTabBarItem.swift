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
        self.imageView.image = image
        self.title.text = title
        self.selectedImage = selectedImage
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 懒加载
    private let imageBorder : CGFloat = fitWidth(width: 32)
    private var selectedImage:String?
    private var image:UIImage?
    private lazy var imageView:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private var title:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    var isSelected : Bool = false{
        didSet{
            //更改选择图片
            if isSelected{
                if nil != selectedImage{
                    imageView.image = UIImage(named: selectedImage!)
                }
                title.textColor = .white
            }else{
                imageView.image = image
                title.textColor = .black
            }
        }
    }
}

//MARK: - UI
extension DIYTabBarItem{
    func initView(){
        addSubview(imageView)
        addSubview(title)
        initLayout()
    }
    
    func initLayout(){
        imageView.snp.makeConstraints({ make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-fitHeight(height: 3))
            make.width.equalTo(imageBorder)
            make.height.equalTo(imageBorder)
        })
        
        title.snp.makeConstraints({ make in
            make.centerX.equalTo(self)
            make.top.equalTo(imageView.snp.bottom).offset(3)
        })
    }
    
   
}
