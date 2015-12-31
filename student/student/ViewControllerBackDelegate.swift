//
//  ViewControllerBackDelegate.swift
//  student
//
//  Created by oyoung on 15/12/28.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

enum BackStyle
{
    case NavPop
    case Dismiss
}

protocol ViewControllerBackDelegate: class {
    func style() -> BackStyle
    func back(style s: BackStyle)
}
