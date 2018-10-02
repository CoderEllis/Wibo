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
    
    //懒加载数组
    private lazy var viewModels : [StatusViewModel] = [StatusViewModel]()

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
        
        //3.请求数据
        loadStatuses()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
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
        let x = Int(UIScreen.main.bounds.size.width * 0.5 - 90)
        //状态栏 + 导航栏
        let y = Int(UIApplication.shared.statusBarFrame.size.height + navigationController!.navigationBar.frame.size.height)
        popoverAnimator.presentedFrame = CGRect(x: x, y: y, width: 180, height: 250)
        // 弹出控制器
        present(popoverVc, animated: true, completion: nil)
    }
}

// MARK:- 请求数据
extension HomeViewController {
    private func loadStatuses() {
        NetworkTools.shareInstance.loadStatuses { (result, error) in
            // 1.错误校验
            if error != nil {
                print(error!)
                return
            }
            // 2.获取可选类型中的数据
            guard let resultArray = result else {
                return
            }
            // 3.遍历微博对应的字典
            for statusDict in resultArray {
                let status = Status(dict: statusDict)
                let viewModel = StatusViewModel(status: status)
                self.viewModels.append(viewModel) //将序列的元素添加到数组的末尾
                
            }
            // 4.刷新表格
            self.tableView.reloadData()
            
        }
    }
}

// MARK:- tableView的数据源方法
extension HomeViewController { //swift 不需要遵守协议 UITableViewDelegate, UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 1.创建cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeViewCell
        
        // 2.给cell设置数据
        cell.viewModel = viewModels[indexPath.row]
        
        return cell
    }
}
