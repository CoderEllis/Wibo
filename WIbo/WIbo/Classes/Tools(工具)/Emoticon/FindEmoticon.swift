//
//  FindEmoticon.swift
//  regex
//
//  Created by Soul Ai on 9/10/18.
//  Copyright © 2018年 Soul Ai. All rights reserved.
//

import UIKit

class FindEmoticon: NSObject {
    //MARK:- 设计单例对象
    static let shareIntance : FindEmoticon = FindEmoticon()
    
    // MARK:- 表情属性
    fileprivate lazy var manager : EmoticonManager = EmoticonManager()
    
    /// 查找属性字符串的方法
    func findAttrString(statusText : String?, font : UIFont) -> NSMutableAttributedString? {
        // 0.如果statusText没有值,则直接返回nil
        guard let statusText = statusText else {
            return nil
        }
        
        //1 创建匹配规则
        let pattern = "\\[.*?\\]" //匹配表情    [ 有特殊含义 转换加\\ .中间任意字符 * 任意0个或多个  ? 结束
        
        //2创建正则表达式对象   throw 错误  tay 校验
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        
        //3开始匹配
        let results = regex.matches(in: statusText, options: [], range: NSRange(location: 0, length: statusText.count))
        
        // 4.获取结果
        let attrMStr = NSMutableAttributedString(string: statusText)
        
        for i in (0..<results.count).reversed(){ //reversed 颠倒的
            let result = results[i]
            //获取 chs
            let chs = (statusText as NSString).substring(with: result.range)
            
            //根据chs,获取图片的路径
            guard let pngPath = findPngPath(chs) else {
                return nil
            }
            
            //创建属性字符串
            let attachment = NSTextAttachment()
            attachment.image = UIImage(contentsOfFile: pngPath)
            attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            let attrImageStr = NSAttributedString(attachment: attachment)
            
            // 4.4.将属性字符串替换到来源的文字位置
            attrMStr.replaceCharacters(in: result.range, with: attrImageStr)
            
        }
        // 返回结果
         return attrMStr
    }
    
    fileprivate func findPngPath(_ chs : String) -> String? {
        for package in manager.packages {
            for emoticon in package.emoticons {
                if emoticon.chs == chs {
                    return emoticon.pngPath!
                }
            }
        }
        return nil
    }

}
