//
//  AskBL.swift
//  student
//
//  Created by Jiang, Xinxing on 15/12/10.
//  Copyright © 2015年 singlu. All rights reserved.
//

import Foundation

class AskBL {
    ///查询所有数据
    func findAll() -> NSMutableArray {
        var dao:AskDAO = AskDAO.sharedInstance
        return dao.findAll()
    }
    
    ///查询语文数据
    func findYuwen() -> NSMutableArray {
        var dao:AskDAO = AskDAO.sharedInstance
        return dao.findYuwen()
    }
    
    ///查询数学数据
    func findShuxue() -> NSMutableArray {
        var dao:AskDAO = AskDAO.sharedInstance
        return dao.findShuxue()
    }
    
    ///查询英语数据
    func findYingyu() -> NSMutableArray {
        var dao:AskDAO = AskDAO.sharedInstance
        return dao.findYingyu()
    }
}