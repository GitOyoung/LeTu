//
//  EtaskAnswer.swift
//  student
//
//  Created by zhaoheqiang on 16/1/5.
//  Copyright © 2016年 singlu. All rights reserved.
//

import Foundation

class EtaskAnswer: NSObject {

    var answer:String
    var answerHistory:[String]?
    var checkImgs:[String]?
    var checkStatus:Bool
    var checkTime:NSDictionary?
    var costTime:Int16
    var finishTime:NSDictionary?
    var isRight:Bool
    var listAnswer:[AnyObject]?
    var ordinal:Int
    var questionId:String
    var score:Int
    var startTime:NSDictionary
    var type:Int
    var viewedTime:Int16
    
    init(answer:String,answerHistory:[String]?,checkImgs:[String]?,checkStatus:Bool,checkTime:NSDictionary?,costTime:Int16,finishTime:NSDictionary?,isRight:Bool,listAnswer:[AnyObject]?,ordinal:Int,questionId:String,score:Int,startTime:NSDictionary?,type:Int,viewedTime:Int16) {
        self.answer = answer
        self.answerHistory = answerHistory
        self.checkImgs = checkImgs
        self.checkStatus = checkStatus
        self.checkTime = checkTime
        self.costTime = costTime
        self.finishTime = finishTime
        self.isRight = isRight
        self.listAnswer = listAnswer
        self.ordinal = ordinal
        self.questionId = questionId
        self.score = score
        self.startTime = startTime!
        self.type = type
        self.viewedTime = viewedTime
        super.init()

    }
    
    func toDictionary() -> NSDictionary{
        var answerDic = [String:AnyObject]()
        answerDic["answer"] = self.answer
        answerDic["answerHistory"] = self.answerHistory
        answerDic["checkImgs"] = self.checkTime
        answerDic["checkStatus"] = self.checkStatus
        answerDic["checkTime"] = self.checkTime
        answerDic["costTime"] = NSNumber(short: self.costTime)
        answerDic["finishTime"] = self.finishTime
        answerDic["isRight"] = self.isRight
        answerDic["listAnswer"] = self.listAnswer
        answerDic["ordinal"] = self.ordinal
        answerDic["questionId"] = self.questionId
        answerDic["score"] = self.score
        answerDic["startTime"] = self.startTime
        answerDic["type"] = self.type
        answerDic["viewedTime"] = NSNumber(short: self.viewedTime)
        return answerDic
    }

}