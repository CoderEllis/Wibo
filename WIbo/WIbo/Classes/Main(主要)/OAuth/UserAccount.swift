//
//  UserAccount.swift
//  WIbo
//
//  Created by Soul Ai on 27/9/18.
//  Copyright © 2018年 Soul Ai. All rights reserved.
//

import UIKit

class UserAccount: NSObject {
    // MARK:- 属性
    /// 授权AccessToken
   @objc var access_token : String?
    /// 过期时间-->秒
   @objc var expires_in : TimeInterval = 0.0 {
        didSet {
            expires_date = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    /// 用户ID
   @objc var uid : String?
    
    /// 过期日期
   @objc var expires_date : NSDate?
    
    /// 昵称
   @objc var screen_name : String?
    
    /// 用户的头像地址
   @objc var avatar_large : String?
    
    // MARK:- 自定义构造函数
    init(dict : [String : AnyObject]) {
        super .init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    // MARK:- 重写description属性
    override var description : String {
        return dictionaryWithValues(forKeys: ["access_token", "expires_date", "uid", "screen_name", "avatar_large"]).description
    }
}
