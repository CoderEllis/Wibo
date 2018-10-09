//
//  HomeViewCell.swift
//  WIbo
//
//  Created by Soul Ai on 2/10/18.
//  Copyright © 2018年 Soul Ai. All rights reserved.
//

import UIKit
import SDWebImage

private let edgeMargin : CGFloat = 15
private let itemMargin :CGFloat = 10

class HomeViewCell: UITableViewCell {
    // MARK:- 控件属性
    @IBOutlet weak var iconView: UIImageView!       //头像
    @IBOutlet weak var verifiedView: UIImageView!   //认证
    @IBOutlet weak var screeNameLabel: UILabel!    //昵称
    @IBOutlet weak var vipView: UIImageView!       //Vip 图标
    @IBOutlet weak var timeLabel: UILabel!         //时间
    @IBOutlet weak var sourceLabel: UILabel!       //来源
    @IBOutlet weak var contentLabel: UILabel!      //正文
    @IBOutlet weak var picView: PicCollectionView!  //配图
    @IBOutlet weak var retweetedContentLabel: UILabel!  //转发
    @IBOutlet weak var retweetedBgView: UIView!   //转发的背景
    @IBOutlet weak var bottomToolView: UIView!    //工具栏高度
    

    // MARK:- 约束的属性
    @IBOutlet weak var contenLabelCons: NSLayoutConstraint!
    @IBOutlet weak var picViewHcons: NSLayoutConstraint!
    @IBOutlet weak var picViewWcons: NSLayoutConstraint!
    @IBOutlet weak var picViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var retweetedContentLabelTopCons: NSLayoutConstraint!
    
    
    // MARK:- 自定义属性
    var viewModel : StatusViewModel? {
        didSet {
            // 1.nil值校验
            guard let viewModel = viewModel else {
                return
            }
            // 2.设置头像
            iconView.sd_setImage(with: viewModel.profileURL, placeholderImage: UIImage(named: "avatar_default_small"))
            
             // 3.设置认证的图标
            verifiedView.image = viewModel.verifiedImage
            
            // 4.昵称
            screeNameLabel.text = viewModel.status?.user?.screen_name
            
            // 5.会员图标
            vipView.image = viewModel.vipImage
            
            // 6.设置时间的Label
            timeLabel.text = viewModel.createAtText
            
            contentLabel.attributedText = FindEmoticon.shareIntance.findAttrString(statusText: viewModel.status?.text, font: contentLabel.font)
            
            // 7.设置来源
            if let sourceText = viewModel.sourceText {
                sourceLabel.text = "来自 " + sourceText
            }else {
                sourceLabel.text = nil
            }
            
            //微博正文
            contentLabel.text = viewModel.status?.text
            
            // 9.设置昵称的文字颜色
            screeNameLabel.textColor = viewModel.vipImage == nil ? UIColor.black : UIColor.orange
            
            //10.计算picView的宽度和高度的约束
            let picViewSize = calculatePicViewSize(viewModel.picURLs.count)
            picViewHcons.constant = picViewSize.height
            picViewWcons.constant = picViewSize.width
            
            //11.将picURL数据传递给picView
            picView.picURLs = viewModel.picURLs
            
            // 11.设置转发微博的正文
            if viewModel.status?.retweeted_status != nil {
                if let screenName = viewModel.status?.retweeted_status?.user?.screen_name, let retweetedText = viewModel.status?.retweeted_status?.text {
                    let retweetedText = "@" + "\(screenName) :" + retweetedText
                    retweetedContentLabel.attributedText = FindEmoticon.shareIntance.findAttrString(statusText: retweetedText, font: retweetedContentLabel.font)
                    
                    
                    // 设置转发正文距离顶部的约束
                    retweetedContentLabelTopCons.constant = 15
                }
                //显示转发的背景
                retweetedBgView.isHidden = false
                
            }else {
                retweetedContentLabel.text = nil
                //显示背景
                retweetedBgView.isHidden = true
                // 3.设置转发正文距离顶部的约束
                retweetedContentLabelTopCons.constant = 0
            }
            
            // 12.计算cell的高度
            if viewModel.cellHeight == 0 {
                
                // 12.1.强制布局
                layoutIfNeeded()
                
                // 12.2.获取底部工具栏的最大Y值
                viewModel.cellHeight = bottomToolView.frame.maxY
            }

            
        }
    }
    
    

    
    
    // MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()

        // 设置微博正文的宽度约束
        contenLabelCons.constant = UIScreen.main.bounds.width - 2 * edgeMargin
        
        // 取出picView对应的layout  布局
//        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout //转成流水布局
//        let imageViewWH = (UIScreen.main.bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
//        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
    }

}

//MARK:- 计算图片高度
extension HomeViewCell {
    private func calculatePicViewSize(_ count : Int) -> CGSize {
        // 1.没有配图
        if count == 0 {
            picViewBottomCons.constant = 0
            return CGSize.zero
        }
        // 有配图需要改约束有值
        picViewBottomCons.constant = 10
        
        // 2.取出picView对应的layout
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
        
        //3.单张配图
        if count == 1 {
            // 1.取出图片
            let urlString = viewModel?.picURLs.last?.absoluteString
            let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: urlString)
            
            // 2.设置一张图片是layout的itemSize
            layout.itemSize = CGSize(width: image!.size.width * 2, height: image!.size.height * 2)
            
            return CGSize(width: image!.size.width * 1.5, height: image!.size.height * 1.5) //SD 可能下载时将图片压缩了一倍  所以 * 2
        }
        
//            if count == 4 {//四张图片占全屏
//                let fourWH = (UIScreen.main.bounds.width - 2 * edgeMargin - itemMargin) / 2
//                let picViewWH = fourWH * 2 + itemMargin
//                layout.itemSize = CGSize(width: picViewWH, height: picViewWH)
//                return CGSize(width: picViewWH, height: picViewWH)
//            }
 
        
        // 4.计算出来imageViewWH
        let imageViewWH = (UIScreen.main.bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
        
        // 5.设置其他张图片时layout的itemSize
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
        
        // 6.四张配图
        if count == 4 {
            let picViewWH = imageViewWH * 2 + itemMargin + 1
            return CGSize(width: picViewWH, height: picViewWH)
        }
        
        
        // 7.其他张配图
        // 7.1.计算行数
        let rows = CGFloat((count - 1) / 3 + 1)
        
        // 7.2.计算picView的高度
        let picViewH = rows * imageViewWH + (rows - 1) * itemMargin
        let picViewW = UIScreen.main.bounds.width - 2 * edgeMargin
        
        return CGSize(width: picViewW, height: picViewH)
        
    }
}
