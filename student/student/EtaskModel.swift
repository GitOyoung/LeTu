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
    var classesId:Int?
    var recordId:Int?
    
    override init(){}
    
    init(info:NSDictionary?) {
        super.init()
        etaskFormat(info)
    }
    
    //渲染电子作业格式
    func etaskFormat(etaskInfo:NSDictionary?){
        if let info = etaskInfo {
            
            etaskID = info["etask"]!["etaskId"] as? String
            name = info["etask"]!["name"] as? String
            subTitle = info["etask"]!["subTitleBook"] as? String
            summary = info["etask"]!["subTitleExeBook"] as? String
            bookInfo = info["etask"]!["bookInfo"] == nil ? "" : info["etask"]!["bookInfo"] as? String
            bookInfoId = info["etask"]!["bookInfoId"] as? Int
            exeBook = info["etask"]!["exeBook"]  == nil ? "" : info["etask"]!["exeBook"] as? String
            exeBookId = info["etask"]!["exeBookId"] as? Int
            grade = info["etask"]!["grade"] == nil ? "" : info["etask"]!["grade"] as? String
            subject = info["etask"]!["subject"] as? String
            subjectId = info["etask"]!["subjectId"] as? Int
            teacherId = info["etask"]!["teacherId"] as? Int
            exeUnitPeriod = info["etask"]!["exeUnitPeriod"] as? String
            questionCount = info["etask"]!["questionCount"] as? Int
            unitPeriod = info["etask"]!["unitPeriod"] as? [String]
            term = info["etask"]!["term"] as? String
            termId = info["etask"]!["termId"] as? Int
            let startTimeDic = info["etask"]!["startTime"] as! NSDictionary
            startTime = NSDate().timeStampToString(String(startTimeDic["time"]))
            let endTimeDic = info["etask"]!["endTime"] as! NSDictionary
            endTime = NSDate().timeStampToString(String(endTimeDic["time"]))
            classesId = info["classesId"] as? Int
            recordId = info["recordId"] as? Int
        }

    }
    
}
