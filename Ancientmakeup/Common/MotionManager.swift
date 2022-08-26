//
//  MotionManager.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/8/9.
//

import Foundation
import CoreMotion

enum OrientationType{
    case up
    case down
    case right
    case left
}

///重力感应
class Motionmanager{
    static var shared:Motionmanager = Motionmanager()
    
    private init(){
        //检查硬件是否支持
        if !cmMontionManager.isAccelerometerAvailable{
            print("该设备不支持加速度硬件无法判断拍摄方向")
        }
    }
    
    //MARK: - 懒加载以及变量
    weak var delegate:MotionManagerDelegate?
    
    private lazy var cmMontionManager:CMMotionManager = {
        let manager = CMMotionManager()
        //设置更新频率为10hz
        manager.accelerometerUpdateInterval = 0.1
        return manager
    }()
    
}

extension Motionmanager{
    //加速度传感器开始采样
    func startAccelerometer(){
        cmMontionManager.startAccelerometerUpdates(to: OperationQueue.current!) {[weak self] data, error in
            guard let self = self else{
                print("当前MotionManager已经deinit")
                return
            }
            guard let data = data else{
                print("无法获取加速度数据")
                return
            }
            let x = data.acceleration.x
            let y = data.acceleration.y
            
            if fabs(y) >  fabs(x){
                if y > 0{
                    //down
                    self.delegate?.currentOrientation(orientation: .down)
                }else{
                    //up
                    self.delegate?.currentOrientation(orientation: .up)
                }
            }else{
                if x > 0{
                    //right
                    self.delegate?.currentOrientation(orientation: .right)
                }else{
                    //left
                    self.delegate?.currentOrientation(orientation: .left)
                }
            }
            
        }
    }
    
    func stopAccelerometer(){
        if cmMontionManager.isAccelerometerActive{
            cmMontionManager.stopAccelerometerUpdates()
        }
    }
}

protocol MotionManagerDelegate:NSObjectProtocol {
    func currentOrientation(orientation:OrientationType)
}
