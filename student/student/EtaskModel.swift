//
//  File.swift
//  student
//
//  Created by zhaoheqiang on 15/12/11.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

extension NSDate{
    
    //13位时间戳转换成"yyyy-MM-dd HH:mm:SS"
    func timeStampToString(timeStamp:String)->String {
        let string = NSString(string: timeStamp)
        
        let timeSta:NSTimeInterval = string.doubleValue
        
        let dfmatter = NSDateFormatter()
        
        dfmatter.dateFormat="yyyy-MM-dd HH:mm:SS"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        return dfmatter.stringFromDate(date)
    }

}

enum EtaskStatus : Int{
    case New      //未开始
    case Unfinished      //未完成
    case Uncorrecting   //未批改
    case Uncorrected    //未订正
    case Finished       //已完成
    init(status: Int) {
        switch status
        {
        case 0: self = .New
        case 1: self = .Unfinished
        case 2: self = .Uncorrecting
        case 3: self = .Uncorrected
        case 4: self = .Finished
        default: self = .New
        }
    }
}

enum EtaskLevel : Int
{
    case Unknown
    case Bad
    case Good
    case Great
}



class EtaskModel: NSObject {
    var etaskID:String?
    var name:String?
    var subTitle:String?
    var summary:String?
    var bookInfo:String?
    var bookInfoId:Int?
    var exeBook:String?
    var exeBookId:Int?
    var grade:String?
    var subject:String?
    var subjectId:Int?
    var teacherId:Int?
    var exeUnitPeriod:String?
    var questionCount:Int?
    var unitPeriod:[String]?
    var term:String?
    var termId:Int?
    var startTime:String?
    var endTime:String?
    var status: EtaskStatus = .New
    
    
    override init(){}
    
    init(info:NSDictionary?) {
        super.init()
        etaskFormat(info)
    }
    
    //渲染电子作业格式
    func etaskFormat(etaskInfo:NSDictionary?){
        if let info = etaskInfo
        {
            print(info)
            if let etask = info["etask"]
            {
                etaskID = etask["etaskId"] as? String
                name = etask["name"] as? String
                subTitle = etask["subTitleBook"] as? String
                summary = etask["subTitleExeBook"] as? String
                bookInfo = etask["bookInfo"] == nil ? "" : info["bookInfo"] as? String
                bookInfoId = etask["bookInfoId"] as? Int
                exeBook = etask["exeBook"]  == nil ? "" : info["exeBook"] as? String
                exeBookId = etask["exeBookId"] as? Int
                grade = etask["grade"] == nil ? "" : info["grade"] as? String
                subject = etask["subject"] as? String
                subjectId = etask["subjectId"] as? Int
                teacherId = etask["teacherId"] as? Int
                exeUnitPeriod = etask["exeUnitPeriod"] as? String
                questionCount = etask["questionCount"] as? Int
                unitPeriod = etask["unitPeriod"] as? [String]
                term = etask["term"] as? String
                termId = etask["termId"] as? Int
                let startTimeDic = etask["startTime"] as! NSDictionary
                print(startTimeDic["time"])
                startTime = NSDate().timeStampToString(String(startTimeDic["time"]))
                let endTimeDic = etask["endTime"] as! NSDictionary
                endTime = NSDate().timeStampToString(String(endTimeDic["time"]))
                
                
            }
            status = EtaskStatus(status: info["status"] as! Int)
        }

    }
    
    func isNewTask() -> Bool {
        return status == .New
    }
    
}
