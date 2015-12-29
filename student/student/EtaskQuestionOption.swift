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
            let html_str = option["option"] as? String
            let nsDataStr = html_str?.dataUsingEncoding(NSUTF8StringEncoding)
            let attributedStr = try! NSAttributedString(data: nsDataStr!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)
            self.option = attributedStr.string
            self.optionIndex = option["optionIndex"] as? Int
            self.answer = option["answer"] as? String
        }
    }
    
    
}
