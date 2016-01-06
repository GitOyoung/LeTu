//
//  EtaskAnswer.swift
//  student
//
//  Created by zhaoheqiang on 16/1/5.
//  Copyright © 2016年 singlu. All rights reserved.
//

import Foundation

class EtaskAnswer: NSObject {

    var answer:String = ""
    var answerHistory:[String]?
    var checkImgs:[String]?
    var checkStatus:Bool = false
    var checkTime:NSDictionary?
    var costTime:Int = 0
    var finishTime:NSDictionary?
    var isRight:Bool = false
    var listAnswer:[AnyObject]?
    var ordinal:Int = 0
    var questionId:String = ""
    var score:Int = 0
    var startTime:NSDictionary?
    var type:Int = 0
    var viewedTime:Int = 0
    
    func toDictionary() -> NSDictionary{
        var answerDic = [String:AnyObject]()
        answerDic["answer"] = self.answer
        answerDic["answerHistory"] = self.answerHistory
        answerDic["checkImgs"] = self.checkTime
        answerDic["checkStatus"] = self.checkStatus
        answerDic["checkTime"] = self.checkTime
        answerDic["costTime"] = self.costTime
        answerDic["finishTime"] = self.finishTime
        answerDic["isRight"] = self.isRight
        answerDic["listAnswer"] = self.listAnswer
        answerDic["ordinal"] = self.ordinal
        answerDic["questionId"] = self.questionId
        answerDic["score"] = self.score
        answerDic["startTime"] = self.startTime
        answerDic["type"] = self.type
        answerDic["viewedTime"] = self.viewedTime
        return answerDic
    }

}