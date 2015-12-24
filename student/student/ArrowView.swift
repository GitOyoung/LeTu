//
//  ArrowView.swift
//  Arrow
//
//  Created by oyoung on 15/12/23.
//  Copyright © 2015年 oyoung. All rights reserved.
//

import UIKit

enum ArrowDirection
{
    case Up
    case Down
    case Left
    case Right
}

class ArrowView: UIView {

    var arrowHidden: Bool = false {
        didSet {
            arrow?.hidden = arrowHidden
        }
    }
    var arrowSize: CGFloat = 5.0 {                  //箭头大小
        didSet {
            arrrowSizeChanged(size: arrowSize)
        }
    }
    var arrowDirection: ArrowDirection = .Up {      //箭头方向
        didSet {
            arrowDirectionChanged(direction: arrowDirection)
        }
    }
    
    var arrowOffset: CGFloat = 0.0                //箭头位置偏移
 
    var cornerRadius: CGFloat = 0.0 {               //圆角半径
        didSet {
            layer.cornerRadius = cornerRadius
            main?.layer.cornerRadius = cornerRadius
        }
    }
    
    var backColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5) {
        didSet {
            arrow?.backgroundColor = backColor
            main?.backgroundColor = backColor
        }
    }
    var arrowContainer: UIView?
    var arrow: UIView?                              //箭头
    var main: UIView?                               //主体
    var contentInset: UIEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    var contentChangeFrame: Bool = false
    var contentView: UIView? {
        
        willSet {
            if contentView != nil {
                contentView?.removeFromSuperview()
            }
        }
        didSet {
            contentViewHasSet()
        }
    }
    
    
    init()
    {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        setupSubViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func contentViewHasSet()
    {
        if var f = contentView?.frame
        {
            if contentChangeFrame
            {
                switch arrowDirection
                {
                case .Up, .Down:
                    f.size.height += contentInset.top + contentInset.bottom + arrowSize
                case .Left, .Right:
                    f.size.width  += contentInset.left + contentInset.right + arrowSize
                }
                frame = f
            }
        }
        main?.addSubview(contentView!)
    }
    
    func setupSubViews()
    {
        let w0 = arrowSize * sqrt(2.0)
        let w1 = arrowSize * 2
        main = UIView()
        arrowContainer = UIView(frame: CGRect(x: 0, y: 0, width: w1, height: w1))
        arrow = UIView(frame: CGRect(x: 0, y: 0, width: w0, height: w0))
        backgroundColor = UIColor.clearColor()
        
        main?.backgroundColor = backColor
        arrow?.backgroundColor = backColor
        layer.cornerRadius = cornerRadius
        main?.layer.cornerRadius = cornerRadius
        arrowContainer?.backgroundColor = UIColor.clearColor()
        arrowContainer?.clipsToBounds = true
        
        arrow?.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
        updateDirection()
        arrowContainer!.addSubview(arrow!)
        addSubview(main!)
        addSubview(arrowContainer!)
        
    }
    
    
    func updateLayout()
    {
        //布局main主体视图
        mainLayout()
        //布局箭头视图
        arrowLayout()
        //布局内容视图
        contentLayout()
    }
    
    func mainLayout()
    {
        var frame = bounds
        switch arrowDirection
        {
        case .Up:
            frame.origin.y += arrowSize
            frame.size.height -= arrowSize
        case .Down:
            frame.size.height -= arrowSize
        case .Left:
            frame.origin.x += arrowSize
            frame.size.width -= arrowSize
        case .Right:
            frame.size.width -= arrowSize
        }
        main?.frame = frame
    }
    
    func arrowLayout()
    {
        var center: CGPoint = CGPoint(x: 0, y: 0)
        let distance = cornerRadius + arrowSize + arrowOffset
        switch arrowDirection
        {
        case .Up:
            center.x = distance
            center.y = (main?.frame.origin.y)! - arrowSize
        case .Down:
            center.x = distance
            center.y = (main?.frame.origin.y)! + (main?.frame.height)! + arrowSize
        case .Left:
            center.x = (main?.frame.origin.x)! - arrowSize
            center.y = distance
        case .Right:
            center.x = (main?.frame.origin.x)! + (main?.frame.width)! + arrowSize
            center.y = distance
        }
        arrowContainer?.center = center
    }
    
    func contentLayout()
    {
        if let v = contentView
        {
            var frame = v.frame
            frame.origin.x = contentInset.left
            frame.origin.y = contentInset.top
            frame.size.width = (main?.frame.width)! - contentInset.left - contentInset.right
            frame.size.height = (main?.frame.height)! - contentInset.top - contentInset.bottom
            v.frame = frame
        }
    }
    
 
    
    func arrrowSizeChanged(size s: CGFloat)
    {
        if var frm = main?.frame
        {
            switch arrowDirection
            {
            case .Up, .Down:
                frm.size.height += arrowSize
            case .Left, .Right:
                frm.size.width += arrowSize
            }
            frame = frm
            arrowContainer?.frame = CGRect(x: 0, y: 0, width: arrowSize * 2, height: arrowSize * 2)
        }
    }
    
    func arrowOffsetValiden(offset o: CGFloat) -> CGFloat
    {
        var distance = self.cornerRadius + self.arrowSize + o
        if let m = main
        {
            
            let h = m.frame.size.height
            let w = m.frame.size.width
            let maxVDistance = h - self.cornerRadius - self.arrowSize
            let maxHDistance = w - self.cornerRadius - self.arrowSize
            switch arrowDirection
            {
            case .Up, .Down:
                distance = min(distance, maxVDistance)
            case .Left, .Right:
                distance = min(distance, maxHDistance)
            }
            return (distance - self.cornerRadius - self.arrowSize)
            
        }
        return 0.0
    }

    func updateDirection()
    {
        if var center = arrow?.center
        {
            switch arrowDirection
            {
            case .Up:
                center.x = arrowSize
                center.y = arrowSize * 2
            case .Down:
                center.x = arrowSize
                center.y = 0
            case .Left:
                center.x = arrowSize * 2
                center.y = arrowSize
            case .Right:
                center.x = 0
                center.y = arrowSize
            }
            arrow?.center = center
        }
    }
    
    func arrowDirectionChanged(direction d: ArrowDirection)
    {
        updateDirection()
    }
    
    override func layoutSubviews()
    {
        updateLayout()
    }
}
