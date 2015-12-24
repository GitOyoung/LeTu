//
//  UIPopMenuButton.swift
//  student
//
//  Created by oyoung on 15/12/23.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class UIPopMenuButton: UIButton {

    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        
        if action == Selector("sort:")
        {
            return true
        }
        else
        {
            return false
        }
    }
    
}
