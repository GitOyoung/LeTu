//
//  DanxuanAnswerControl.swift
//  student
//
//  Created by zjueman on 15/12/19.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class DanxuanAnswerControl: UIView {
    var rating = 0 {
        didSet {
            updateStarStatus()
        }
    }
    
    var buttons = [UIButton]()
    
    let buttonHeight = 44
    let buttonWidth = 44
    let buttonSpace = 5
    let starNumber = 5
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let emptyStar = UIImage(named: "emptyStar")
        let filledStar = UIImage(named: "filledStar")
        
        for i in 0..<starNumber {
            print("创建第\(i)个按钮")
            let button = UIButton()
            button.backgroundColor = UIColor.redColor()
            button.addTarget(self, action: "ratingControlTapped:", forControlEvents: .TouchDown)
            
            button.setImage(emptyStar, forState: .Normal)
            button.setImage(filledStar, forState: .Selected)
            button.setImage(filledStar, forState: [.Highlighted, .Selected])
            
            button.adjustsImageWhenHighlighted = false
            
            buttons += [button]
            
            addSubview(button)
        }
        
        updateStarStatus()
    }
    
    override func layoutSubviews() {
        print("layoutSubViews")
        var frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        for(index, button) in buttons.enumerate() {
            frame.origin.x = CGFloat(index * (buttonWidth + buttonSpace))
            button.frame = frame
        }
    }
    
    func ratingControlTapped(button: UIButton) {
        rating = buttons.indexOf(button)! + 1
        print("你评分\(rating)分")
        updateStarStatus()
    }
    
    func updateStarStatus() {
        for (index, button) in buttons.enumerate() {
            button.selected = index < rating
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: (buttonWidth + buttonSpace) * starNumber, height: buttonHeight)
    }
    
}