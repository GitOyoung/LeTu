//
//  File.swift
//  student
//
//  Created by luania on 15/12/22.
//  Copyright © 2015年 singlu. All rights reserved.
//

import Foundation

class NSUserDefaultUtil:NSObject{
    
    private class func saveObject(key:String,value:AnyObject){
        NSUserDefaults.standardUserDefaults().setObject(value, forKey:key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    private class func getObject(key:String)->AnyObject?{
        return NSUserDefaults.standardUserDefaults().objectForKey(key)
    }
    
    private class func clearObject(key:String){
        NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func saveUser(user:UserModel?){
        let userDictionary = user?.toDictionary()
        if(userDictionary == nil){
            clearObject("user")
        }else{
            saveObject("user", value: userDictionary!)
        }
    }
    
    class func getUser() -> UserModel?{
        let userInfo:NSDictionary? = getObject("user") as? NSDictionary
        if(userInfo != nil){
            return UserModel(userInfo: userInfo)
        }
        return nil
    }
}




