//
//  ComposeViewController.swift
//  WIbo
//
//  Created by Soul Ai on 4/10/18.
//  Copyright © 2018年 Soul Ai. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    // MARK:- 控件属性
    @IBOutlet weak var textView: ComposeTextView!
    @IBOutlet weak var picPickerView: PicPickerCollectionView!
    
    // MARK:- 懒加载属性
    fileprivate lazy var titleView : ComposeTitleView = ComposeTitleView()
    fileprivate lazy var images : [UIImage] = [UIImage]()
    
    
    // MARK:- 约束的属性
    /// 工具条底部约束
    @IBOutlet weak var toolBarButtomCons: NSLayoutConstraint!
    @IBOutlet weak var picPicerViewHCons: NSLayoutConstraint!
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置导航栏
        setupNavigationBar()
        // 监听通知
        setupNotifications()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {//进入让键盘弹出
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder()
    }
    deinit {//移除通知
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK:- 设置UI界面
extension ComposeViewController {
    fileprivate func setupNavigationBar() {
         // 1.设置左右的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(closeItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(sendItemClick))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        // 2.设置标题
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
    }
    
    fileprivate func setupNotifications() {
        // 监听键盘的弹出
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
         // 监听添加照片的按钮的点击
        NotificationCenter.default.addObserver(self, selector: #selector(addPhotoClick), name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
        
        // 监听删除照片的按钮的点击
        NotificationCenter.default.addObserver(self, selector: #selector(removePhotoClick(_:)), name: NSNotification.Name(rawValue: PicPickerRemovePhotoNote), object: nil)
    }
}

// MARK:- 事件监听函数
extension ComposeViewController {
    @objc fileprivate func closeItemClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func sendItemClick() {
        print("sendItemClick")
    }
    
    @objc fileprivate func keyboardWillChangeFrame(_ note : Notification) {
        // 1.获取动画执行的时间
//        print(note.userInfo!)
        let duration = note.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        // 2.获取键盘最终Y值
        let endFrame = (note.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        
        // 3.计算工具栏距离底部的间距
        let margin = UIScreen.main.bounds.height - y
        
        // 4.执行动画
        toolBarButtomCons.constant = margin
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func picPickerBtnClick() {
        // 退出键盘
        textView.resignFirstResponder()
        // 执行动画
        picPicerViewHCons.constant = UIScreen.main.bounds.height * 0.65
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
        
    }
}

// MARK:- 添加照片和删除照片的事件
extension ComposeViewController {
    @objc fileprivate func addPhotoClick() {
        // 1.判断数据源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            return
        }
        
        // 2.创建照片选择控制器
        let ipc = UIImagePickerController()
        
        // 3.设置照片源
        ipc.sourceType = .photoLibrary
        // 4.设置代理
        ipc.delegate = self
        
        // 弹出选择照片的控制器
        present(ipc, animated: true, completion: nil)
    }
    
    @objc fileprivate func removePhotoClick(_ note : Notification) {
        // 1.获取image对象
        guard let image = note.object as? UIImage else {
            return
        }
        // 2.获取image对象所在下标值
        guard let index = images.index(of: image) else {
            return
        }
        // 3.将图片从数组删除
        images.remove(at: index)
        
        // 4.重写赋值collectionView新的数组
        picPickerView.images = images
    }
}

// MARK:- UIImagePickerController的代理方法
extension ComposeViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 1.获取选中的照片
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        // 2.展示照片
        images.append(image)
        // 3.将数组赋值给collectionView,让collectionView自己去展示数据
        picPickerView.images = images
        
        // 4.退出选中照片控制器
        picker.dismiss(animated: true, completion: nil)
    }
}



//scroolview  监听滚动打开Bounce Vertically
// MARK:- UITextView的代理方法
extension ComposeViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        //输出文字监听
        self.textView.placeHolderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    //textview 滚动监听
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}
