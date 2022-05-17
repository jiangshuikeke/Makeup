//
//  CameraTool.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/12.
//

///摄像头相关操作
import Foundation
import AVFoundation
import UIKit
import PhotosUI
///相机单例类
class CameraTool{
    static let shared:CameraTool = CameraTool()
    
    private init(){
        
    }
    
    //MARK: - 懒加载以及变量
    var videoDeviceInput:AVCaptureDeviceInput?
    var photoOutput:AVCapturePhotoOutput?
    var discvoerSession:AVCaptureDevice.DiscoverySession?
    var captureSession:AVCaptureSession?
    //当前镜头位置
    var currentPosition:AVCaptureDevice.Position = .back
    
    //
    open weak var capturePhotoDelegate:AVCapturePhotoCaptureDelegate?
    
    open weak var pickerDelegate:PHPickerViewControllerDelegate?
    

}

//MARK: - 摄像
extension CameraTool{
    ///权限
    func cameraPerssion() -> UIAlertController? {
        //检测当前设备是否有摄像头
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            //1.未决定发送请求
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { flag in }
            //2.拒绝需要发送提示
        case .denied:
            let alert = UIAlertController(title: "无法使用摄像头", message: "允许使用摄像头，通过设置 > 隐私 > 摄像头，允许当前APP使用摄像头。", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "好的", style: .cancel,handler: nil)
            alert.addAction(okAction)
            
            let settingAction = UIAlertAction(title: "设置", style: .default) { _ in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else{ return }
                //严谨
                if UIApplication.shared.canOpenURL(settingsUrl){
                    UIApplication.shared.open(settingsUrl, options: [:],completionHandler: nil)
                }
            }
            alert.addAction(settingAction)
            return alert
            //3.授权了
        case .authorized:
            return nil
            
        case .restricted:
            fatalError("当前设备存在限制")
        @unknown default:
            fatalError("发生未知错误")
        }
        return nil
    }

    ///寻找设备中摄像设备 默认后置
    func device(position:AVCaptureDevice.Position = .back) -> AVCaptureDevice?{
        return bestDevice(in: position)
    }

    func bestDevice(in position:AVCaptureDevice.Position) -> AVCaptureDevice{
        discvoerSession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTelephotoCamera,.builtInDualCamera,.builtInDualWideCamera,.builtInTrueDepthCamera,.builtInUltraWideCamera,.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        let devices = discvoerSession!.devices
        guard !devices.isEmpty else{ fatalError("该设备没有适配的摄像硬件") }
        return devices.first { device in device.position == position }!
    }

    ///配置捕获流
    func setupCaptureSession() -> AVCaptureSession?{
        captureSession = AVCaptureSession()
        //开启事件
        captureSession!.beginConfiguration()
        let device = device()
        addInputAndOutput(device: device!, captureSession: captureSession!)
        //提交事件
        captureSession!.commitConfiguration()
        return captureSession
    }

    
    //添加输入输出流
    func addInputAndOutput(device:AVCaptureDevice,captureSession:AVCaptureSession){
        //添加输入流
        videoDeviceInput = try? AVCaptureDeviceInput(device: device)
        if captureSession.canAddInput(videoDeviceInput!){
            captureSession.addInput(videoDeviceInput!)
        }else{ fatalError("无法添加该输入流")}
        //添加输出流
        photoOutput = AVCapturePhotoOutput()
        guard captureSession.canAddOutput(photoOutput!) else{ fatalError("无法添加该输出流") }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput!)
    }

    ///捕获图像
    func takePiture(){
        let photoSettings:AVCapturePhotoSettings = AVCapturePhotoSettings()
        //闪光灯
        photoSettings.flashMode = .auto
       
        //
        guard capturePhotoDelegate != nil else{
            fatalError("当前没有输出照片代理")
        }
        photoOutput?.capturePhoto(with: photoSettings, delegate: capturePhotoDelegate!)
    }

    ///翻转摄像头
    func flipCamera(){
        var newVideoDevice:AVCaptureDevice? = nil
        
        switch currentPosition{
        case .unspecified,.front:
            currentPosition = .back
            newVideoDevice = device(position: currentPosition)
        case .back:
            currentPosition = .front
            newVideoDevice = device(position: currentPosition)
        @unknown default:
            print("未知摄像头位置,使用默认摄像头")
            newVideoDevice = device()
        }
        
        guard let session = captureSession,let currentInput = videoDeviceInput else{
            //
            print("当前捕获流失效")
            return
        }
        
        session.beginConfiguration()
        let input = try? AVCaptureDeviceInput(device: newVideoDevice!)
        
        session.removeInput(currentInput)
        if session.canAddInput(input!){
            session.addInput(input!)
        }else{
            print("无法添加该设备输入")
        }
        session.commitConfiguration()
        videoDeviceInput = input
        
    }
}

//MARK: - photo libary
extension CameraTool{
    
    ///检测权限状态
    func checkPhotoLibrary() -> UIAlertController?{
        var alert:UIAlertController? = nil
        //1.获取当前相册状态
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in }
        case .restricted:
            print("相册受限")
        case .denied:
            alert = UIAlertController(title: "相册访问受限", message: "允许访问相册，通过设置 > 隐私 > 相册", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "好的", style: .cancel, handler: nil)
            alert!.addAction(okAction)
            let settings = UIAlertAction(title: "设置", style: .default) { _ in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else{ return }
                if UIApplication.shared.canOpenURL(settingsUrl){
                    UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
                }
            }
            alert!.addAction(settings)
        case .authorized:
            return nil
        case .limited:
            return nil
        @unknown default:
            fatalError("获取相册权限发生了未知错误")
        }
        return alert
    }
    ///打开相册
    func openPhotoLibrary(isEnableMultiselection:Bool) -> PHPickerViewController{
        return pickerViewController(filter: .images,isEnableMultiselection: isEnableMultiselection)
    }
    
    //初始化配置
    func pickerViewController(filter:PHPickerFilter?,isEnableMultiselection:Bool = false) -> PHPickerViewController{
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        
        configuration.filter = filter
        configuration.preferredAssetRepresentationMode = .current
        configuration.selection = .ordered
        //根据判断
        let num = isEnableMultiselection ?0:1
        configuration.selectionLimit = num
        
        //选中图像标识
//        configuration.preselectedAssetIdentifiers =
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = pickerDelegate
        return picker
    }
}

