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
            let subIndex = startIndex.advancedBy(characters.count-1)
            return substringToIndex(subIndex)
        }
        return self
    }
}