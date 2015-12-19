//
//  EtaskQuestion.swift
//  student
//
//  Created by zjueman on 15/12/19.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class EtaskQuestion: NSObject {
    
    var type:QuestionTypeEnum
    var ordinal:Int
    var questionBody:String
    var options:[[String: String]]?
    
    init(data:NSDictionary) {
        self.type = QuestionTypeEnum(rawValue: data["type"] as! String)!
        self.ordinal = data["ordinal"] as! Int
        self.questionBody = data["question"] as! String
        let rawOptions = data["option"]
        print(rawOptions)
    }
    
    

}
