//
//  QuestionTitle.swift
//  student
//
//  Created by zjueman on 15/12/19.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class QuestionTitleView: UIView {
    
    let ordinalLabel:UILabel = UILabel()
    let titleLabel:UILabel = UILabel()

    let ordinalLabelSize = 32
    let marginSpace = 8
    let borderMarginSpace = 16
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        ordinalLabel.text = "1"
        ordinalLabel.textColor = QKColor.whiteColor()
        ordinalLabel.textAlignment = .Center
        ordinalLabel.backgroundColor = QKColor.themeBackgroundColor_1()
        addSubview(ordinalLabel)
        
        titleLabel.text = "单项选择题"
        titleLabel.textColor = QKColor.themeBackgroundColor_1()
        addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        var frame = CGRect(x: borderMarginSpace, y: marginSpace, width: ordinalLabelSize, height: ordinalLabelSize)
        ordinalLabel.frame = frame
        
        frame.origin.x = CGFloat(borderMarginSpace + ordinalLabelSize + marginSpace)
        frame.size.width = 300
        titleLabel.frame = frame
        
    }
    

}
