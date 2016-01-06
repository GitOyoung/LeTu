//
//  QuestionTypeEnum.swift
//  student
//
//  Created by zjueman on 15/12/19.
//  Copyright © 2015年 singlu. All rights reserved.
//

enum QuestionTypeEnum: Int {
    case DanXuan = 1 //单项选择题
    case DuoXuan = 2 //多选题
    case PanDuan = 3 //判断题
    case LianXian = 4 //连线题
    case XuanZeTianKong = 5 // 选择填空题
    case PaiXu = 6 //排序
    case TingLiXuanZe = 7 //听力选择题
    case KouSuan = 8 //口算题
    case TianKong = 9 //填空题
    case YuYinGenDu = 10 //语音跟读题
    case TingLiTianKong = 11 //听力填空
    case JianDa = 12 //简答题
    case LangDu = 14 //朗读题
    
    
    func displayTitle() -> String {
        switch self {
            case .DanXuan:
                return "单项选择题"
            case .DuoXuan:
                return "多选题"
            case .PanDuan:
                return "判断题"
            case .LianXian:
                return "连线题"
            case .XuanZeTianKong:
                return "选择填空题"
            case .PaiXu:
                return "排序题"
            case.TingLiXuanZe:
                return "听力选择题"
            case .KouSuan:
                return "口算题"
            case .TianKong:
                return "填空题"
            case .YuYinGenDu:
                return "语音跟读题"
            case .TingLiTianKong:
                return "听力填空题"
            case .JianDa:
                return "简答题"
            case .LangDu:
                return "朗读题"
        }
    }
    
}