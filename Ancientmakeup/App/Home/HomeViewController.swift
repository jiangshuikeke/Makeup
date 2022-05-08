//
//  HomeViewController.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/4/16.
//

import UIKit

class HomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("主视图隐藏")
       
    }
    
    
    //MARK: -懒加载变量
    
    ///背景视图
    private lazy var roundedRect : RoundedRectView = {
        return RoundedRectView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: fitHeight(height: 195)),type: .BottomRounded,radius: 30,color: SkinColor)
        
    }()
    
    ///欢迎文案
    private lazy var helloLabel:UILabel = {
        //20,105
       let label = UILabel(frame: CGRect(x: 0, y: 0, width: fitWidth(width: 343), height: fitHeight(height: 41)))
        label.font = UIFont.boldSystemFont(ofSize: 34)
        label.text = "下午好,ALEX"
        return label
    }()
    
    ///功能组件
    private lazy var faceComponent : ComponentView = {
        let view = ComponentView(image: "face", title: "脸型分析")
        view.isUserInteractionEnabled = true
        view.tag = 0
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickComponentView(sender:))))
       return view
    }()
    
    private lazy var nationalComponent : ComponentView = {
        return ComponentView(image: "national", title: "国风试妆")
    }()

    ///妆容图像
    private lazy var makeupImageView:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "page0")
        return image
    }()
    
    ///妆容标题
    private lazy var makeupTitleView:UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.layer.cornerRadius = 10
        blurView.layer.masksToBounds = true
        blurView.frame.size = CGSize(width: fitWidth(width: 245), height: fitHeight(height: 45))
        let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: fitWidth(width: 245), height: fitHeight(height: 45))))
        label.textAlignment = .center
        label.text = "梅花妆"
        label.textColor = EssentialColor
        label.font = UIFont.boldSystemFont(ofSize: 23)
        blurView.contentView.addSubview(label)
        return blurView
    }()
    
    ///妆容内容
    private lazy var makeupContentLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "「寿阳公主人日卧于含章殿檐下，梅花落公主额上，成五出花，拂之不去。皇后留之，看得几时，经三日，洗之乃落，宫女奇其异，竞效之，今梅花妆是也」\n——《太平御览》"
        label.textAlignment = .left
        label.preferredMaxLayoutWidth = ScreenWidth - 2 * fitWidth(width: 65)
        label.numberOfLines = 0
        label.textColor = DeepGrayColor
        label.font = MainBodyFont
        return label
    }()
    
}

//MARK: - UI
private extension HomeViewController{
    func initView(){
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = LightGrayColor
        view.addSubview(roundedRect)
        //背景以及欢迎
        view.sendSubviewToBack(roundedRect)
        view.addSubview(helloLabel)
        //功能组件UI
        view.addSubview(faceComponent)
        view.addSubview(nationalComponent)
        //妆容部分UI
        view.addSubview(makeupImageView)
//        view.addSubview(blurView)
        view.addSubview(makeupTitleView)
        view.addSubview(makeupContentLabel)
        initLayout()
    }
    
    func initLayout(){
        let offset:CGFloat = faceComponent.frame.height / 2
        let border:CGFloat = (ScreenWidth - 2 * faceComponent.frame.width - fitWidth(width: 5)) / 2
        
        helloLabel.snp.makeConstraints { make in
            make.left.equalTo(view).offset(fitWidth(width: 20))
            make.top.equalTo(view).offset(fitHeight(height: 105))
        }
        
        faceComponent.snp.makeConstraints { make in
            make.width.equalTo(fitWidth(width: 164))
            make.height.equalTo(fitHeight(height: 68))
            make.top.equalTo(roundedRect.snp.bottom).offset(-offset)
            make.left.equalTo(view).offset(border)
        }
        
        nationalComponent.snp.makeConstraints { make in
            make.width.equalTo(fitWidth(width: 164))
            make.height.equalTo(fitHeight(height: 68))
            make.left.equalTo(faceComponent.snp.right).offset(fitWidth(width: 5))
            make.top.equalTo(faceComponent)
        }
        
        makeupImageView.snp.makeConstraints { make in
            make.top.equalTo(faceComponent.snp.bottom).offset(fitHeight(height: 8))
            make.bottom.equalTo(view).offset(-fitHeight(height: 255))
            make.left.equalTo(view).offset(fitWidth(width: 20))
            make.right.equalTo(view).offset(-fitWidth(width: 20))
            
        }
        
        makeupTitleView.snp.makeConstraints { make in
            make.top.equalTo(makeupImageView.snp.bottom).offset(-fitHeight(height: 20))
            make.height.equalTo(fitHeight(height: 45))
            make.left.equalTo(view).offset(fitWidth(width: 65))
            make.right.equalTo(view).offset(-fitWidth(width: 65))
        }
        
        makeupContentLabel.snp.makeConstraints { make in
            make.top.equalTo(makeupTitleView.snp.bottom).offset(fitHeight(height: 18))
            make.left.equalTo(view).offset(fitWidth(width: 36))
            make.right.equalTo(view).offset(-fitWidth(width: 36))
        }
    }
}

//按键事件
extension HomeViewController{
    @objc func clickComponentView(sender:UITapGestureRecognizer){
        let view = sender.view
        //切换到不同的界面
        if view?.tag == 0 {
            NotificationCenter.default.post(name: PushViewControllerTabbarIsHidden, object: true)
            navigationController?.pushViewController(FaceAnalyzeViewController(), animated: true)
        }else{
            
        }
    }
}
