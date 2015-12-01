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
    
    
    // respone json post request
    func postRequest(url:String,params:NSDictionary){
        print("---------post request-------------")
        print("url:\(url)")
        print("params:\(params)")
        print("---------post request-------------")
        let url = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        Alamofire.request(.POST, url, parameters: params as? [String : AnyObject])
            .responseJSON { response -> Void in
                
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