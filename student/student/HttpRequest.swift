//
//  HttpRequest.swift
//  student
//
//  Created by zhaoheqiang on 15/11/17.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit
import Alamofire

protocol HttpProtocol {
    func didreceiveResult(result:NSDictionary)
}

class HttpRequest:NSObject {
    
    var delegate:HttpProtocol?
    
    
    // response json get request
    func getJsonRequest(url:String,params:NSDictionary){
        Alamofire.request(.GET, url, parameters: params as? [String : AnyObject])
            .responseJSON { response in
                
                let data = response.data
                
                let jsonResult:NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                self.delegate?.didreceiveResult(jsonResult)
        }
    }
    
    // post request json
    func postRequestJson(url:String,params:NSDictionary){
        print("开始提交JSON请求")
        let url = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        Alamofire.request(.POST, url, parameters: params as? [String : AnyObject], encoding: .JSON, headers: nil).responseJSON { (response) -> Void in
            debugPrint(response)
            let data = response.data
            
            do {
                let jsonResult:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                self.delegate?.didreceiveResult(jsonResult)
            }
            catch
            {
                let string:NSString = NSString(data: data!, encoding: 4)!
                print(string)
            }

        }
//        let url = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
//        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
//        request.HTTPMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: [])
//        print("---------post request-------------")
//        print("url:\(url)")
//        print("userId:\(params["userId"])")
//        print("value:\(request.HTTPBody)")
//        print("---------post request-------------")
//        Alamofire.request(request)
//            .responseJSON { response in
//
//            debugPrint(response)
//        }
    }
    
    
    // respone json post request
    func postRequest(url:String,params:NSDictionary){
        print("---------post request-------------")
        print("url:\(url)")
        print("params:\(params)")
        print("---------post request-------------")
        let url = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        Alamofire.request(.POST, url, parameters: params as? [String : AnyObject])
            .responseJSON { response -> Void in
                debugPrint(response)
                let data = response.data

                do {
                    let jsonResult:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    self.delegate?.didreceiveResult(jsonResult)
                }
                catch
                {
                    let string:NSString = NSString(data: data!, encoding: 4)!
                    print(string)
                }
        }
    }
    
    // respone json upload post request
    func uploadRequest(url:String,firlUrl:NSURL){
        Alamofire.upload(.POST, url, file: firlUrl).responseJSON { response -> Void in
            let data = response.data
            
            let jsonResult:NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
            self.delegate?.didreceiveResult(jsonResult)
        }
    }
    
    
}