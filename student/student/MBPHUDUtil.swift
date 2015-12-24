//
//  MBPHUDUtil.swift
//  student
//
//  Created by luania on 15/12/23.
//  Copyright © 2015年 singlu. All rights reserved.
//
import Foundation
import MBProgressHUD

class MBPHUDUtil{
    
    class func toastText(view:UIView!,text:String){
        let hud = MBProgressHUD.showHUDAddedTo(view, animated:true)
        hud.mode = MBProgressHUDMode.Text
        hud.labelText = text
        let rect:CGRect = UIScreen.mainScreen().bounds
        hud.yOffset = Float(rect.height)/4
        hud.hide(true,afterDelay: 2)
    }
}