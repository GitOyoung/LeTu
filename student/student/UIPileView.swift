//
//  UIPileView.swift
//  student
//
//  Created by oyoung on 15/12/30.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

extension UIView
{
    func insetsToView(view: UIView, inset: UIEdgeInsets)
    {
        if let sv = self.superview
        {
            sv.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: inset.left))
            sv.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -inset.right))
            sv.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: inset.top))
            sv.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -inset.bottom))
        }
    }
}

class UIPileView: UIView {
    override func layoutSubviews() {
        for view in subviews {
            view.frame = bounds
        }
    }
    

}
