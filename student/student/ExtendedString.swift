//
//  ExtendedString.swift
//  student
//
//  Created by luania on 16/1/7.
//  Copyright © 2016年 singlu. All rights reserved.
//

import Foundation


extension String{
    //去掉string最后一个字符
    func clipLastString() -> String{
        if(characters.count > 0){
            return substringToIndex(startIndex.advancedBy(characters.count-1))
        }
        return self
    }
    
    func sha1() -> String {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)!
        var digest = [UInt8](count:Int(CC_SHA1_DIGEST_LENGTH), repeatedValue: 0)
        CC_SHA1(data.bytes, CC_LONG(data.length), &digest)
        let hexBytes = digest.map() { String(format: "%02hhx", $0)}
        return "".join(hexBytes)
    }
    
    func join(strings: [String]) -> String {
        var string: String = ""
        for (i, s) in strings.enumerate() {
            
            string += i < strings.count - 1 ? s + self : s
        }
        return string
    }
    
    func split(string: String) -> [String] {
        return componentsSeparatedByString(string)
    }
    
    
    
    
}