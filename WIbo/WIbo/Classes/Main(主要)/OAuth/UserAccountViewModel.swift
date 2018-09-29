//
//  UserAccountViewModel.swift
//  WIbo
//
//  Created by Soul Ai on 28/9/18.
//  Copyright © 2018年 Soul Ai. All rights reserved.
//

import UIKit

class UserAccountViewModel: NSObject {
    // MARK:- 将类设计成单例
    static let shareIntance : UserAccountViewModel = UserAccountViewModel()
    
    
    // MARK:- 定义属性
    var account : UserAccount?
    
    // MARK:- 计算属性
    var accountPath : String { //获取沙盒路径
        let accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return (accountPath as NSString).appendingPathComponent("accout.plist")
    }
    
    var isLogin : Bool {
        if account == nil {
            return false
        }
        
        guard let expiresDate = account?.expires_date else {// 校验.取出过期日期 : 当前日期
            return false
        }
        return expiresDate.compare(Date()) == ComparisonResult.orderedDescending
    }
    
    // MARK:- 重写init()函数
    override init() {
        super.init()
        // 1.从沙盒中读取中归档的信息
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
//        print("---\(account)")
    }
}


/*
 // 1.从沙盒中读取中归档的信息
 // 1.1.获取沙盒路径
 var accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
 accountPath = (accountPath as NSString).appendingPathComponent("accout.plist")
 
 // 1.2.读取信息
 let account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
 if let account = account {
 //orderedAscending 有序升序 orderedSame排序相同 orderedDescending有序下降
 // 1.3.取出过期日期 : 当前日期
 if let expiresDate = account.expires_date {
 isLogin = expiresDate.compare(Date()) == ComparisonResult.orderedDescending
 }
 }
 */
