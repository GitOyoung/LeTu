//
//  EtaskDAO.swift
//  student
//
//  Created by Jiang, Xinxing on 15/12/12.
//  Copyright © 2015年 singlu. All rights reserved.
//

import Foundation

class EtaskDAO {
//    private static let _sharedInstance = EtaskDAO()
//    
//    class func getSharedInstance() -> EtaskDAO {
//        return _sharedInstance
//    }
//    
//    private init() {}
    
    var etaskListData: NSMutableArray = NSMutableArray()
    
    var http: HttpRequest = HttpRequest()
    

//    func didreceiveResult(result: NSDictionary) {
//        let resultData = result["data"] as! NSMutableArray
//        for etask in resultData {
//            var e = EtaskModel(info: etask as! NSDictionary)
//            etaskListData.addObject(e)
//        }
//    }
    
    ///获取etask列表
    func findAll() -> NSMutableArray {
//        http.delegate = self
//        let url = ServiceApi.getSearchEtaskListUrl()
//        if LTConfig.defaultConfig().defaultUser != nil
//        {
//            
//            let student:Student = LTConfig.defaultConfig().defaultUser!
//            /*
//            userId	Long	是		用户ID
//            orderDate	Integer	是	1	是否按作业开始日期排序类型 (1:是 0:否)
//            status	Integer	是	0	状态,按照作业状态进行筛选
//            0:全部 1:未开始 2:未完成 3:未批改 4:未订正 5:已完成
//            subject	Integer	是	0	科目,按照科目进行筛选
//            0:全部 1:语文 2:数学 3:英语 (暂时只是小学阶段语数外)
//            timeSlice	Integer	是	0	按照时间段来筛选
//            0:全部 1:当天 2:本周 3:当月 4:本学期
//            etaskType	Integer	是	0	作业类型 0:全部 1:随堂练习 2:假期作业
//            pageIndex	Integer	是	0	获取数据的页面索引,默认为0
//            pageSize	Integer	是	10	每次获取数据的数量,默认为10
//            accessToken
//            */
//            var params = [String:AnyObject]()
//            params["userId"] = student.uuid
//            params["orderDate"] = 1
//            params["status"] = 0
//            params["subject"] = 0
//            params["timeSlice"] = 0
//            params["etaskType"] = 0
//            params["pageIndex"] = 0
//            params["pageSize"] = 10
//            params["accessToken"] = student.accessToken
//            //http.postRequest(url, params: params)
//        }
        let etask1: EtaskModel = EtaskModel()
        etask1.name = "作业名称"
        etask1.subTitle = "五年级下学期 ／ 二年级一班 30人"
        etask1.summary = "同步练习作业"
        etaskListData.addObject(etask1)
        return etaskListData
    }
}