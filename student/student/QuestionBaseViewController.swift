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
    
    var questionAnswer: EtaskAnswer?
    var enterClock: clock_t = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQuestionAnswer()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadWithAnswer()
    }
    
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
        let string = attributedStr?.string.stringByReplacingOccurrencesOfString("%", withString: " ")
        return string!
    }
    
    //MARK: setup QuestionAnswer
    func setupQuestionAnswer() {
        enterClock = clock()
        guard let _ = questionAnswer else {
            questionAnswer = EtaskAnswer()
            if let a = questionAnswer {
                a.startTime = dateInfoNow()
                a.costTime = 0
                a.viewedTime = 0
                if let q = question {
                    a.ordinal = q.ordinal
                    a.questionId = q.id
                    a.type = q.type.rawValue
                }
            }
            return
        }
        
        
    }
    //MARK: get current Time Infomation
    func dateInfoNow() -> NSDictionary? {
        let date = NSDate()
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let flags: NSCalendarUnit = [NSCalendarUnit.Year
            , NSCalendarUnit.Month
            , NSCalendarUnit.Day
            , NSCalendarUnit.Weekday
            , NSCalendarUnit.Hour
            , NSCalendarUnit.Minute
            , NSCalendarUnit.Second]
        
        let zone = NSTimeZone(name: "Asia/Shanghai")
//        print(NSTimeZone.abbreviationDictionary())
        if let info = calendar?.components(flags, fromDate: date) {
            let st = NSMutableDictionary()
            st["year"] = info.year
            st["month"] = info.month
            st["day"] = info.weekday
            st["hours"] = info.hour
            st["minutes"] = info.minute
            st["seconds"] = info.second
            st["date"] = info.day
            st["time"] = Int(date.timeIntervalSince1970 * 1000)
            st["timezoneOffset"] = zone!.secondsFromGMT / 60
            return st
        }
        return nil
    }
    
    func loadWithAnswer() {
        
    }
    
    func updateAnswer() {
        let cost: clock_t = clock() - enterClock
        if let q = questionAnswer {
            q.costTime += Int(Double(cost) / Double(CLOCKS_PER_SEC) * 1000)
            q.finishTime = dateInfoNow()
            q.viewedTime++
            
        }
    }
    
    func answer() -> EtaskAnswer {
        updateAnswer()
        return questionAnswer!
    }
    
    //MARK:答案列表
    func getListAnswerItem(str:String,answerType:Int,ordinal:Int) -> Dictionary<String,AnyObject>{
        var dic = Dictionary<String,AnyObject>()
        dic["answer"] = str
        dic["answerHistory"] = nil
        dic["answerType"] = answerType
        dic["isRight"] = 0
        dic["listAnswer"] = []
        dic["ordinal"] = ordinal
        dic["score"] = 0
        dic["type"] = 0
        return dic
    }

}
