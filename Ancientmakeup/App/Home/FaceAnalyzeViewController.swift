//
//  FaceAnalyzeViewController.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/7.
//

import UIKit

///脸型分析 作为摄像头拍照视图
class FaceAnalyzeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
    }
    

    //MARK: - 懒加载以及变量
    
    //图像控制器
    private lazy var imagePickerController:UIImagePickerController = {
        return UIImagePickerController()
    }()
    
    //拍照按键
    private lazy var takePhotoButton:UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()
    
    //翻转镜头
    private lazy var flipCameraButton:UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()
    
    //相册按键
    private lazy var photoRollButton:UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()
    
    //导航栏
    private lazy var navBarView:NavBarView = {
        let view = NavBarView(title: nil)
        view.delegate = self
        return view
    }()

}

// MARK: - UI
extension FaceAnalyzeViewController{
    func initView(){
        view.tag = 0
        view.backgroundColor = LightGrayColor
        view.addSubview(navBarView)
        initLayout()
    }
    
    func initLayout(){
        
    }
}



// MARK: -UIImagePickerControllerDelegate
extension FaceAnalyzeViewController:UIImagePickerControllerDelegate{
    //完成拍照动作后触发的代理事件
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        guard let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else{
            return
        }
    }
    
    //取消拍照
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true) {
            
        }
    }
}

// MARK: - Utilities
private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value) })
}

private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
