//
//  QuestionBaseViewController.swift
//  student
//
//  Created by zjueman on 15/12/26.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class QuestionBaseViewController: UIViewController {

    var question:EtaskQuestion?
    
    
    //MARK: set quesstion Title
    func setQuestionTitle(questionTitleView:QuestionTitleView) {
  
        questionTitleView.backgroundColor = QKColor.whiteColor()
        
        if let question = question {
            questionTitleView.ordinalLabel.text = String(question.ordinal)
            questionTitleView.titleLabel.text = question.type.displayTitle()
        } else {
            questionTitleView.ordinalLabel.text = "9"
            questionTitleView.titleLabel.text = "测试题型"
        }
        
    }
    //MARK: time format
    func timeFormat(time:NSTimeInterval)->String{
        let currentTime = Int(time)
        let minutes = currentTime/60
        let seconds = currentTime - minutes * 60
        let timeStr = NSString(format: "%02d:%02d", minutes,seconds) as String
        return timeStr
    }
    //MARK: 有多少(),{%%},underline
    func matchStringSymbol(str:String) -> Int{
        var strArray = [String]()
        if str.containsString("（"){
            strArray = str.componentsSeparatedByString("（")
        }else if str.containsString("underline"){
            strArray = str.componentsSeparatedByString("underline")
        }else if str.containsString("("){
            strArray = str.componentsSeparatedByString("(")
        }else{
            strArray = [""]
        }
        let optionCount = strArray.count - 1
        return optionCount
    }
    
    //MARK: html to format string
    func htmlFormatString(htmlStr:String)->String{
        let str = htmlStr.dataUsingEncoding(NSUTF8StringEncoding)
        let attributedStr = try? NSAttributedString(data: str!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil)
        return (attributedStr?.string)!
    }
}
