//
//  AlphaPopTransition.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/8/1.
//

import UIKit
import CoreMedia

///右滑屏幕边缘，View滑动退出
class MovePopTransition: NSObject,UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //动画过程中的View容器
        let contanier = transitionContext.containerView

        let to = transitionContext.viewController(forKey: .to)!
        let from = transitionContext.viewController(forKey: .from)!
        
//        to.view.frame = transitionContext.finalFrame(for: to)
//        from.view.frame = transitionContext.finalFrame(for: from)
        //添加到容器中
        contanier.addSubview(to.view)
        contanier.addSubview(from.view)
        //开始过场动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: [.curveEaseOut]) {
            //将view右滑移除屏幕
            from.view.frame.origin.x += ScreenWidth
        } completion: { flag in
            //如果没有取消则完成过场动画
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        
    }
    

}
