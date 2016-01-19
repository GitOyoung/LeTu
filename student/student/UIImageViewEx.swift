//
//  UIImageViewEx.swift
//  student
//
//  Created by oyoung on 16/1/18.
//  Copyright © 2016年 singlu. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setImage(url: NSURL, placeholdImage pi: UIImage?) {
        let cacheURL = getCacheURL(url)
        
        if let cateReadData:NSData  = NSData(contentsOfURL: cacheURL) {
            //缓存存在直接加载
            self.image = UIImage(data: cateReadData);
        }else{
            self.image = pi
            dispatch_async(dispatch_get_global_queue(0, 0)) {
                if let data = NSData(contentsOfURL: url) {
                    let image = UIImage(data: data)
                    dispatch_async(dispatch_get_main_queue()){
                        self.image = image
                        //写入缓存文件
                        UIImageJPEGRepresentation(image!, 0.5)!.writeToURL(cacheURL, atomically: true)
                    }
                }
            }
        }
    }
    
    func getCacheURL(url:NSURL) -> NSURL{
        let cachePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory,NSSearchPathDomainMask.AllDomainsMask, true)
        let cacheName:String = (url.path?.md5)!
        let cacheURL:NSURL = NSURL(fileURLWithPath: "\(cachePath[0])/\(cacheName)")
        return cacheURL
    }
}
