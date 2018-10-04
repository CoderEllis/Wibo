//
//  ComposeTextView.swift
//  WIbo
//
//  Created by Soul Ai on 5/10/18.
//  Copyright © 2018年 Soul Ai. All rights reserved.
//

import UIKit
import SnapKit

class ComposeTextView: UITextView {
    // MARK:- 懒加载属性
    private lazy var placeHolderLabel : UILabel = UILabel()
    
    // MARK:- 构造函数
    required init?(coder aDecoder: NSCoder) {//这个一般做添加子控件
        super.init(coder: aDecoder) // awakeFromNib  一般做初始化操作 约束 文字颜色 等等

        
        setupUI()
        
    }
}

// MARK:- 设置UI界面
extension ComposeTextView {
    private func setupUI() {
         // 1.添加子控件
        addSubview(placeHolderLabel)
        
        // 2.设置frame
        placeHolderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(10)
        }
        // 3.设置placeholderLabel属性
        placeHolderLabel.textColor = UIColor.red
        placeHolderLabel.font = font
        
        // 4.设置placeholderLabel文字
        placeHolderLabel.text = "分享新鲜事..."
        
        // 5.设置内容的内边距
        textContainerInset = UIEdgeInsets(top: 6, left: 7, bottom: 0, right: 7)
        
    }
}

