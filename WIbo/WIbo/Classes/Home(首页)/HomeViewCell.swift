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

class HomeViewCell: UITableViewCell {
    // MARK:- 控件属性
    @IBOutlet weak var iconView: UIImageView!       //头像
    @IBOutlet weak var verifiedView: UIImageView!   //认证
    @IBOutlet weak var screeNameLabel: UILabel!    //昵称
    @IBOutlet weak var vipView: UIImageView!       //Vip 图标
    @IBOutlet weak var timeLabel: UILabel!         //时间
    @IBOutlet weak var sourceLabel: UILabel!       //来源
    @IBOutlet weak var contentLabel: UILabel!      //正文
    

    // MARK:- 约束的属性
    @IBOutlet weak var contenLabelCons: NSLayoutConstraint!
    
    // MARK:- 自定义属性
    var viewModel : StatusViewModel? {
        didSet {
            // 1.nil值校验
            guard let viewModel = viewModel else {
                return
            }
            // 2.设置头像
            iconView.sd_setImage(with: viewModel.profileURL, placeholderImage: UIImage(named: "avatar_default_small"), options: [], completed: nil)
            
             // 3.设置认证的图标
            verifiedView.image = viewModel.verifiedImage
            
            // 4.昵称
            screeNameLabel.text = viewModel.status?.user?.screen_name
            
            // 5.会员图标
            vipView.image = viewModel.vipImage
            
            // 6.设置时间的Label
            timeLabel.text = viewModel.createAtText
            
            // 7.设置来源
            sourceLabel.text = viewModel.sourceText
            
            //微博正文
            contentLabel.text = viewModel.status?.text
            
            // 9.设置昵称的文字颜色
            screeNameLabel.textColor = viewModel.vipImage == nil ? UIColor.black : UIColor.orange
        }
    }
    
    

    
    
    // MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()

        // 设置微博正文的宽度约束
        contenLabelCons.constant = UIScreen.main.bounds.width - 2 * edgeMargin
    }



}
