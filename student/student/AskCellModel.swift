//
//  AskCellModel.swift
//  student
//
//  Created by Jiang, Xinxing on 15/12/5.
//  Copyright © 2015年 singlu. All rights reserved.
//

import Foundation

class AskCellModel: NSObject {
    var etaskName: NSString?
    var createdTime: NSString?
    var classStudentName: NSString?
    var title: NSString?
    var pictures: [NSString] = []
    var likeCount: Int = 0
    var commentCount: Int = 0
    var isAdopted: Bool = false
}