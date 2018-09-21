//
//  MainViewController.swift
//  WIbo
//
//  Created by Soul Ai on 21/9/18.
//  Copyright © 2018年 Soul Ai. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(childVc: HomeViewController(), title: "首页", imageName: "tabbar_home")
        addChild(childVc: MessageViewController(), title: "消息", imageName: "tabbar_message_center")
        addChild(childVc: DiscoverViewController(), title: "发现", imageName: "tabbar_profile")
        addChild(childVc: ProfileViewController(), title: "我", imageName: "tabbar_discover")
        //
        
//        //创建子控制器
//        let childVc = HomeViewController()
//        childVc.title = "首页"
//        childVc.tabBarItem.image = UIImage(named: "tabbar_home")
//        childVc.tabBarItem.selectedImage = UIImage(named: "tabbar_home_highlighted")
//        //包装导航控制器
//        let childNav = UINavigationController(rootViewController: childVc)
//        addChild(childNav)
        
    }
    // swift支持方法的重载
    // 方法的重载:方法名称相同,但是参数不同. --> 1.参数的类型不同 2.参数的个数不同
    // private在当前文件中可以访问,但是其他文件不能访问
    private func addChild(childVc: UIViewController, title :String, imageName:String) {

        // 设置子控制器的属性
        childVc.title = title
        childVc.tabBarItem.image = UIImage(named: imageName)
        childVc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        
        //包装导航控制器
        let childNav = UINavigationController(rootViewController: childVc)
        
        addChild(childNav)
    }



}
