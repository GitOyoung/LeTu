//
//  HttpUtil.swift
//  student
//
//  Created by Jiang, Xinxing on 15/12/12.
//  Copyright © 2015年 singlu. All rights reserved.
//

import Foundation
import Alamofire
class HttpUtil:NSObject {
    
    // response json get request
    class func getJsonRequest(url:String,params:NSDictionary) -> NSDictionary{
        var jsonResult:NSDictionary = NSDictionary()
        Alamofire.request(.GET, url, parameters: params as? [String : AnyObject])
            .responseJSON { response in
                
                let data = response.data
                
                jsonResult = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
        }
        return jsonResult
    }
    
    
    // respone json post request
    class func postRequest(url:String,params:NSDictionary)  -> NSDictionary{
        print("---------post request-------------")
        print("url:\(url)")
        print("params:\(params)")
        print("---------post request-------------")
        let url = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        var jsonResult:NSDictionary = NSDictionary()
        Alamofire.request(.POST, url, parameters: params as? [String : AnyObject])
            .responseJSON { response -> Void in
                
                let data = response.data
                
                do {
                    jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                }
                catch
                {
                    let string:NSString = NSString(data: data!, encoding: 4)!
                    print(string)
                }
        }
        return jsonResult
    }
}