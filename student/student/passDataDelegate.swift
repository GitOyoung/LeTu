//
//  passDataDelegate.swift
//  student
//
//  Created by luania on 16/1/4.
//  Copyright © 2016年 singlu. All rights reserved.
//

import Foundation

protocol passAnswerSetDataDelegate{
    func passAnswerSetData(answerWay:KouSuanAnswerWay,answerTimer:Int)
}

protocol passAnswerDataDelegate{
    func passAnswerData(answers:[String],costTime:Double)
}