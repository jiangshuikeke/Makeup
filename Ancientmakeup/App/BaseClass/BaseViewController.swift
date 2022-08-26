//
//  BaseViewController.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/5/7.
//

import UIKit

///响应回退
class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(navBarView)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //生成屏幕边缘拖拽手势
        let pan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panHandler(sender:)))
        //屏幕左侧边缘
        pan.edges = .left
        view.addGestureRecognizer(pan)
        
        //导航Delegate
        navigationController?.delegate = self
    }
    
    // MARK: - 懒加载以及变量
    open lazy var navBarView:NavBarView = {
        let view = NavBarView(title: nil)
        view.delegate = self
        return view
    }()
    
    //如果上一页没有tabbar则不需要进行处理
    public var isPreHasTab:Bool = false
    
    private var precentDrivenTransition:UIPercentDrivenInteractiveTransition?
}

//过场动画以及屏幕拖拽处理
extension BaseViewController:UINavigationControllerDelegate{
    @objc
    func panHandler(sender:UIScreenEdgePanGestureRecognizer){
        //根据移动距离来判断过场动画完成进度
        let progress = sender.translation(in: view).x / ScreenWidth
        
        if sender.state == .began{
            precentDrivenTransition = UIPercentDrivenInteractiveTransition()
            navigationController?.popViewController(animated: true)
        }else if sender.state == .changed{
            precentDrivenTransition?.update(progress)
        }//如果取消了
        else if sender.state == .cancelled || sender.state == .ended{
            if progress > 0.5{
                precentDrivenTransition?.finish()
                if isPreHasTab{
                    hiddenTabbar(isHidden: false, tag: view.tag)
                }
            }else{
                precentDrivenTransition?.cancel()
                if isPreHasTab{
                    hiddenTabbar(isHidden: true, tag: view.tag)
                }
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop{
            return MovePopTransition()
        }else{return nil}
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController is MovePopTransition{
            return precentDrivenTransition
        }else{return nil}
    }
}

extension BaseViewController:NavBarViewDelegate{
    @objc
    func back() {
        if isPreHasTab{
            hiddenTabbar(isHidden: false, tag: view.tag)
        }
        navigationController?.popViewController(animated: true)
    }
}

