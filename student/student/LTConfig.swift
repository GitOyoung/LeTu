//
//  LTConfig.swift
//  student
//
//  Created by oyoung on 15/12/1.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit
//乐在学途本地设置
class LTConfig: NSObject {
    
    static private var config: LTConfig?
    static func defaultConfig() -> LTConfig{
        if config == nil{
            config = LTConfig()
        }
        return config!
    }
    private override init() {
        user = nil
    }
    
    private var user: Student?
    var defaultUser:Student? {
        get {
            return user
        }
        set(newStudent) {
            user = newStudent
        }
    }
    
   

}
