//
//  EtaskQuestion.swift
//  student
//
//  Created by zjueman on 15/12/19.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

enum QuestionStatus: String{
    case NotStart = "0"
    case NotFinish = "1"
    case NotCorrect = "2"
    case NotRevise = "3"
    case Finish = "4"

    func getStatus() -> String{
        switch self {
            case .NotStart:
                return "未开始"
            case .NotFinish:
                return "未完成"
            case .NotCorrect:
                return "未批改"
            case .NotRevise:
                return "未订正"
            case .Finish:
                return "已完成"
        }
    }
}

class EtaskQuestion: NSObject {
    
    var type:QuestionTypeEnum
    var ordinal:Int
    var questionBody:String?
    var options:[[String: AnyObject]]?
    var id:String
    var status: String
    
    init(data:NSDictionary) {

        let ptype:Int = data["type"] as! Int
        let rawOptions = data["option"]
        let questionStatus = data["status"] as! Int
        type = QuestionTypeEnum(rawValue: "\(ptype)" )!
        ordinal = data["ordinal"] as! Int
        questionBody = data["question"] as? String
        options = rawOptions as? [[String:AnyObject]]
        id = data["questionId"] as! String
        status = QuestionStatus(rawValue: "\(questionStatus)")!.getStatus()
        super.init()
        printQuestion()
    }
    
    func printQuestion() {
        print("ID：\(id)")
        print("类型:\(self.type)")
        print("状态：\(status)")
        print("序号:\(self.ordinal)")
        print("内容:\(self.questionBody)")
        print("选项:")
        if let options = self.options {
            for option in options {
                print(option)
            }
        }
    }

}
