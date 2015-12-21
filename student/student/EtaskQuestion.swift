//
//  EtaskQuestion.swift
//  student
//
//  Created by zjueman on 15/12/19.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class EtaskQuestion: NSObject {
    
    var type:String
    var ordinal:Int
    var questionBody:String?
    var options:[[String: String]]?
    
    init(data:NSDictionary) {
        
        let ptype:Int = data["type"] as! Int
        let rawOptions = data["option"]
//        self.type = QuestionTypeEnum(rawValue: "\(ptype)" )!.displayTitle()
        self.type = String(ptype)
        self.ordinal = data["ordinal"] as! Int
        self.questionBody = data["question"] as? String
        self.options = rawOptions as? [[String:String]]

        super.init()
        print("===========")
        printQuestion()

    }
    
    func printQuestion() {
        print("类型:\(self.type)")
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
