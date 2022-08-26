//
//  VisionManager.swift
//  CoreImageTest
//
//  Created by 陈沈杰 on 2022/7/29.
//

import Foundation
import Vision
import UIKit
import CoreImage.CIFilterBuiltins

///使用Vision来进行人脸探测
class VisionManager{
//    let shared:VisionManager = VisionManager()
    init(){
        //初始化的时候直接处理人脸请求
    }
    
    //MARK: - 懒加载以及变量
    
    //请求
    private lazy var request:VNDetectFaceLandmarksRequest = {
        let request = VNDetectFaceLandmarksRequest()
        //修改Vision中的探测算法
        request.revision = VNDetectFaceLandmarksRequestRevision3
        request.constellation = VNRequestFaceLandmarksConstellation.constellation76Points
        return request
    }()
    
    //五官探测的偏移量
    private let organsOffset:CGFloat = 50
    //人脸偏移量
    private let faceOffset:CGFloat = 200
    private var originalImage:CGImage?
    private var originalSize:CGSize?
    private var boundingBox:CGRect?
    private var fitImageRect:CGRect?
    private var currentOrientation:CGImagePropertyOrientation?
    
    //图像分类器
//    private static let imageClassifier = 
    
    private var predictionHandlers = [VNRequest:ImagePredictionHandler]()
    //人脸检测请求
    private lazy var faceRequest:VNDetectFaceRectanglesRequest = {
        let request = VNDetectFaceRectanglesRequest()
        request.revision = VNDetectFaceRectanglesRequestRevision3
        return request
    }()
    //人物分割请求
    private lazy var segmentationRequest:VNGeneratePersonSegmentationRequest = {
        let request = VNGeneratePersonSegmentationRequest()
        //设置探测的精度
        request.qualityLevel = .balanced
        request.outputPixelFormat = kCVPixelFormatType_OneComponent8
        return request
    }()
    //序列请求
    private var requestHandler = VNSequenceRequestHandler()
    //用来存储五官的面积
    private lazy var organsArea = [CGFloat]()
    private lazy var faceArea:CGFloat = 1
}

//MARK: - 人脸相关
extension VisionManager{
    //处理拍摄的照片,背景模糊处理
    func personSegmentation(in cgImage:CGImage,orientation:CGImagePropertyOrientation?) -> CIImage?{
        //使用前置镜头拍摄出来的照片使用镜像处理
        if orientation != nil{
            try? requestHandler.perform([faceRequest,segmentationRequest], on: cgImage,orientation: orientation!)
        }else{
            try? requestHandler.perform([faceRequest,segmentationRequest], on: cgImage)
        }
        
        
        //获取人像的蒙版数据流，这样操作可以将原始图像中的人像扣出来
        //蒙版是除了人物图像以外的背景图
        guard let maskPixelBuffer = segmentationRequest.results?.first?.pixelBuffer else{
            print("未获得人像分割的结果")
            return nil
        }
        
        var fixedImage:CIImage = CIImage(cgImage: cgImage)
        if orientation != nil{
            fixedImage = CIImage(cgImage: cgImage).oriented(orientation!)
        }
        
        //获取截取人像后的图片
        return blend(original: fixedImage, mask: maskPixelBuffer)
    }
    
    //根据原始图像以及ImageView来进行五官点位的适配
    func visionFaceLandmark(cgImage:CGImage,orientation:CGImagePropertyOrientation?)-> FaceLandmark?{
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request,faceRequest])
        let observations = request.results?.first
        //获取当前人脸的bounds 该数据是比例
        let landmark2D = observations?.landmarks
        originalSize = CGSize(width: cgImage.width, height: cgImage.height)
        guard let boundingBox = observations?.boundingBox else{
            print("无法获取boundingBox")
            return nil
        }
        self.boundingBox = boundingBox
        
        //存储变量并且保证了每一个变量都不为nil
        originalImage = cgImage
        currentOrientation = orientation
        //五官的位置是以boundingBox为坐标系的
        //获取五官实例子
        guard let nose = landmark2D?.nose,
              let eye = landmark2D?.rightEye,
              let eyebrow = landmark2D?.rightEyebrow,
              let mouth = landmark2D?.outerLips,
              let leftEye = landmark2D?.leftEye,
              let leftEyebrow = landmark2D?.leftEyebrow,
              let rightEyebrow = landmark2D?.rightEyebrow
            else{
            print("一些五官无法检测")
            return nil
        }

        //存储到实体类中
        
        let res = FaceLandmark()
        let noseImage = organsImage(in: nose.pointsInImage(imageSize: originalSize!))
        let eyeImage = organsImage(in: eye.pointsInImage(imageSize: originalSize!))
        let eyebrowImage = organsImage(in: eyebrow.pointsInImage(imageSize: originalSize!))
        let mouthImage = organsImage(in: mouth.pointsInImage(imageSize: originalSize!))
        let leftEyeImage = organsImage(in: leftEye.pointsInImage(imageSize: originalSize!))
        let leftEyebrowImage = organsImage(in: leftEyebrow.pointsInImage(imageSize: originalSize!))
        
        res.leftEye = Organs(image: leftEyeImage.0!, cgImage: leftEyeImage.1!)
        res.leftEyebrow = Organs(image: leftEyebrowImage.0!, cgImage: leftEyebrowImage.1!)
        res.mouth = Organs(image: mouthImage.0!,cgImage: mouthImage.1!)
        res.mouth?.type = .mouth
        res.eyebrow = Organs(image: eyebrowImage.0!,cgImage: eyebrowImage.1!)
        res.eyebrow?.type = .eyebrow
        res.nose = Organs(image: noseImage.0!,cgImage: noseImage.1!)
        res.nose?.type = .nose
        res.eye = Organs(image: eyeImage.0!,cgImage: eyeImage.1!)
        res.eye?.type = .eye
        let faceImage = faceImage()
        res.face = Organs(image:faceImage.0!,cgImage: faceImage.1!)
        res.face?.type = .face
        //计算五官量感
        countQuantity(landmark: res)
        //预测五官属于什么类型
        integratePrediction(landmark: res)
        return res
    }
    
    ///人脸数量探测
    func numberOfFace(cgImage:CGImage) -> NSInteger{
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try?handler.perform([faceRequest])
        
        return faceRequest.results?.count ?? 0
    }
}

//MARK: - 图像分类有关
extension VisionManager{
    typealias ImagePredictionHandler = (_ prediction:[Prediction]?) -> Void
    
    
    //返回指定五官Model
    static func createImageClassifier(type:OrgansType) -> VNCoreMLModel?{
        let configuration = MLModelConfiguration()
        var model:MLModel = MLModel()
        switch type {
        case .eye:
            let classifierWrapper = try?EyeClassifer(configuration: configuration)
            guard let classifier = classifierWrapper else{
                return nil
            }
            model = classifier.model
        case .eyebrow:
            let classifierWrapper = try?EyebrowClassifier(configuration: configuration)
            guard let classifier = classifierWrapper else{
                return nil
            }
            model = classifier.model
        case .nose:
            let classifierWrapper = try?NoseClassifier(configuration: configuration)
            guard let classifier = classifierWrapper else{
                return nil
            }
            model = classifier.model
        case .mouth:
            let classifierWrapper = try?MouthClassifier(configuration: configuration)
            guard let classifier = classifierWrapper else{
                return nil
            }
            model = classifier.model
        case .face:
            let classifierWrapper = try?FaceClassifier(configuration: configuration)
            guard let classifier = classifierWrapper else{
                return nil
            }
            model = classifier.model
            fallthrough
        default:
            break
        }
        
        guard let visionModel = try? VNCoreMLModel(for: model) else{
            print("App 创建coreMLModel实例失败")
            return nil
        }
        
        return visionModel
    }
    
    //预测
    func predict(for cgImage:CGImage,type:OrgansType,completion:@escaping ImagePredictionHandler){
//        guard let cgImage = image.cgImage else{
//            print("图像没有底层的CGImage")
//            return
//        }
        //创建对应的分类请求
        let classifierRequest = createClassificationRequest(type: type)
        //将该用户对预测后的handler加入到全局变量中
        predictionHandlers[classifierRequest] = completion
        
        //生成处理
        let handler = VNImageRequestHandler(cgImage: cgImage, orientation:currentOrientation!)
        let request = [classifierRequest]
        
        //开启图像分类请求，并且对于获取到的结果会通过block将数据发送给用户
        try? handler.perform(request)
    }
    
    //生成图像分类请求
    private func createClassificationRequest(type:OrgansType) -> VNImageBasedRequest{
        let classificationRequest = VNCoreMLRequest(model:VisionManager.createImageClassifier(type: type)! ,completionHandler: visionRequestHandler)
        
        classificationRequest.imageCropAndScaleOption = .centerCrop
        return classificationRequest
    }
    
    //对于开启请求后的处理，将预测数据传递给用户
    private func visionRequestHandler(_ request:VNRequest,error:Error?)
    {
        guard let handler = predictionHandlers.removeValue(forKey: request)else{
            print("每一个请求都必须有一个预测处理")
            return
        }
        
        //预测结果
        var predictions:[Prediction]? = nil
        
        //延迟处理用户的handler 目的是为了防止在预测中出现错误，将nil推送给用户
        defer{
            handler(predictions)
        }
        
        if let error = error {
            print("Vision image classification error...\n\n\(error.localizedDescription)")
            return
        }
        
        if request.results == nil{
            print("Vision request had no results.")
            return
        }
        
        //获取观察的结果
        guard let observations = request.results as? [VNClassificationObservation] else {
            // Image classifiers, like MobileNet, only produce classification observations.
            // However, other Core ML model types can produce other observations.
            // For example, a style transfer model produces `VNPixelBufferObservation` instances.
            print("VNRequest produced the wrong result type: \(type(of: request.results)).")
            return
        }
        
        //预测结果整合 最后通过defer延迟推送给用户
        predictions = observations.map({ observation in
            Prediction(classification: observation.identifier, confidencePercentage: observation.confidence.description)
        })
    }
}

//MARK: - 私有方法
private extension VisionManager{
    ///模糊化背景
    func blend(original:CIImage,mask:CVPixelBuffer) -> CIImage?{
        //获取Colors，这些根据人物背景色的偏移计算出来的背景颜色
//        guard let colors = colors else{ return }
        
        //生成蒙版图像
        var maskImage = CIImage(cvPixelBuffer: mask)

        //蒙版大小与原始图像存在偏差需要scale
        let scaleX = original.extent.width / maskImage.extent.width
        let scaleY = original.extent.height / maskImage.extent.height
        maskImage = maskImage.transformed(by: .init(scaleX: scaleX, y: scaleY))
        
        //Define RGB vectors for CIColorMatrix filter.
        //在demo里面使用的是与背景色相匹配的颜色
        //这里使用华妆应用的背景色
        let vectors = [
            "inputRVector" : CIVector(x: 0, y: 0, z: 0, w: SkinColor.redValue),
            "inputGVector" : CIVector(x: 0, y: 0, z: 0, w: SkinColor.greenValue),
            "inputBVector" : CIVector(x: 0, y: 0, z: 0, w: SkinColor.blueValue)
        ]
        
        let backgroundImage = maskImage.applyingFilter("CIColorMatrix",parameters: vectors)
        
        let blendFilter = CIFilter.blendWithRedMask()
        blendFilter.maskImage = maskImage
        blendFilter.backgroundImage = backgroundImage
        blendFilter.inputImage = original
        let outputImage = blendFilter.outputImage
        return outputImage
    }
    ///获取人脸图像
    func faceImage() -> (UIImage?,CGImage?){
        let observation = faceRequest.results?.first!
        let imageSize = CGSize(width: originalImage!.width, height: originalImage!.height)
//        let offsetRation = faceOffset / imageSize.width
        let offsetBundingBox = observation?.boundingBox
//        offsetBundingBox?.origin.x -= offsetRation
//        offsetBundingBox?.origin.y -= offsetRation
//        offsetBundingBox?.size.width += 2 * offsetRation
//        offsetBundingBox?.size.height += 2 * offsetRation
        //获取脸部rect
        let faceRect = convertRect(bounds: offsetBundingBox!, imageSize: imageSize)
        let cgFace = originalImage!.cropping(to: faceRect)
        guard let cgFace = cgFace else{
            print("无法生成脸型")
            return (nil,nil)
        }
        var ciFace = CIImage(cgImage: cgFace)
        if currentOrientation != nil{
            ciFace = ciFace.oriented(currentOrientation!)
        }
        return (UIImage(ciImage: ciFace),cgFace)
    }
    ///获取五官的图像
    func organsImage(in points:[CGPoint]) -> (UIImage?,CGImage?){
        //用矩形截取该五官的区域
        let organsRect = rectFromLandmarkPoints(points: points)
        let organsImage = originalImage!.cropping(to: organsRect)
        guard let organsImage = organsImage else{
            print("无法截出五官图像")
            return (nil,nil)
        }
        //生成图像
        var ciImage = CIImage(cgImage: organsImage)
        if currentOrientation != nil{
            ciImage = ciImage.oriented(currentOrientation!)
        }
        return (UIImage(ciImage: ciImage),organsImage)
    }
    
    ///整合预测的分析预测
    func integratePrediction(landmark:FaceLandmark){
        predict(for: landmark.face!.cgImage!, type: .face) { prediction in
            guard let prediction = prediction else{
                return
            }

            let fit = prediction.max {$0.confidencePercentage < $1.confidencePercentage}
            landmark.face?.name = fit?.classification
            var outline = 0
            switch fit?.classification{
            case "方形脸","长形脸":
                //直
                outline = 1
                break
            case "圆脸":
                //曲
                outline = -1
                break
            case "菱形脸":
                //中
                outline = 0
                break
            default:
                break
            }
            landmark.outline = outline
        }
        
        predict(for: landmark.mouth!.cgImage!, type: .mouth) { prediction in
            guard let prediction = prediction else{
                return
            }

            let fit = prediction.max {$0.confidencePercentage < $1.confidencePercentage}
            landmark.mouth?.name = fit?.classification
        }
        
        predict(for: landmark.eyebrow!.cgImage!, type: .eyebrow) { prediction in
            guard let prediction = prediction else{
                return
            }

            let fit = prediction.max {$0.confidencePercentage < $1.confidencePercentage}
            landmark.eyebrow?.name = fit?.classification
        }
        
        predict(for: landmark.nose!.cgImage!, type: .nose) { prediction in
            guard let prediction = prediction else{
                return
            }

            let fit = prediction.max {$0.confidencePercentage < $1.confidencePercentage}
            landmark.nose?.name = fit?.classification
        }
        
        predict(for: landmark.eye!.cgImage!, type: .eye) { prediction in
            guard let prediction = prediction else{
                return
            }

            let fit = prediction.max {$0.confidencePercentage < $1.confidencePercentage}
            landmark.eye?.name = fit?.classification
        }
        
    }
    
    //计算脸部量感
    func countQuantity(landmark:FaceLandmark){
        //reduce 选择第一个元素为初始并且将所有元素相加
        let sum = organsArea.reduce(0,+)
        landmark.quantity = sum / faceArea
    }
    
    ///原始图像中检测出人脸的bounds该boundingBox返回的是一个比例，所以添加在imageview的时候可以正好框出人脸
    func convertRect(bounds:CGRect,imageSize:CGSize,isCountFaceArea:Bool = true) -> CGRect{
        let width = bounds.width * imageSize.width
        let height = bounds.height * imageSize.height
        //计算脸部大小
        if isCountFaceArea{
           faceArea = width * height
        }
        let x = bounds.origin.x * imageSize.width
        let y = (1 - bounds.origin.y - bounds.height) * imageSize.height
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    ///转化五官点
    func converPoint(point:CGPoint,bounds:CGRect,imageSize:CGSize,contentOffset:CGPoint) -> CGPoint{
        //首先要找到boundingBox在image中的位置，再去找到相应五官的点位
        var point = CGPoint(x:imageSize.width * (bounds.origin.x + bounds.width * point.x), y: (1 - bounds.origin.y - bounds.height) * imageSize.height + bounds.height * imageSize.height * (1 - point.y))
        if contentOffset.y > 0{
            point.y += contentOffset.y
        }
        if contentOffset.x > 0{
            point.x += contentOffset.x
        }
        return point
    }
    
    ///ImageView会将Image长宽适配
    func fitImageViewSize(imageViewRect:CGRect,imageSize:CGSize) -> CGRect{
        let widthRatio = imageViewRect.width / imageSize.width
        let heightRatio = imageViewRect.height / imageSize.height
        let ratio = min(widthRatio, heightRatio)
        
        let width = round(imageSize.width * ratio)
        let height = round(imageSize.height * ratio)
        let x = imageViewRect.origin.x + (imageViewRect.width - width) / 2.0
        let y = imageViewRect.origin.y + (imageViewRect.height - height) / 2.0
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    ///根据五官的点来获取五官的区域
    func rectFromLandmarkPoints(points:[CGPoint]) -> CGRect{
        //1.找出四个顶点位置
        let minX = points.min {$0.x < $1.x}!
        let maxX = points.max {$0.x < $1.x}!
        let minY = points.min {$0.y < $1.y}!
        let maxY = points.max {$0.y < $1.y}!
        //计算原始宽高
        let originalWidth = maxX.x - minX.x
        let originalHeight = maxY.y - minY.y + 2
        let area = originalWidth * originalHeight
        //存储
        organsArea.append(area)
        //2.计算偏移的宽高，用来显示
        let width = originalWidth + 2 * organsOffset
        let height = originalHeight + 2 * organsOffset
        
        return CGRect(x:minX.x - organsOffset, y:originalSize!.height - maxY.y - organsOffset, width: width, height: height)
    }
}

struct Prediction{
    //分类名称
    let classification:String
    //置信度
    let confidencePercentage:String
}
