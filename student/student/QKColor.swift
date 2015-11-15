//
//  QKColor.swift
//  student
//
//  Created by Jiang, Xinxing on 15/11/15.
//  Copyright © 2015年 singlu. All rights reserved.
//

import Foundation
import UIKit

class QKColor: UIColor {
    /// blue: Hex: 0080FD Alpha:0.95
    class func themeBackgroundColor_1() -> UIColor {
        return makeColorWithHexString("0080FD", alpha: 0.95)
    }
    
    /// light gray: Hex: F0EFF5 Alpha:0.95
    class func themeBackgroundColor_2() -> UIColor {
        return makeColorWithHexString("F0EFF5", alpha: 1.0)
    }
    
    /// black
    class func themeFontColor_1() -> UIColor {
        return blackColor()
    }
    
    /// gray: Hex: 999999 Alpha:1.0
    class func themeFontColor_2() -> UIColor {
        return makeColorWithHexString("999999", alpha: 1.0)
    }
    
    /// make color with hex string and alpha.
    class func makeColorWithHexString (hex: String, alpha: Float) -> UIColor {
        let cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if(cString.characters.count != 6) {
            return UIColor.clearColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
        
    }
}