//
//  ServiceApi.swift
//  student
//
//  Created by zhaoheqiang on 15/11/17.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class ServiceApi: NSObject {
    
    static var host:String = "http://115.236.59.29:8788"
        
//    internal class func getBookUrl(type:Int,maxId:Int,count:Int) -> String{
//        
//        let url="\(host)/api/books/\(type)/\(maxId)/\(count)"
//        return url
//    }
    
    class func getLoginUrl()->String {
        let url = "\(host)/http/login.html"
        return url;
    }
    
    class func getEtaskListUrl()->String{
        let url = "\(host)/http/etaskrecordlist.html"
        return url;
    }
    
    class func getSearchEtaskListUrl()->String{
        let url = "\(host)/http/etaskrecordlistforpage.html"
        return url;
    }
    
    class func getEtaskDetailUrl()->String {
        let url = "\(host)/http/etaskrecord.html"
        return url
    }
    
    class func getAskListUrl()->String{
        let url = "\(host)/http/getlearninteractivelist.html"
        return url
    }
    
    class func getAskDetailUrl()->String{
        let url = "\(host)/http/getlearninteractive.html"
        return url
    }
    
    class func getAnswerListUrl()->String{
        let url = "\(host)/http/getlearninteractiveanswerlist.html"
        return url
    }
}
