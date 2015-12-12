//
//  UserModel.swift
//  student
//
//  Created by zhaoheqiang on 15/12/11.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    var name:String?
    var token:String?
    var imgUrl:String?
    var school:String?
    var schoolId:Int?
    var phone:String?
    var grade:String?
    var realName:String?
    var userId:Int?
    
    init(userInfo:NSDictionary?) {
        super.init()
        userFormat(userInfo)
    }
    
    func userFormat(userInfo:NSDictionary?){
        
        if let user = userInfo{
            token =  user["accessToken"] as? String
            imgUrl = user["avatarsUrl"] as? String
            school = user["school"] as? String
            schoolId = user["schoolID"] == nil ? 0 : user["schoolID"] as? Int
            phone = user["parentMobile"] as? String
            grade = (user["grades"] as? String)! + (user["classr"] as? String)!
            realName = user["realName"] as? String
            name = user["userName"] == nil ? "" : user["userName"] as! String
            userId = user["uuid"] as? Int
        }
        
    }
}
