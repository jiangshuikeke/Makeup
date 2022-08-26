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

enum AuthorizationType {
    case libary
    case camera
}
///相机单例类
class CameraTool{
    init(){
        setupCaptureSession()
    }
    
    //MARK: - 懒加载以及变量
    var videoDeviceInput:AVCaptureDeviceInput?
    var photoOutput:AVCapturePhotoOutput = AVCapturePhotoOutput()
    var discvoerSession:AVCaptureDevice.DiscoverySession?
    var captureSession:AVCaptureSession = AVCaptureSession()
    //当前镜头位置
    var currentPosition:AVCaptureDevice.Position = .front
    weak var delegate:CameraToolDelegate?
    //
    open weak var capturePhotoDelegate:AVCapturePhotoCaptureDelegate?
    
    open weak var pickerDelegate:PHPickerViewControllerDelegate?
}

//MARK: - 摄像
extension CameraTool{
    ///权限
    func cameraPerssion() {
        AVCaptureDevice.requestAccess(for: .video) {[weak self] flag in
            guard let self = self else{ return }
            //检测当前设备是否有摄像头
            switch AVCaptureDevice.authorizationStatus(for: .video) {
                //1.未决定发送请求
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { flag in }
                //2.拒绝需要发送提示
            case .denied:
                let alert = UIAlertController(title: "无法使用摄像头", message: "允许使用摄像头，通过设置 > 隐私 > 摄像头，允许当前APP使用摄像头。")
                self.delegate?.cameraOperationFailure(tool: self, alert: alert)
                //3.授权了
            case .authorized:
                print("摄像头已经授权")
                self.delegate?.cameraOperationSuccess(tool: self,type: .camera)
            case .restricted:
                print("当前摄像设备存在限制")
            @unknown default:
                print("发生未知错误")
            }
        }
    }

    ///寻找设备中摄像设备 默认后置
    func device(position:AVCaptureDevice.Position = .back) -> AVCaptureDevice?{
        return bestDevice(in: position)
    }

    func bestDevice(in position:AVCaptureDevice.Position) -> AVCaptureDevice?{
        discvoerSession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTelephotoCamera,.builtInDualCamera,.builtInDualWideCamera,.builtInTrueDepthCamera,.builtInUltraWideCamera,.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        let devices = discvoerSession!.devices
        if devices.isEmpty{
            let alert = UIAlertController(errorMessage: "该设备没有适配的摄像硬件")
            if delegate != nil{
                delegate?.cameraOperationFailure(tool: self, alert: alert)
            }
            return nil
        }
        return devices.first { device in device.position == position }!
    }

    ///配置捕获流
    func setupCaptureSession(){
        //开启事件
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .photo
        //使用前置摄像头
        guard let device = device(position: .front) else{
            print("没有找到合适的摄像设备")
            captureSession.commitConfiguration()
            return 
        }
        addInput(device: device)
        addOutput()
        //提交事件
        captureSession.commitConfiguration()
    }

    
    //添加输入流
    func addInput(device:AVCaptureDevice){
        if videoDeviceInput == nil{
            //生成输入流
            do {
                videoDeviceInput = try AVCaptureDeviceInput(device: device)
            }catch{
                print("无法生成视频设备输入流")
                return
            }
        }
        //添加输入流
        guard captureSession.canAddInput(videoDeviceInput!) else{
            print("无法添加该输入流")
            captureSession.commitConfiguration()
            return
        }
        captureSession.addInput(videoDeviceInput!)
    }
    
    ///添加输出流
    func addOutput(){
        //添加输出流
        if captureSession.canAddOutput(photoOutput){
            captureSession.sessionPreset = .photo
            captureSession.addOutput(photoOutput)
        }
        else{
            captureSession.commitConfiguration()
            print("无法添加输出流")
            return
        }
    }

    ///捕获图像
    func takePiture(){
        let photoSettings:AVCapturePhotoSettings = AVCapturePhotoSettings()
        //闪光灯
        photoSettings.flashMode = .off
       
        //
        if capturePhotoDelegate == nil{
            let alert = UIAlertController(errorMessage: "当前没有输出照片代理") 
            if (delegate != nil){
                delegate?.cameraOperationFailure(tool: self, alert: alert)
            }
        }
        photoOutput.capturePhoto(with: photoSettings, delegate: capturePhotoDelegate!)
    }

    ///翻转摄像头
    func flipCamera(){
        var newVideoDevice:AVCaptureDevice? = nil
        
        //转化摄像头
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
        
        guard let currentInput = videoDeviceInput else{
            print("当前捕获流失效")
            return
        }
        //获取到有效的硬件设备
        if let newVideoDevice = newVideoDevice {
            do{
              let deviceInput = try AVCaptureDeviceInput(device: newVideoDevice)
                //配置seesion
                captureSession.beginConfiguration()
                //移除当前输入流
                captureSession.removeInput(currentInput)
                if captureSession.canAddInput(deviceInput){
                    captureSession.addInput(deviceInput)
                    videoDeviceInput = deviceInput
                }else{
                    //如果无法添加则使用原输入流
                    captureSession.addInput(currentInput)
                }
                captureSession.commitConfiguration()
            }catch{
                print("无法获取硬件设备输入流")
            }
        }
    }
    
    //出厂设置
    func factorySettings(){
        captureSession.beginConfiguration()
        //移除输入
        guard let videoDeviceInput = videoDeviceInput else{ return }
        if captureSession.inputs.contains(videoDeviceInput){
            captureSession.removeInput(videoDeviceInput)
        }
        //移除输出
        if captureSession.outputs.contains(photoOutput){
            captureSession.removeOutput(photoOutput)
        }
        captureSession.commitConfiguration()
    }
}

//MARK: - photo libary
extension CameraTool{
    
    ///检测权限状态
    func checkPhotoLibrary(){
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            guard let self = self else{ return }
            switch status {
                case .notDetermined:
                    PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in }
                case .restricted:
                    print("相册受限")
                case .denied:
                    let alert = UIAlertController(title: "相册访问受限", message: "允许访问相册，通过设置 > 隐私 > 相册")
                    self.delegate?.cameraOperationFailure(tool: self, alert: alert)
                case .authorized:
                    self.delegate?.cameraOperationSuccess(tool: self,type: .libary)
                    print("已经授权")
                case .limited:
                    print("受限")
                @unknown default:
                    fatalError("获取相册权限发生了未知错误")
                }
            }
        
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
        let num = isEnableMultiselection ?9:1
        configuration.selectionLimit = num
        
        //选中图像标识
//        configuration.preselectedAssetIdentifiers =
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = pickerDelegate
        return picker
    }
}

protocol CameraToolDelegate:NSObjectProtocol{
    func cameraOperationFailure(tool:CameraTool,alert:UIAlertController)
    
    func cameraOperationSuccess(tool:CameraTool,type:AuthorizationType)
}
