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
    
    var md5: String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.dealloc(digestLen)
        return String(format: hash as String)
    }
    
    
}