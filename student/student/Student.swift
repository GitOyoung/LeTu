//
//  Student.swift
//  student
//
//  Created by oyoung on 15/12/1.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class LTTime: NSObject {
//    "date": ​30,
//    "day": ​1,
//    "hours": ​21,
//    "minutes": ​22,
//    "month": ​10,
//    "seconds": ​4,
//    "time": ​1448889724000,
//    "timezoneOffset": ​-480,
//    "year": ​115
    var date: Int = 1
    var day: Int = 1
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    var month: Int = 0
    var time: Int = 0
    var timezoneOffset: Int = 0
    var year: Int = 0
    
    
    init(timeInfo: NSDictionary?) {
        super.init()
        self.fromDictionary(timeInfo)
    }
    
    func fromDictionary(info: NSDictionary?) -> Void
    {
        if info == nil
        {
            return
        }
        let timeInfo: NSDictionary = info!
        date = timeInfo["date"] == nil ? 0 : timeInfo["date"]  as! Int
        day = timeInfo["day"] == nil ? 0 : timeInfo["day"] as! Int
        hours = timeInfo["hours"] == nil ? 0 : timeInfo["hours"] as! Int
        minutes = timeInfo["minutes"] == nil ? 0 : timeInfo["minutes"] as! Int
        seconds = timeInfo["seconds"] == nil ? 0 : timeInfo["seconds"] as! Int
        month = timeInfo["month"] == nil ? 0 : timeInfo["month"] as! Int
        time = timeInfo["time"] == nil ? 0 : timeInfo["time"] as! Int
        timezoneOffset = timeInfo["timezoneOffset"] == nil ? 0 : timeInfo["timezoneOffset"] as! Int
        year  = timeInfo["year"] == nil ? 0 : timeInfo["year"] as! Int
    }
    
    class func timeFromDictionary(timeInfo: NSDictionary?) -> LTTime
    {
        return LTTime(timeInfo: timeInfo)
    }
    
}

class Student: NSObject {
    
    var accessToken: String?
    var age: Int = 1
    var avatarsUrl: String?
    var birthday: String?
    var city: String?
    var classr: String?
    var county: String?
    var credit: Int = 0
    var flag: Int = 0
    var goSchoolYear: Int?
    var grades: String?
    var lastLogin: LTTime?
    var parentEmail: String?
    var parentMobile: String?
    var province: String?
    var realName: String?
    var registerTime: LTTime?
    var school: String?
    var schoolID: Int64 = 0
    var sex: String = "M"
    var status: Int = 0
    var userName: String = ""
    var userType: String = "A"
    var uuid: Int = 0
    var vipFinishDate: LTTime?
    
    
    
    override init() {
        super.init()
    }
    init(info: NSDictionary?) {
        super.init()
        fromDictionary(info)
        
    }
    func fromDictionary(information: NSDictionary?) {
        
        if information == nil
        {
            return
        }
        let info: NSDictionary = information!
        accessToken = info["accessToken"] as? String
        age = info["age"] == nil ? 0 : info["age"] as! Int
        avatarsUrl = info["avatarsUrl"] as? String
        birthday = info["birthday"] as? String
        city = info["city"] as? String
        classr = info["classr"] as? String
        county = info["county"] as? String
        credit = info["credit"] == nil ? 0 : info["credit"] as! Int
        flag = info["flag"] == nil ? 0: info["flag"] as! Int
        goSchoolYear = info["goSchoolYear"] == nil ? 1900: info["goSchoolYear"] as? Int
        grades = info["grades"] as? String
        lastLogin = LTTime(timeInfo: info["lastLogin"] as? NSDictionary)
        parentEmail = info["parentEmail"] as? String
        parentMobile = info["parentMobile"] as? String
        province = info["province"] as? String
        realName = info["realName"] as? String
        registerTime = LTTime(timeInfo: info["registerTime"] as? NSDictionary)
        school = info["school"] as? String
        schoolID  = info["schoolID"] == nil ? 0: info["schoolID"] as! Int64
        sex = info["sex"] == nil ? "M" : info["sex"] as! String
        status = info["status"] == nil ? 0 : info["status"] as! Int
        userName = info["userName"] == nil ? "" : info["userName"] as! String
        userType = info["userType"] == nil ? "A" : info["userType"] as! String
        uuid = info["uuid"] == nil ? 0 : info["uuid"] as! Int
        vipFinishDate = LTTime(timeInfo: info["vipFinishTime"] as? NSDictionary)

    }

}
