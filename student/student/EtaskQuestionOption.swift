//
//  EtaskQuestionOption.swift
//  student
//
//  Created by zhaoheqiang on 15/12/23.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class EtaskQuestionOption: NSObject {

    //MARK:properties
    var option:String?
    var optionIndex:Int?
    var answer:String?
    
    
    init?(option:NSDictionary?) {
        if let option = option{
            self.option = option["option"] as? String
            self.optionIndex = option["optionIndex"] as? Int
            self.answer = option["answer"] as? String
        }
    }
    
    
}
