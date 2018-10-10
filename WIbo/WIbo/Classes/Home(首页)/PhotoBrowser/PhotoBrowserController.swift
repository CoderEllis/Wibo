//
//  PhotoBrowserController.swift
//  WIbo
//
//  Created by Soul Ai on 10/10/18.
//  Copyright © 2018年 Soul Ai. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD


fileprivate let PhotoBrowserCell = "PhotoBrowserCell"

class PhotoBrowserController: UIViewController {

    // MARK:- 定义属性
    var indexPath : IndexPath
    var picURLs : [URL]
    
    // MARK:- 懒加载属性
    fileprivate lazy var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBrowserCollectionViewLayout())
    fileprivate lazy var closeBtn : UIButton = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "关 闭")
    fileprivate lazy var saveBtn : UIButton = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "保 存")
    
    
    // MARK:- 自定义构造函数
    init(indexPath : IndexPath, picURLs : [URL]) {
        self.indexPath = indexPath
        self.picURLs = picURLs
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 系统回调函数
    override func loadView() {
        super.loadView()
        
        view.frame.size.width += 20
    }
    
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.设置UI界面
        setupUI()
        
        //2 滚动到对应的页面
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}

// MARK:- 设置UI界面内容
extension PhotoBrowserController {
    fileprivate func setupUI() {
        // 1.添加子控件
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        // 2.设置frame
        collectionView.frame = view.bounds
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        saveBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.bottom.equalTo(closeBtn.snp.bottom)
            make.size.equalTo(closeBtn.snp.size)
        }
        // 3.设置collectionView的属性
        collectionView.register(PhotoBrowserViewCell.self, forCellWithReuseIdentifier: PhotoBrowserCell)
        collectionView.dataSource = self
        
        // 4.监听两个按钮的点击
        closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(saveBthClick), for: .touchUpInside)
    }
}

// MARK:- 事件监听函数
extension PhotoBrowserController {
    @objc fileprivate func closeBtnClick() {
        dismiss(animated: true, completion: nil)
    }
    @objc fileprivate func saveBthClick() {
        // 1.获取当前正在显示的image
        let cell = collectionView.visibleCells.first as! PhotoBrowserViewCell
        guard let image = cell.imageview.image else {
            return
        }
//  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
        
        // 2.将image对象保存相册
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(PhotoBrowserController.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc fileprivate func image(_ image : UIImage, didFinishSavingWithError error : Error?, contextInfo : Any) {
        var showInfo = ""
        if error != nil {
            showInfo = "保存失败"
        }else {
            showInfo = "保存成功"
        }
        
        SVProgressHUD.showInfo(withStatus: showInfo)
    }
    
}


// MARK:- 实现collectionView的数据源方法
extension PhotoBrowserController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return picURLs.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserCell, for: indexPath) as! PhotoBrowserViewCell
//        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.orange : UIColor.blue
        // 2.给cell设置数据
        cell.picURL = picURLs[indexPath.item]
        return cell
    }
}

// MARK:- PhotoBrowserViewCell的代理方法
extension PhotoBrowserController : PhotoBrowserViewCellDelegate {
    func imageViewClick() {
        closeBtnClick()
    }
}


class PhotoBrowserCollectionViewLayout : UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        // 1.设置itemSize
        itemSize = collectionView!.frame.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        // 2.设置collectionView的属性 分页 和指示条
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}
