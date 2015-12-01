//
//  ServiceApi.swift
//  student
//
//  Created by zhaoheqiang on 15/11/17.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class ServiceApi: NSObject {
    
    static let host:String = "http://115.236.59.29:8788"
    
    //登录
    class func getLoginUrl()->String {
        let url = "\(host)/http/login.html"
        return url;
    }
    
    //电子作业列表
    class func getEtaskListUrl()->String{
        let url = "\(host)/http/etaskrecordlist.html"
        return url;
    }
    
    //电子作业搜索列表
    class func getSearchEtaskListUrl()->String{
        let url = "\(host)/http/etaskrecordlistforpage.html"
        return url;
    }
    
    //电子作业详情
    class func getEtaskDetailUrl()->String {
        let url = "\(host)/http/etaskrecord.html"
        return url
    }
    
    //提交电子作业
    class func getEtasksubmitUrl()->String{
        let url = "\(host)/http/submitetask.html"
        return url
    }
    
    //订正电子作业
    class func getCorrectEtaskUrl()->String{
        let url = "\(host)/http/correctetask.html"
        return url
    }
    
    //上传文件
    class func getUploadFileUrl()->String{
        let url = "\(host)/http/uploadfile.html"
        return url
    }
    
    //添加互动
    class func getAddAskUrl()->String{
        let url = "\(host)/http/addlearninteractive.html"
        return url
    }
    //互动列表
    class func getAskListUrl()->String{
        let url = "\(host)/http/getlearninteractivelist.html"
        return url
    }
    
    //互动详情
    class func getAskDetailUrl()->String{
        let url = "\(host)/http/getlearninteractive.html"
        return url
    }
    
    //互动回复列表
    class func getAnswerListUrl()->String{
        let url = "\(host)/http/getlearninteractiveanswerlist.html"
        return url
    }
    
    //添加互动回复
    class func getAddAnswerUrl()->String{
        let url = "\(host)/http/addlearninteractiveanswer.html"
        return url
    }
}
