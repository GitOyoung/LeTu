//
//  QuestionTypeEnum.swift
//  student
//
//  Created by zjueman on 15/12/19.
//  Copyright © 2015年 singlu. All rights reserved.
//

enum QuestionTypeEnum:String {
    case DanXuan = "1" //单项选择题
    case PanDuan = "2" //判断题
    case LianXian = "3" //连线题
    case TianKong = "4" //填空题
    
    func displayTitle() -> String {
        switch self {
        case .DanXuan:
            return "单项选择题"
        case .PanDuan:
            return "判断题"
        case .LianXian:
                return "连线题"
        case .TianKong:
                return "填空题"
        default:
             return "默认"
        }
    }
    
}