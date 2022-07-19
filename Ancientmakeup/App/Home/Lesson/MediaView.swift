//
//  MediaView.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/7/5.
//

import UIKit
import AVFoundation
class MediaView: UIView {
    
    convenience init(path:String) {
        self.init(frame: CGRect(origin: .zero, size: CGSize(width: 265, height: 170)))
        self.path = path
        initView()
    }
    
    //MARK: - 懒加载以及变量
    var path:String?
    private var isPlay:Bool = false
    
    ///数据流控制器
    private lazy var player:AVPlayer = {
        if let filePath = path{
            let url = URL(fileURLWithPath: filePath)
            let item = AVPlayerItem(url: url)
            let player = AVPlayer(playerItem:item)
            player.rate = 1
            player.pause()
            return player
        }
        return AVPlayer()
    }()
    
    ///UI展示图层
    private lazy var playerLayer:AVPlayerLayer = {
        let layer = AVPlayerLayer(player: player)
        layer.cornerRadius = 30
        layer.masksToBounds = true
        var new = bounds
        new.origin.x += 10
        new.size.width -= 20
        new.origin.y += 5
        new.size.height -= 10
        layer.frame = new
        return layer
    }()
    
    private lazy var pauseButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "pause"), for: .normal)
        button.addTarget(self, action: #selector(beginPlay), for: .touchUpInside)
        return button
    }()

}

//MARK: - UI
extension MediaView{
    func initView(){
        let blurView = blurView(radius: 20)
        addSubview(blurView)
        blurView.contentView.layer.addSublayer(playerLayer)
        addSubview(pauseButton)
        blurView.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(beginPlay)))
        initLayout()
    }
    
    func initLayout(){
        pauseButton.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.height.width.equalTo(45)
        }
    }
}

//MARK: - 按键事件
extension MediaView{
    @objc
    func beginPlay(){
        if !isPlay{
            player.play()
        }else{
            player.pause()
        }
        isPlay = !isPlay
        pauseButton.isHidden = isPlay
    }
}
