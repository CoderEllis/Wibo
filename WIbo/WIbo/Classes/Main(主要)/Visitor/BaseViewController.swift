//
//  BaseViewController.swift
//  WIbo
//
//  Created by Soul Ai on 23/9/18.
//  Copyright © 2018年 Soul Ai. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {

    // MARK:- 懒加载属性
    lazy var visitorView : VisitorView = VisitorView.visitorView()

    // MARK:- 定义变量
    var isLogin : Bool = false
    
    // MARK:- 系统回调函数
    override func loadView(){//如果ture 有登录 会调用 super.loadview  false 调用后面的 setupview
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
    }
}

// MARK:- 设置UI界面
extension BaseViewController{
     /// 设置访客视图
    private func setupVisitorView(){
        view = visitorView
        
        // 监听访客视图中`注册`和`登录`按钮的点击
        visitorView.registerBth.addTarget(self, action: #selector(registerBtnClick), for: .touchUpInside)
        visitorView.loginBth.addTarget(self, action: #selector(loginBtnClick), for: .touchUpInside)
    }
    /// 设置导航栏左右的Item
    private func setupNavigationItems(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(loginBtnClick))
    }
    
}
//MARK:- 事件监听
extension BaseViewController{
    @objc private func registerBtnClick(){
        print("registerBtnClick")
    }
    
    @objc private func loginBtnClick(){
        // 1.创建授权控制器
        let oauthVc = OAuthViewController()
        // 2.包装导航栏控制器
        let oauthNav = UINavigationController(rootViewController: oauthVc)
        // 3.弹出控制器
        present(oauthNav,animated: true,completion: nil)
    }
}

