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
    var options:[EtaskQuestionOption]?
    var id:String
    var status: String
    let speechUrlHtmlData:String? //听力相关题目的语音url
    
    init(data:NSDictionary) {

        let ptype:Int = data["type"] as! Int
        let questionStatus = data["status"] as! Int
        type = QuestionTypeEnum(rawValue: "\(ptype)" )!
        ordinal = data["ordinal"] as! Int
        questionBody = data["question"] as? String
        id = data["questionId"] as! String
        status = QuestionStatus(rawValue: "\(questionStatus)")!.getStatus()
        
        
        if let speechUrlRawData = data["speechUrl"] {
           speechUrlHtmlData = speechUrlRawData as? String
        } else {
            speechUrlHtmlData = nil
        }
        
        super.init()
        options = self.getEtaskQuestionOptions(data)
        printQuestion()
    }
    
    //获取题目的所有选项(options)
    func getEtaskQuestionOptions(data:NSDictionary?) ->[EtaskQuestionOption] {
        var etaskQuestionOptions = [EtaskQuestionOption]()
        if let question = data{
            if let questionOptions = question["option"] as? [[String:AnyObject]]{
                for option in questionOptions{
                    etaskQuestionOptions.append(EtaskQuestionOption(option: option)!)
                }
            }
        }
        
        return etaskQuestionOptions
    }
    
    
    func printQuestion() {
        print("===================================================")
        print("ID：\(id)")
        print("类型:\(self.type)")
        print("状态：\(status)")
        print("序号:\(self.ordinal)")
        print("内容:\(self.questionBody)")
        print("语音:\(self.speechUrlHtmlData)")

        print("选项:")
        if let questionOptions = self.options{
            for option in questionOptions{
                print("\(option.option)")
            }
        }
    }

}
