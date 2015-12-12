//
//  EtaskBL.swift
//  student
//
//  Created by Jiang, Xinxing on 15/12/12.
//  Copyright © 2015年 singlu. All rights reserved.
//

import Foundation

class EtaskBL {
    ///查询所有数据
    func findAll() -> NSMutableArray {
        let dao:EtaskDAO = EtaskDAO()
        return dao.findAll()
    }
}