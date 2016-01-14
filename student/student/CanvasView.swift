//
//  canvasView.swift
//  student
//
//  Created by luania on 16/1/12.
//  Copyright © 2016年 singlu. All rights reserved.
//

import Foundation
import UIKit

class CanvasView:UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        multipleTouchEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let bezierPath = UIBezierPath()
    
    var oldPoint:CGPoint!
    var fromPoint:CGPoint!
    var toPoint:CGPoint!
    
    override func drawRect(rect: CGRect) {
        if(oldPoint == nil){
            if(toPoint != nil){
                
            }
            return
        }
        let startPoint = getCenterPoint(oldPoint, toPoint: fromPoint)
        let endPoint = getCenterPoint(fromPoint, toPoint: toPoint)
        bezierPath.moveToPoint(startPoint)
        bezierPath.addQuadCurveToPoint(endPoint, controlPoint: fromPoint)
        bezierPath.lineWidth = 5
        bezierPath.stroke()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        oldPoint = nil
        fromPoint = nil
        toPoint = touches.first!.locationInView(self)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        oldPoint = fromPoint
        fromPoint = toPoint
        toPoint = touches.first!.locationInView(self)
        if(oldPoint != nil){
            setNeedsDisplay()
        }
    }
    
    func getCenterPoint(fromPoint:CGPoint,toPoint:CGPoint) -> CGPoint{
        let centerX = (fromPoint.x+toPoint.x)/2
        let centerY = (fromPoint.y+toPoint.y)/2
        return CGPointMake(centerX, centerY)
    }
}