//
//  EmoticonManager.swift
//  tooll
//
//  Created by Soul Ai on 7/10/18.
//  Copyright © 2018年 Soul Ai. All rights reserved.
//

import UIKit

class EmoticonManager {
    var packages : [EmoticonPackage] = [EmoticonPackage]()

    init () {
        // 1.添加最近表情的包
        packages.append(EmoticonPackage(id: ""))
        
        packages.append(EmoticonPackage(id: "com.sina.default"))
        
        packages.append(EmoticonPackage(id: "com.apple.emoji"))
        
        packages.append(EmoticonPackage(id: "com.sina.lxh"))
    }
}
