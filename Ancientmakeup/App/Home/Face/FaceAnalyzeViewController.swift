//
//  FaceAnalyzeViewController.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/7.
//

import UIKit
import AVFoundation
import PhotosUI

///脸型分析 作为摄像头拍照视图


//TODO: -需要添加缓冲使得后续操作继续
//1.需要用户授权相机权限
//2.需要用户授权读取相册权限
//3.开启重力感应来获取当前设备的拍摄方向
class FaceAnalyzeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detectCameraPermission()
        motionManager.startAccelerometer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancelAll()
    }
    
    deinit {
        //出厂设置
//        cameraTool.factorySettings()
        cancelAll()
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
    
    private lazy var visionManager:VisionManager = VisionManager()
    
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
        let tool = CameraTool()
        tool.pickerDelegate = self
        tool.capturePhotoDelegate = self
        tool.delegate = self
        return tool
    }()
    
    private lazy var motionManager:Motionmanager = Motionmanager()
    
    ///捕获流
    private lazy var captureSession:AVCaptureSession? = {
        return cameraTool.captureSession
    }()
    
//    ///相册获取代理
//    private lazy var pickerDelegate:PickerDelegate = {
//        let delegate = PickerDelegate()
//        delegate.photosPickedBlock = { [weak self] images in
//            guard let self = self else{ return }
//            DispatchQueue.main.async {
//                self.dismiss(animated: true)
//                //获取当前的image 进行背景模糊化处理
//                if let image = images.first{
////                    let fix = image.fixedImage()
//                    if let cgImage = image.cgImage{
//                        self.processCGImageAndPushVC(cgImage: cgImage,orientation: image.cgImageOrientation)
//                    }
//
//                }
//
//            }
//        }
//        return delegate
//    }()
    
    //当前需要校正的方向
    private var currentFixedOrientation:CGImagePropertyOrientation? = .up
    
    //
    private lazy var indicatorView:IndicatorView = IndicatorView(title:"加载中")
    
    private var photoViewController:PHPickerViewController?
}

// MARK: - UI
extension FaceAnalyzeViewController{
    func initView(){
        isPreHasTab = true
        view.tag = 0
        view.backgroundColor = BlackColor
        view.addSubview(navBarView)
        view.addSubview(previewView)
        view.addSubview(bottomView)
        view.addSubview(indicatorView)
        bottomView.addSubview(photoLibaryButton)
        bottomView.addSubview(snapButton)
        bottomView.addSubview(flipButton)
        initLayout()
        
        motionManager.delegate = self
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
    
    func cancelAll(){
        if captureSession!.isRunning{
            captureSession?.stopRunning()
        }
        motionManager.stopAccelerometer()
    }
    
    func pushViewControllerWithImage(cgImage:CGImage,_ image:UIImage,orientation:CGImagePropertyOrientation?){
        let vc = MainFaceViewController()
        vc.figureImage = cgImage
        vc.displayImage = image
        vc.orientation = orientation
        indicatorView.stopAnimating()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //照片背景模糊化
    func processCGImageAndPushVC(cgImage:CGImage,orientation:CGImagePropertyOrientation? = .up){
        //2.人像切割
        let ciFace = visionManager.personSegmentation(in:cgImage,orientation: orientation)
        guard let ciFace = ciFace else {
            print("无法获取分割后的ciImage")
            return
        }
        let uiFace = UIImage(ciImage: ciFace)
        pushViewControllerWithImage(cgImage: cgImage,uiFace,orientation: orientation)
    }
}

//MARK: - 权限访问
extension FaceAnalyzeViewController{
    //检测权限
    func detectCameraPermission(){
        cameraTool.cameraPerssion()
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
        cameraTool.checkPhotoLibrary()
    }
    
    @objc func snap(){
        detectCameraPermission()
        cameraTool.takePiture()
        indicatorView.startAnimating()
    }
    
    //翻转镜头
    @objc func flipCamera(){
        detectCameraPermission()
        buttonIsEnabled(isEnabled: false)
        cameraTool.flipCamera()
        buttonIsEnabled(isEnabled: true)
    }
}

//MARK: - 照片处理
extension FaceAnalyzeViewController:AVCapturePhotoCaptureDelegate,CameraToolDelegate{
    func cameraOperationSuccess(tool: CameraTool,type:AuthorizationType) {
        //不能在主线程中使用同步任务
        //在其他线程中可以将当前任务作为同步任务插入到主线程队列中
        Dispatch.DispatchQueue.main.sync {
            if type == .libary{
                photoViewController = cameraTool.openPhotoLibrary(isEnableMultiselection: false)
                present(photoViewController!, animated: true)
            }else{
                if !captureSession!.isRunning{
                    captureSession?.startRunning()
                }
                showInPreviewView()
            }
        }
       
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        //停止捕获
        if captureSession!.isRunning{
            captureSession!.stopRunning()
            //提示用户在缓冲
        }
        
        if let error = error {
            print("获取照片时候发生错误:\(error)")
            indicatorView.stopAnimating()
            return
        }
        //1.获取像素流
        if let data = photo.fileDataRepresentation(){
            let uiImage = UIImage(data: data)
            guard let uiImage = uiImage,let cgImage = uiImage.cgImage else {
                print("无法获取照片的像素流")
                indicatorView.stopAnimating()
                return
            }
            //2.人像切割 并且跳转到下一个VC
            processCGImageAndPushVC(cgImage: cgImage,orientation: currentFixedOrientation)
        }
        
        
    }
    
    func cameraOperationFailure(tool: CameraTool, alert: UIAlertController) {
        Dispatch.DispatchQueue.main.sync {
            present(alert, animated: true, completion: nil)
        }
        
    }
}

//MARK: - 处理相册中的照片
extension FaceAnalyzeViewController:PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        //当前的相册只能选择一张照片
        guard let itemProvider = results.first?.itemProvider else{
            dismiss(animated: true, completion: nil)
            return
        }
        if itemProvider.canLoadObject(ofClass: UIImage.self){
            itemProvider.loadObject(ofClass: UIImage.self) {[weak self] image, error  in
                guard let self = self else{ return }
                if error != nil{
                    print("加载相册照片出现错误\(error.debugDescription)")
                    return
                }
                
                //相册选择Controller消失
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    //调整图像显示方向
                    if let image = image as? UIImage{
//                        let fit = image.fixedImage()
                        if let cgImage = image.cgImage{
                            self.processCGImageAndPushVC(cgImage: cgImage, orientation: image.cgImageOrientation)
                        }
                    }
                }
            }
        }
        
    }
}
//MARK: - 获取当前设备的方向
extension FaceAnalyzeViewController:MotionManagerDelegate{
    func currentOrientation(orientation: OrientationType) {
        switch orientation {
        case .up:
            currentFixedOrientation = .right
        case .down:
            currentFixedOrientation = .left
        case .right:
            currentFixedOrientation = nil
        case .left:
            currentFixedOrientation = .down
        }
    }
}

