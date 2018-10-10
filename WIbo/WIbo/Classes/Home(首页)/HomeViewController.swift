//
//  HomeViewController.swift
//  WIbo
//
//  Created by Soul Ai on 21/9/18.
//  Copyright © 2018年 Soul Ai. All rights reserved.


//swift 在忽略文件里把 pod 打开

import UIKit
import SDWebImage
import MJRefresh


class HomeViewController: BaseViewController {
    
     // MARK:- 懒加载属性
    fileprivate lazy var titleBtn : TitleButton = TitleButton()
    
    // 注意:在闭包中如果使用当前对象的属性或者调用方法,也需要加self
    // 两个地方需要使用self : 1> 如果在一个函数中出现歧义 2> 在闭包中使用当前对象的属性和方法也需要加self
    fileprivate lazy var popoverAnimator : PopoverAnimator = PopoverAnimator {[weak self] (presented) in
        self?.titleBtn.isSelected = presented  //一般在等号右边需要强制解包 因为有可能返回 nil
    }
    
    //懒加载数组
    fileprivate lazy var viewModels : [StatusViewModel] = [StatusViewModel]()
    fileprivate lazy var tipLabel : UILabel = UILabel()

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
        
        // 3.设置估算高度
        //        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        //4.布局header
        setupHeaderView()
        setupFooterView()
        
        //5.提示 label
        setupTipLabel()
        
         // 6.监听通知
        setupNatifications()

    }

}

// MARK:- 设置UI界面
extension HomeViewController{
    
    fileprivate func setupNavigationBar(){
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
    
    fileprivate func setupHeaderView() {
        // 1.创建headerView
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNewStatuses))
        // 2.设置header的属性
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放更新", for: .pulling)
        header?.setTitle("加载中...", for: .refreshing)
        // 3.设置tableView的header
        tableView.mj_header = header
        // 4.进入刷新状态
        tableView.mj_header.beginRefreshing()
    }
    
    fileprivate func setupFooterView() {
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreStatuses))
    }
    
    fileprivate func setupTipLabel() {
        // 1.将tipLabel添加父控件中
        navigationController?.navigationBar.insertSubview(tipLabel, at: 0)
         // 2.设置tipLabel的frame
        tipLabel.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 32)
         // 3.设置tipLabel的属性
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.textColor = UIColor.white
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.textAlignment = .center
        tipLabel.isHidden = true
    }
    
    fileprivate func setupNatifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(showPhotoBrowser), name: NSNotification.Name(rawValue: ShowPhotoBrowserNote), object: nil)
    }
}


// MARK:- 事件监听的函数
extension HomeViewController{
    @objc fileprivate func titleBtnClick(titleBth : TitleButton){
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
        // modal弹出控制器
        present(popoverVc, animated: true, completion: nil)
    }
    
    @objc fileprivate func showPhotoBrowser(note : Notification) {
        // 0.取出数据
        let indexPath = note.userInfo?[ShowPhotoBrowserIndexKey] as! IndexPath
        let picURLs = note.userInfo?[ShowPhotoBrowserUrlsKey] as! [URL]
        
        // 1.创建控制器
        let photoBrowserVc = PhotoBrowserController(indexPath: indexPath, picURLs: picURLs)
        
        // 2.以modal的形式弹出控制器
        present(photoBrowserVc, animated: true, completion: nil)
    }

    
    
}

// MARK:- 请求数据
extension HomeViewController {
    
    /// 加载最新的数据
    @objc fileprivate func loadNewStatuses() {
        loadStatuses(true)
    }
    /// 加载更多数据
    @objc fileprivate func loadMoreStatuses() {
        loadStatuses(false)
    }

    
    /// 加载微博数据
    fileprivate func loadStatuses(_ isNewData : Bool) {
        
        // 1.获取since_id/max_id
        var since_id = 0
        var max_id = 0
        if isNewData {
            since_id = viewModels.first?.status?.mid ?? 0
        }else {
            max_id = viewModels.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)  //如果为零取0 否则数据-1 防止重复
        }

        NetworkTools.shareInstance.loadStatuses(since_id, max_id: max_id) { (result, error)  in
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
            var tempViewModel = [StatusViewModel]()
            for statusDict in resultArray {
                let status = Status(dict: statusDict)
                let viewModel = StatusViewModel(status: status)
                tempViewModel.append(viewModel) //将序列的元素添加到数组的末尾
                
            }
            // 4.将数据放入到成员变量的数组中
            if isNewData {
                self.viewModels = tempViewModel + self.viewModels //如果是最新数据
            }else {
                self.viewModels = self.viewModels + tempViewModel
            }
            
            // 5.缓存图片
            self.cacheImages(tempViewModel)
        }
    }
    
    ///缓存图片
    fileprivate func cacheImages(_ viewModels : [StatusViewModel]) {
        // 0.创建group
        let group = DispatchGroup()
        // 1.缓存图片
        for viewmodel in viewModels {
            for picURL in viewmodel.picURLs{
                group.enter()
                SDWebImageManager.shared().loadImage(with: picURL, options: [], progress: nil) { (_, _, _, _, _, _) in  //progress 下载进度
//                    print("下载了一张图片")
                    group.leave()
                }
            }
        }
        // 2.刷新表格
        group.notify(queue: DispatchQueue.main) {
//            print("刷新表格")
            self.tableView.reloadData()
            // 停止刷新
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            // 显示提示的Label
            self.showTipLabel(viewModels.count)
        }
    }
    
    /// 显示提示的Label
    fileprivate func showTipLabel(_ count : Int) {
        // 1.设置tipLabel的属性
        tipLabel.isHidden = false
        tipLabel.text = count == 0 ? "没有新数据" : "\(count) 条微博"
        
        // 2.执行动画
        UIView.animate(withDuration: 1.0, animations: {
            self.tipLabel.frame.origin.y = 44
        }) { (_) in
            UIView.animate(withDuration: 1.0, delay: 1.5, options: [], animations: {//options 开始 回去 慢 快等等枚举设置
                self.tipLabel.frame.origin.y = 10
            }, completion: { (_) in
                self.tipLabel.isHidden = true
            })
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 1.获取模型对象
        let viewModel = viewModels[indexPath.row]
        
        return viewModel.cellHeight
    }
}
