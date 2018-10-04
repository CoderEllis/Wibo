//
//  WelcomeViewController.swift
//  WIbo
//
//  Created by Soul Ai on 28/9/18.
//  Copyright © 2018年 Soul Ai. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {
    //MARK:- 脱线属性
    @IBOutlet weak var iconViewButtomCons: NSLayoutConstraint!
    @IBOutlet weak var iconView: UIImageView!
    
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        // 0.设置头像
        let profileURLString = UserAccountViewModel.shareIntance.account?.avatar_large
        loadViewIfNeeded()
        // ?? : 如果??前面的可选类型有值,那么将前面的可选类型进行解包并且赋值
        // 如果??前面的可选类型为nil,那么直接使用??后面的值
        let url = URL(string: profileURLString ?? "")
        iconView.sd_setImage(with: url, placeholderImage: UIImage(named:"avatar_default_big"))

        // 1.改变约束的值
        iconViewButtomCons.constant = UIScreen.main.bounds.height - 200
  
        // 2.执行动画
        // Damping : 阻力系数,阻力系数越大,弹动的效果越不明显 0~1
        // initialSpringVelocity : 初始化速度
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 5.0, options: [], animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
    
    }
}
