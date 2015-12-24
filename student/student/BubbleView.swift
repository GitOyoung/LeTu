//
//  BubbleView.swift
//  student
//
//  Created by oyoung on 15/12/20.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit
protocol BubbleViewDelegate: class {
    func bubbleDidDisappear()

}

class BubbleView: UILabel {
    
    var touchPoint: CGPoint!
    
    var delegate: BubbleViewDelegate?

    init(frame: CGRect, backgroundColor: UIColor) {
        touchPoint = CGPoint(x: 0, y: 0)
        super.init(frame: frame)
        self.backgroundColor = backgroundColor
        textAlignment = NSTextAlignment.Center
        layer.cornerRadius = 10
        clipsToBounds = true
        userInteractionEnabled = true
        textColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touchesBegan")
        touchPoint = touches.first?.locationInView(self)
        self.superview?.bringSubviewToFront(self)
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touchesMoved")
        let pt = touches.first?.locationInView(self)
        let dx = (pt?.x)! - touchPoint.x
        let dy = (pt?.y)! - touchPoint.y
        
        let center = CGPoint(x: self.center.x + dx, y: self.center.y + dy)
        UIView.animateWithDuration(0.02) { () -> Void in
            
            self.center = center
        }
        
    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        print("touchesCancelled")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touchesEnded")
        self.removeFromSuperview()
        if delegate != nil {
            delegate?.bubbleDidDisappear()
        }
    }

}
