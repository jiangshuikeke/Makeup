//
//  PickerDelegate.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/6/17.
//
import PhotosUI
import UIKit

typealias PhotosPickedBlock = (_ images:[UIImage]) -> ()

class PickerDelegate: PHPickerViewControllerDelegate {
    var photosPickedBlock:PhotosPickedBlock?
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        //使用调度组去进行图片的获取
        var res = [UIImage]()
        let group = DispatchGroup()
//        let globalQueue = DispatchQueue(label: "ImageQueue")
        for result in results {
            group.enter()
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self){
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    if error != nil{
                        print("\(String(describing: error))")
                        return
                    }
                    res.append((image as? UIImage)!)
                    group.leave()
                }
            }
           
        }
        
        group.wait()
        photosPickedBlock?(res)
//        group.notify(queue: globalQueue) { [weak self] in
//            let strSelf = self
//            if strSelf?.photosPickedBlock != nil{
//                strSelf?.photosPickedBlock!(res)
//            }
//        }
        
        
    }
}

protocol PickerPro:NSObjectProtocol{
    func picking()
    func pickDidEnd()
}
