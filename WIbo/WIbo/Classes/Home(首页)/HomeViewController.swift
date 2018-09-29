//
//  HomeViewController.swift
//  WIbo
//
//  Created by Soul Ai on 21/9/18.
//  Copyright © 2018年 Soul Ai. All rights reserved.


//swift 在忽略文件里把 pod 打开

import UIKit

class HomeViewController: BaseViewController {
    
     // MARK:- 懒加载属性
    private lazy var titleBtn : TitleButton = TitleButton()
    
    // 注意:在闭包中如果使用当前对象的属性或者调用方法,也需要加self
    // 两个地方需要使用self : 1> 如果在一个函数中出现歧义 2> 在闭包中使用当前对象的属性和方法也需要加self
    private lazy var popoverAnimator : PopoverAnimator = PopoverAnimator {[weak self] (presented) in
        self?.titleBtn.isSelected = presented  //一般在等号右边需要强制解包 因为有可能返回 nil
    }

    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.没有登录时设置的内容
        visitorView.addRotationAnim()
        if !isLogin{
            return
        }
        
        // 2.设置导航栏的内容
        setupNavigationBar()
    }

}

// MARK:- 设置UI界面
extension HomeViewController{
    
    private func setupNavigationBar(){
        /*
        let leftBtn = UIButton()
        leftBtn.setImage(UIImage (named: "navigationbar_friendattention"), for: .normal)
        leftBtn.setImage(UIImage (named: "navigationbar_friendattention_highlighted"), for: .highlighted)
        leftBtn.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        */
        
        //2.设置左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        //3.设置标题
        titleBtn.setTitle("coderID", for: .normal)
        titleBtn.addTarget(self, action: #selector(titleBtnClick(titleBth:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
}
// MARK:- 事件监听的函数
extension HomeViewController{
    @objc private func titleBtnClick(titleBth : TitleButton){
        // 1.改变按钮的状态
//        titleBth.isSelected = !titleBth.isSelected
        
        // 2.创建弹出的控制器
        let popoverVc = PopoverViewController()
//        popoverVc.view.backgroundColor = UIColor.red
        
        // 3.设置控制器的modal样式
        popoverVc.modalPresentationStyle = .custom
        
        // 4.设置转场的代理
        popoverVc.transitioningDelegate = popoverAnimator
        popoverAnimator.presentedFrame = CGRect(x: 100, y: 100, width: 180, height: 250)
        
        // 弹出控制器
        present(popoverVc, animated: true, completion: nil)
    }
}

