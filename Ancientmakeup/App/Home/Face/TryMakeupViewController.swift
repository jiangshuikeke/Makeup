//
//  TryMakeupViewController.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/8/23.
//

import UIKit
import ARKit
import SceneKit

///试妆VC
///采用AR技术将滤镜贴到人脸之中
class TryMakeupViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //设置贴图图像名称
        
        remakeTracking()
    }
    
//MARK: - 懒加载以及变量
    //贴图图像
    public var imageName:String?
        //检测当前设备是否支持AR
    private lazy var isSupproted:Bool = {
        guard ARConfiguration.isSupported else{
            return false
        }
        guard ARFaceTrackingConfiguration.isSupported else{
            return false
        }
        return true
    }()

    //人脸追踪配置
    private lazy var faceConfiguration:ARFaceTrackingConfiguration = {
        let con = ARFaceTrackingConfiguration()
        if #available(iOS 13.0, *){
            con.maximumNumberOfTrackedFaces = ARFaceTrackingConfiguration.supportedNumberOfTrackedFaces
        }
        con.isLightEstimationEnabled = true
        return con
    }()
    
    //用来显示虚拟景象，与现实融合
    private lazy var sceneView:ARSCNView = {
        let view = ARSCNView(frame: self.view.frame)
        view.session.delegate = self
        view.delegate = self
        return view
    }()
    
    //妆容贴图
    private lazy var makeupNode:SCNNode = {
        let node =  makeFaceGeometry(setup: { material in
            material?.fillMode = .fill
            material?.diffuse.contents = UIImage(named: imageName!)
        }, fillMesh: false)
        node.name = imageName
        return node
    }()
}

//MARK: - UI
extension TryMakeupViewController{
    func initView(){
        view.addSubview(sceneView)
        initLayout()
    }
    
    func initLayout(){
        
    }
}

//MARK: - AR相关
extension TryMakeupViewController:ARSCNViewDelegate,ARSessionDelegate{
    
    func makeFaceGeometry(setup:(SCNMaterial?) -> Void,fillMesh:Bool) -> SCNNode{
        //无法运行在模拟器中
//        #if targetEnvironment(simulator)
//        #error("ARKit is not supported in iOS Simulator. Connect a physical iOS device and select it as your Xcode run destination, or select Generic iOS Device as a build-only destination.")
//        #else
        guard let device = sceneView.device else{
            print("无法找到device")
            return SCNNode()
        }
        let geometry = ARSCNFaceGeometry(device: device,fillMesh: fillMesh)
        let material = geometry?.firstMaterial
        //配置
        setup(material)
//        #endif
        return SCNNode(geometry: geometry)
    }
    
    
    //重新配置
    func remakeTracking(){
        if isSupproted{
            sceneView.session.run(faceConfiguration, options: [.removeExistingAnchors,.resetTracking])
        }
    }
    
    //错误处理
    func session(_ session: ARSession, didFailWithError error: Error) {
        //提示用户出错 让用户重新选择配置AR
        let info = error as NSError
        let messages = [
            info.localizedDescription,
            info.localizedFailureReason,
            info.localizedRecoverySuggestion
        ]
        let errorMessage = messages.compactMap({$0}).joined(separator: "\n")
        
        let alert = UIAlertController(errorMessage: errorMessage, handleTitle: "重置") { [weak self] alertAct in
            guard let self = self else{ return }
            self.dismiss(animated: true, completion: nil)
            self.remakeTracking()
        }
        
        //运行在主线程
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //更新Node使得脸部移动的时候，贴图可以契合
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor,let faceGeometry = node.geometry as? ARSCNFaceGeometry else{ return }
        faceGeometry.update(from: faceAnchor.geometry)
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard anchor is ARFaceAnchor else{ return nil }
        return makeupNode
    }
}
