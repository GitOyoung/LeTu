//
//  AskDAO.swift
//  student
//
//  Created by Jiang, Xinxing on 15/12/10.
//  Copyright © 2015年 singlu. All rights reserved.
//

import Foundation

class AskDAO {
    // 数据
    var askListData: NSMutableArray!
    
    class var sharedInstance: AskDAO {
        struct Static {
            static var instance: AskDAO?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = AskDAO()
            
            // 测试数据
            //var dataFormatter : NSDateFormatter = NSDateFormatter()
            //dataFormatter.dateFormat = "yyyy-MM-dd"
            let acm = AskCellModel()
            acm.etaskName = "阅读理解"
            acm.createdTime = "2015-12-09"
            acm.classStudentName = "三年五班 韩梅梅"
            acm.title = "这文章中心思想？"
            acm.isAdopted = true
            acm.likeCount = 10
            acm.commentCount = 10
            acm.pictures = ["kewen_img1"];
            
            let acm2 = AskCellModel()
            acm2.etaskName = "Read & Write"
            acm2.createdTime = "2015-12-09"
            acm2.classStudentName = "三年五班 韩梅梅"
            acm2.title = "Are you OK？"
            acm2.isAdopted = true
            acm2.likeCount = 12
            acm2.commentCount = 12
            acm2.pictures = ["kewen_img2","kewen_img3"];
            
            let acm3 = AskCellModel()
            acm3.etaskName = "Read & Write"
            acm3.createdTime = "2015-12-09"
            acm3.classStudentName = "三年五班 韩梅梅"
            acm3.title = "Are you OK？"
            acm3.isAdopted = true
            acm3.likeCount = 12
            acm3.commentCount = 12
            acm3.pictures = ["kewen_img1","kewen_img2","kewen_img3"];
            
            let acm4 = AskCellModel()
            acm4.etaskName = "Read & Write"
            acm4.createdTime = "2015-12-09"
            acm4.classStudentName = "三年五班 韩梅梅"
            acm4.title = "Are you OK？"
            acm4.isAdopted = true
            acm4.likeCount = 12
            acm4.commentCount = 12
            acm4.pictures = ["kewen_img3"];
            
            let acm5 = AskCellModel()
            acm5.etaskName = "Read & Write"
            acm5.createdTime = "2015-12-09"
            acm5.classStudentName = "三年五班 韩梅梅"
            acm5.title = "Are you OK？"
            acm5.isAdopted = true
            acm5.likeCount = 12
            acm5.commentCount = 12
            acm5.pictures = ["kewen_img1","kewen_img2","kewen_img3","kewen_img1","kewen_img2"];
            
            let acm6 = AskCellModel()
            acm6.etaskName = "Read & Write"
            acm6.createdTime = "2015-12-09"
            acm6.classStudentName = "三年五班 韩梅梅"
            acm6.title = "Are you OK？"
            acm6.isAdopted = true
            acm6.likeCount = 12
            acm6.commentCount = 12
            acm6.pictures = ["kewen_img1","kewen_img2","kewen_img3","kewen_img1","kewen_img2","kewen_img3"];
            
            Static.instance?.askListData = NSMutableArray()
            Static.instance?.askListData.addObject(acm)
            Static.instance?.askListData.addObject(acm2)
            Static.instance?.askListData.addObject(acm3)
            Static.instance?.askListData.addObject(acm4)
            Static.instance?.askListData.addObject(acm5)
            Static.instance?.askListData.addObject(acm6)
        }
        return Static.instance!
    }
    
    /// 获取所有信息
    func findAll() -> NSMutableArray {
        return self.askListData
    }
    
    /// 获取英语信息
    func findYingyu() -> NSMutableArray {
        var yingyuList = NSMutableArray()
        yingyuList.addObject(self.askListData[1])
        return yingyuList
    }
}