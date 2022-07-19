//
//  FaceAnalyzeViewController.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/7.
//

import UIKit
import AVFoundation

///脸型分析 作为摄像头拍照视图


//TODO: -需要添加缓冲使得后续操作继续
//1.需要用户授权相机权限
//2.需要用户授权读取相册权限
class FaceAnalyzeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //暂停照片流
        if captureSession!.isRunning{
            captureSession?.stopRunning()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !captureSession!.isRunning{
            captureSession?.startRunning()
        }
        cameraTool.capturePhotoDelegate = self
        detectPermissions()
    }
    

    //MARK: - 懒加载以及变量
    ///图像流显示
    private lazy var previewView:CameraPreviewView = {
        return CameraPreviewView()
    }()
    
    private lazy var bottomView:UIView = {
        let view = UIView()
        return view
    }()
    
    ///相册按键
    private lazy var photoLibaryButton:UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(enterUserPhotoLibary), for: .touchUpInside)
        button.setImage(UIImage(named: "photo_libary"), for: .normal)
        return button
    }()
    
    ///拍照按键
    private lazy var snapButton:UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = fitWidth(width: 40)
        button.setImage(UIImage(named: "camera_white"), for: .normal)
        button.configuration?.imagePadding = 10
        button.backgroundColor = EssentialColor
        button.addTarget(self, action: #selector(snap), for: .touchUpInside)
        return button
    }()
    
    ///前后置摄像头
    private lazy var flipButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "flip_camera"), for: .normal)
        button.addTarget(self, action: #selector(flipCamera), for: .touchUpInside)
        return button
    }()
    
    ///相机工具
    private lazy var cameraTool:CameraTool = {
        let tool = CameraTool.shared
        tool.pickerDelegate = pickerDelegate
        tool.delegate = self
        return tool
    }()
    
    ///捕获流
    private lazy var captureSession:AVCaptureSession? = {
        return cameraTool.setupCaptureSession()
    }()

    //默认使用后置摄像头
    private var position:AVCaptureDevice.Position = .back
    
    ///当前设备
    private var currentViewdeoDevice:AVCaptureDevice?
    
    ///相册获取代理
    private lazy var pickerDelegate:PickerDelegate = {
        let delegate = PickerDelegate()
        delegate.photosPickedBlock = { [weak self] images in
            let strSelf = self
            DispatchQueue.main.async {
                strSelf?.dismiss(animated: true)
                if let image = images.first{
                    strSelf?.pushViewControllerWithImage(image)
                }
            }
        }
        return delegate
    }()
}

// MARK: - UI
extension FaceAnalyzeViewController{
    func initView(){
        view.tag = 0
        view.backgroundColor = BlackColor
        view.addSubview(navBarView)
        view.addSubview(previewView)
        view.addSubview(bottomView)
        bottomView.addSubview(photoLibaryButton)
        bottomView.addSubview(snapButton)
        bottomView.addSubview(flipButton)
        initLayout()
    }
    
    func initLayout(){
        
        bottomView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view)
            make.height.equalTo(fitHeight(height: 130))
        }
        
        previewView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.top.equalTo(navBarView.snp.bottom)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        
        photoLibaryButton.snp.makeConstraints { make in
            make.left.equalTo(view).offset(fitWidth(width: 30))
            make.width.height.equalTo(fitWidth(width: 40))
            make.centerY.equalTo(bottomView)
        }
        
        snapButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(photoLibaryButton)
            make.height.width.equalTo(fitWidth(width: 80))
        }
        
        flipButton.snp.makeConstraints { make in
            make.centerY.equalTo(photoLibaryButton)
            make.right.equalTo(view).offset(-fitWidth(width: 30))
            make.width.height.equalTo(fitWidth(width: 30))
        }
        
    }
    
    func pushViewControllerWithImage(_ image:UIImage){
        let vc = MainFaceViewController()
        vc.figureImage = image
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - 权限访问
extension FaceAnalyzeViewController{
    //检测权限
    func detectPermissions(){
        detectCameraPermission()
    }
    
    func detectCameraPermission() -> Bool{
        guard let alert = cameraTool.cameraPerssion() else{
            //说明已经授权了 显示摄像头的内容
            showInPreviewView()
            return true
        }
        present(alert, animated: true, completion: nil)
        return false
    }
    
    func detectPhotoLibaryPermission(){
        guard let alert = cameraTool.checkPhotoLibrary() else{
            return
        }
        present(alert, animated: true, completion: nil)
    }
    
    func showInPreviewView(){
        //开始运行
        previewView.videoPreviewLayer.session = captureSession
    }
    
    //启用或禁止按钮
    func buttonIsEnabled(isEnabled:Bool){
        snapButton.isEnabled = isEnabled
        flipButton.isEnabled = isEnabled
        photoLibaryButton.isEnabled = isEnabled
    }
    
}

//MARK: - 按键事件
extension FaceAnalyzeViewController{
    @objc func enterUserPhotoLibary(){
        guard let alert = cameraTool.checkPhotoLibrary()else{
            let vc = cameraTool.openPhotoLibrary(isEnableMultiselection: false)
            present(vc, animated: true)
            return
        }
        present(alert, animated: true, completion: nil)
    }
    
    @objc func snap(){
        //1.检查权限
        if detectCameraPermission(){
            cameraTool.takePiture()
        }
    }
    
    //翻转镜头
    @objc func flipCamera(){
        if detectCameraPermission(){
            buttonIsEnabled(isEnabled: false)
            
            cameraTool.flipCamera()
            
            buttonIsEnabled(isEnabled: true)
        }
    }
}

//MARK: - 照片处理
extension FaceAnalyzeViewController:AVCapturePhotoCaptureDelegate,CameraToolDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("获取照片时候发生错误:\(error)")
            return
        }
        //1.获取照片
        let data = photo.fileDataRepresentation()!
        let image = UIImage(data: data)
        //2.将照片传递
        //TODO: - 需要将捕获的照片上传到服务器进行人脸检测
        pushViewControllerWithImage(image!)
    }
    
    func cameraOperationFailure(tool: CameraTool, alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
}

