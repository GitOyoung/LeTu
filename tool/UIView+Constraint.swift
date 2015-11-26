//
//  UIView+Constraint.swift
//  SwiftDemo
//
//  Created by 1 on 15/11/25.
//  Copyright © 2015年 oyoung. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func constrainWithinSuperView() -> Void
    {
        if self.translatesAutoresizingMaskIntoConstraints
        {
            self.translatesAutoresizingMaskIntoConstraints = false;
        }
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: self.superview, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0.0));
        
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: self.superview, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0));
        
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: self.superview, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0));
        
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: self.superview, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0));
        
    }
   
    func constrainSize(size: CGSize) ->Void
    {
        if self.translatesAutoresizingMaskIntoConstraints
        {
            self.translatesAutoresizingMaskIntoConstraints = false;
        }
        var array: [NSLayoutConstraint] = [];
        let hConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:[self(theWidth@750)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["theWidth":size.width], views: ["self":self]);
        let vConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:[self(theHeight@750)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["theHeight": size.height], views: ["self": self]);
        
        for elem in hConstraint
        {
            array.append(elem);
        }
        for elem in vConstraint
        {
            array.append(elem);
        }
        
        self.addConstraints(array);
    }
    
    func constrainOrigin(point: CGPoint) ->Void
    {
        if self.superview == nil
        {
            return;
        }
        if self.translatesAutoresizingMaskIntoConstraints
        {
            self.translatesAutoresizingMaskIntoConstraints = false;
        }
        
        let hConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.superview, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: point.x);
        let vConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.superview, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: point.y);
        self.superview!.addConstraint(hConstraint);
        self.superview!.addConstraint(vConstraint);
    }
    
    func constrainCenter(center: CGPoint) -> Void
    {
        if self.superview == nil
        {
            return;
        }
        if self.translatesAutoresizingMaskIntoConstraints
        {
            self.translatesAutoresizingMaskIntoConstraints = false;
        }
        
        
        let hConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.superview, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: center.x);
        let vConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.superview, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: center.y);
        
        self.superview!.addConstraint(hConstraint);
        self.superview!.addConstraint(vConstraint);
    }
}
