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
    var id:String?
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
    
    init(info:NSDictionary?) {
        super.init()
        etaskFormat(info)
    }
    
    //渲染电子作业格式
    func etaskFormat(etaskInfo:NSDictionary?){
        if let info = etaskInfo {
            
            id = info["etaskId"] as? String
            name = info["name"] as? String
            subTitle = info["subTitleBook"] as? String
            summary = info["subTitleExeBook"] as? String
            bookInfo = info["bookInfo"] == nil ? "" : info["bookInfo"] as? String
            bookInfoId = info["bookInfoId"] as? Int
            exeBook = info["exeBook"]  == nil ? "" : info["exeBook"] as? String
            exeBookId = info["exeBookId"] as? Int
            grade = info["grade"] == nil ? "" : info["grade"] as? String
            subject = info["subject"] as? String
            subjectId = info["subjectId"] as? Int
            teacherId = info["teacherId"] as? Int
            exeUnitPeriod = info["exeUnitPeriod"] as? String
            questionCount = info["questionCount"] as? Int
            unitPeriod = info["unitPeriod"] as? [String]
            term = info["term"] as? String
            termId = info["termId"] as? Int
            startTime = NSDate().timeStampToString(info["startTime"]!["time"] as! String)
            endTime = NSDate().timeStampToString(info["endTime"]!["time"] as! String)
            
        }

    }
    
}
