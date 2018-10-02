//
//  OAuthViewController.swift
//  WIbo
//
//  Created by Soul Ai on 26/9/18.
//  Copyright © 2018年 Soul Ai. All rights reserved.
//

import UIKit
import SVProgressHUD

class  OAuthViewController: UIViewController {
    // MARK:- 控件的属性
    @IBOutlet weak var webView: UIWebView!

    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.设置导航栏的内容
        setupNavigationBar()
        // 2.加载网页
        loadPage()
//        webView.loadRequest(URLRequest(url: URL(string: "https://www.baidu.com/")!)) //var 可选 !要解包
    }

}

// MARK:- 设置UI界面相关
extension OAuthViewController{
    private func setupNavigationBar(){
        // 1.设置左侧的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(closeItemClick))
        // 2.设置右侧的item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(fillItemClick))
        // 3.设置标题
        title = "登录页面"
    }
    
    private func loadPage() {
        // 1.获取登录页面的URLString
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"
        
        // 2.创建对应URL
        guard let url = URL(string: urlString) else {
            return
        }
        
        // 3.创建URLRequest对象
        let request = URLRequest(url: url)
        // 4.加载request对象
        webView.loadRequest(request)
    }
}

// MARK:- 事件监听函数
extension OAuthViewController{
    @objc private func closeItemClick() {
        dismiss(animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }
    @objc private func fillItemClick() {
        // 1.书写js代码 : javascript / java --> 雷锋和雷峰塔
        let jsCode = "document.getElementById('userId').value='15019890173';document.getElementById('passwd').value='Qq5745432';"
        // 2.执行js代码
        webView.stringByEvaluatingJavaScript(from: jsCode)
    }
}

// MARK:- webView的delegate方法  xib 拖线
extension OAuthViewController : UIWebViewDelegate {
    // webView开始加载网页
    func webViewDidStartLoad(_ webView : UIWebView){
        SVProgressHUD.show()
    }
    // webView网页加载完成
    func webViewDidFinishLoad(_ webView : UIWebView) {
        SVProgressHUD.dismiss()
    }
    // webView加载网页失败
    func webView(_ webView : UIWebView, didFailLoadWithError error : Error) {
        SVProgressHUD.dismiss()
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        // 1.获取加载网页的URL
        guard let url = request.url else {
            return true
        }
        // 2.获取url中的字符串
        let urlString = url.absoluteString
        
        // 3.判断该字符串中是否包含code
        guard urlString.contains("code=") else {
            return true
        }
        // 4.将code截取出来
        let code = urlString.components(separatedBy: "code=").last!

        // 5.请求accessToken
        loadAccessToken(code: code)
        
        return false
    }
}

// MARK:- 请求数据
extension OAuthViewController{
    /// 请求AccessToken
    private func loadAccessToken(code : String) {
        /// 请求AccessToken
        NetworkTools.shareInstance.loadAccessToken(code: code) { (result, error) in
            // 1.错误校验
            if error != nil {
                print(error!)
                return
            }
            
            // 2.拿到结果
            guard let accountDict = result else {
                print("没有获取授权后的数据")
                return
            }

            // 3.将字典转成模型对象
            let account = UserAccount(dict: accountDict as [String : AnyObject])
           
            
            // 4.请求用户信息
            self.loadUserInfo(account: account)
        }
    }
    /// 请求用户信息
    private func loadUserInfo(account : UserAccount) {
        // 1.获取AccessToken
        guard let accessToken = account.access_token else {
            return
        }
        // 2.获取uid
        guard let uid = account.uid else {
            return
        }
        // 3.发送网络请求
        NetworkTools.shareInstance.loadUserInfo(access_token: accessToken, uid: uid) { (result, error) in
            // 1.错误校验
            if error != nil {
                print(error!)
                return
            }
            // 2.拿到用户信息的结果
            guard let userInfoDict = result else {
                return
            }
            // 3.从字典中取出昵称和用户头像地址
            account.screen_name = userInfoDict["screen_name"] as? String
            account.avatar_large = userInfoDict["avatar_large"] as? String
            
            // 4.将account对象保存
//            // 4.1.获取沙盒路径
//            var accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//            accountPath = (accountPath as NSString).appendingPathComponent("accout.plist")
            
            // 4.保存对象到沙盒
            NSKeyedArchiver.archiveRootObject(account, toFile: UserAccountViewModel.shareIntance.accountPath)
            
            // 5.将account对象设置到单例对象中  
            UserAccountViewModel.shareIntance.account = account
            
            // 6.退出当前控制器
            self.dismiss(animated: false, completion: {
                UIApplication.shared.keyWindow?.rootViewController = WelcomeViewController()
            })
        } 
    }
}

