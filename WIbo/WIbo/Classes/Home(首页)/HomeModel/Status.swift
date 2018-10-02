//
//  Status.swift
//  WIbo
//
//  Created by Soul Ai on 30/9/18.
//  Copyright © 2018年 Soul Ai. All rights reserved.
//

import UIKit

class Status: NSObject { //KVC属于 OC 的 使用时 @objc
    // MARK:- 属性
    @objc var created_at : String?                 // 微博创建时间
    @objc var source : String?                     // 微博来源
    @objc var text : String?                      // 微博的正文
    @objc var mid : Int = 0                       // 微博的ID
    @objc var user : User?
     
    
    // MARK:- 自定义构造函数 使用字典作为参数
    init(dict : [String : Any]) {
        super.init()
        //as?最终转成的类型是一个可选类型
        //as!最终转成的类型是一个确定类型
        setValuesForKeys(dict)
        
        // 1.将用户字典转成用户模型对象
        if let userDict = dict["user"] as? [String : Any] {
            user = User(dict: userDict)
        }
        
    }

    //避免字典参数中传的参数在类中没有定义相应的属性造成崩溃，重写此方法
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
