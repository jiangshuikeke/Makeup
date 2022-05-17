//
//  RecommendDetailViewController.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/13.
//

import UIKit
import PhotosUI

///推荐妆容详细界面
class RecommendDetailViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        initView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentScrollView.drawTopCurve(color: .red)
        testPhoto()
        print("画面展示")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("画面隐藏")
    }
    
    //MARK: - 懒加载以及变量
    private lazy var little:UIImageView = {
        return littleWinterSweet
    }()
    
    private lazy var large:UIImageView = {
        return largeWinterSweet
    }()
    
    private lazy var figureImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var contentScrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = LightGrayColor
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    //底部视图
    private lazy var bottomView:UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var cameraTool:CameraTool = {
        let tool = CameraTool.shared
        tool.pickerDelegate = self
        return tool
    }()
    //
    private var selections = [String:PHPickerResult]()
}

//MARK: - UI
extension RecommendDetailViewController{
    func initView(){
        navBarView.title = "妆容详情"
        view.backgroundColor = SkinColor
        view.addSubview(navBarView)
        view.addSubview(little)
        view.addSubview(large)
        view.sendSubviewToBack(little)
        view.sendSubviewToBack(large)
        view.addSubview(contentScrollView)
        initLayout()
 
    }
    
    func initLayout(){
        little.snp.makeConstraints { make in
            make.width.equalTo(fitWidth(width: 50))
            make.left.equalTo(view).offset(fitWidth(width: 80))
            make.top.equalTo(navBarView.snp.bottom).offset(fitHeight(height: 100))
        }
        
        large.snp.makeConstraints { make in
            make.left.equalTo(fitWidth(width: 70))
            make.top.equalTo(little.snp.bottom).offset(fitHeight(height: 30))
            make.width.height.equalTo(fitWidth(width: 160))
        }
        contentScrollView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.height.equalTo(fitHeight(height: 500))
            make.top.equalTo(large.snp.bottom).offset(fitHeight(height: 20))
        }
    }
    
    func testPhoto(){
        guard let alert =  cameraTool.checkPhotoLibrary() else{
            let vc = cameraTool.openPhotoLibrary(isEnableMultiselection: false)
            present(vc, animated: true, completion: nil)
            return
        }
        present(alert, animated: true, completion: nil)
    }
}


extension RecommendDetailViewController:PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        let exsitingSelections = selections
        var newSelections = [String:PHPickerResult]()
        for result in results {
            let id = result.assetIdentifier!
            newSelections[id] = exsitingSelections[id] ?? result
        }
        
        selections = newSelections
    }
    
    
}
