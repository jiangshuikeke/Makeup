//
//  SceneDelegate.swift
//  Ancientmakeup
//
//  Created by 陈沈杰 on 2022/4/15.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        registerNotification()
        guard let s = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = s
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        print("应用活性")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        print("应用失活性")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        print("应用进入前台")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        print("应用进入后台")
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: SwitchRootViewControllerNotification, object: nil)
    }
    
    //MARK: - 懒加载以及变量
    var rootViewController:UIViewController {
        let login = UserDefaults.standard.bool(forKey: "isLogin")
        if login{
            return MainViewController()
        }else{
            UserDefaults.standard.set(true, forKey: "isLogin")
            return NavViewController()
        }
    }

}

extension SceneDelegate{
    ///注册通知用于切换视图
    func registerNotification(){
        NotificationCenter.default.addObserver(forName: SwitchRootViewControllerNotification, object: nil, queue: nil) { [weak self] notification in
            self?.window?.rootViewController = MainViewController()
        }
    }
}

