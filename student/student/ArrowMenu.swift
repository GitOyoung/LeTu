//
//  ArrowMenu.swift
//  Arrow
//
//  Created by oyoung on 15/12/24.
//  Copyright © 2015年 oyoung. All rights reserved.
//

import UIKit

protocol ArrowMenuDelegate : class
{
    func numberOfColunm(menu: ArrowMenu) -> Int
    func arrowMenu(menu: ArrowMenu, numnerOfRowInColunm: Int) -> Int
    func arrowMenu(menu: ArrowMenu, insetForRow row: Int, colunm: Int) -> UIEdgeInsets
    func arrowMenu(menu: ArrowMenu, widthForColunm colunm: Int) -> CGFloat
    func arrowMenu(menu: ArrowMenu, heightForRow row: Int, colunm: Int) -> CGFloat
    func arrowMenu(menu: ArrowMenu, itemForRow row: Int, colunm: Int) -> MenuItem
    func arrowMenu(menu: ArrowMenu, canBeSelectedAtRow row: Int, colunm: Int) -> Bool
    func arrowMenu(menu: ArrowMenu, didSelectAtRow row: Int, colunm: Int)
}

class MenuItem: UILabel {
}

enum MenuItemKey
{
    case None
    case MenuItemKey(Int)
}


class ArrowMenu: ArrowView, UIScrollViewDelegate {
    
    

    
    var keys: [MenuItemKey]?
    var items: [Int : MenuItem]?
 
    
    var maxColunmCount: Int = 1 {
        didSet {
            setupItemKeys()
        }
    }
    var maxRowCount: Int = 4 {
        didSet {
            setupItemKeys()
        }
    }

    unowned let delegate: ArrowMenuDelegate
    
    init(frame: CGRect, delegate d: ArrowMenuDelegate) {
        delegate = d
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
        contentView = UIView(frame: frame)
        setupItemKeys()
        setupItems()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupItemKeys()
    {
        let size = maxColunmCount * maxRowCount
        keys = [MenuItemKey]()
        for _ in 0..<size
        {
            keys?.append(.None)
        }
    }
    
    func setupItems()
    {
        let d = delegate
        let colunmCount = min(d.numberOfColunm(self), maxColunmCount)
        for col in 0..<colunmCount
        {
            let row = min(d.arrowMenu(self, numnerOfRowInColunm: col), maxRowCount)
            for r in 0..<row
            {
                let item = d.arrowMenu(self, itemForRow: r, colunm: col)
                self[r, col] = item
            }
        }
    }
    //触摸事件
    var touchPoint: CGPoint = CGPointZero
    var touchItem: (Int, Int) = (0, 0)
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchPoint = (touches.first?.locationInView(self))!
        let (r, c) = pointToIndex(point: touchPoint)
        if r != -1 && c != -1
        {
            touchItem = (r, c)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let pt = (touches.first?.locationInView(self))!
        let dx = pt.x - touchPoint.x
        let dy = pt.y - touchPoint.y
        contentInset.left += dx
        contentInset.right -= dx
        contentInset.top += dy
        contentInset.bottom -= dy
 
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let d = delegate
        let pt = (touches.first?.locationInView(self))!
        let (r, c) = pointToIndex(point: pt)
        if r == touchItem.0 && c == touchItem.1
        {
            if d.arrowMenu(self, canBeSelectedAtRow: r, colunm: c)
            {
                d.arrowMenu(self, didSelectAtRow: r, colunm: c)
            }
            
            print("\(pt.x), \(pt.y)")
        }
    }
    
    func pointToIndex(point pt: CGPoint) -> (Int, Int)
    {
        let d = delegate
        var dx = pt.x - contentInset.left
        var dy = pt.y - contentInset.top
        var c = 0
        var r = 0
        var w = d.arrowMenu(self, widthForColunm: c)
        var h = d.arrowMenu(self, heightForRow: r, colunm: c)
        while dx >= w
        {
            dx -= w
            c++        
            w = d.arrowMenu(self, widthForColunm: c)
        }
        while dy >= h
        {
            dy -= h
            r++
            h = d.arrowMenu(self, heightForRow: r, colunm: c)
        }
        let inset = d.arrowMenu(self, insetForRow: r, colunm: c)
        if dx < inset.left || dx > w - inset.right || dy < inset.top || dy > h - inset.bottom
        {
            r = -1
            c = -1
        }
        if r >= maxRowCount
        {
            r = -1
        }
        if c >= maxColunmCount
        {
            c = -1
        }
        return (r, c)
    }
    
    func reloadData()
    {
        setupItems()
        updateLayout()
    }
    
    func updateLayoutItems()
    {
        var origin = CGPoint(x: contentInset.left, y: contentInset.top)
        let d = delegate
        let colunmCount = min(d.numberOfColunm(self), maxColunmCount)
        for c in 0..<colunmCount
        {
            let row = min(d.arrowMenu(self, numnerOfRowInColunm: c), maxRowCount)
            let width = d.arrowMenu(self, widthForColunm: c)
            for r in 0..<row
            {
                let item = d.arrowMenu(self, itemForRow: r, colunm: c)
                let inset = d.arrowMenu(self, insetForRow: r, colunm: c)
                
                let height = d.arrowMenu(self, heightForRow: r, colunm: c)
                var frame = CGRectZero
                frame.size.width = width - inset.left - inset.right
                frame.size.height = height - inset.top - inset.bottom
                frame.origin.x = origin.x + inset.left
                frame.origin.y = origin.y + inset.top
                item.frame = frame
                origin.y += height
            }
            origin.x += width
            origin.y = contentInset.top
        }
    }
    
    override func updateLayout()
    {
        super.updateLayout()
        updateLayoutItems()
    }
    
    
    
    subscript(row: Int,colunm: Int) -> MenuItem? {
        get {
            let key = keys![colunm * maxColunmCount + row]
            if case let .MenuItemKey(i) = key
            {
                return items![i]
            }
            else
            {
                return nil
            }
        }
        set {
            if items == nil
            {
                items = [Int:MenuItem]()
            }
            let v = colunm * maxColunmCount + row
            let key = MenuItemKey.MenuItemKey(v)
            keys![v] = key
            items![v] = newValue!
            contentView!.addSubview(newValue!)            
        }
    }

}
