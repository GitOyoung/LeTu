//
//  UIHCenterView.swift
//  student
//
//  Created by oyoung on 16/1/22.
//  Copyright © 2016年 singlu. All rights reserved.
//

import UIKit

class UIHCenterView: UIView {

    
    override func layoutSubviews() {
        var frame = CGRectZero
        for v in subviews {
            frame = v.frame
            frame.origin.y = (bounds.height - frame.height) / 2
            v.frame = frame
        }
    }
   
}
