//
//  QIndexCollectionViewCell.swift
//  student
//
//  Created by oyoung on 16/1/22.
//  Copyright © 2016年 singlu. All rights reserved.
//

import UIKit

class QIndexCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ContentLabel: UILabel!
    
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            ContentLabel.layer.cornerRadius = newValue
            layer.cornerRadius = newValue
        }
    }

    var text: String? {
        get {
            return ContentLabel.text
        }
        set {
            ContentLabel.text = newValue
        }
    }
    
    var textColor: UIColor? {
        get {
            return ContentLabel.textColor
        }
        set {
            ContentLabel.textColor = newValue
        }
    }
    
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            ContentLabel.layer.borderWidth = newValue
            layer.borderWidth = newValue
        }
    }
    
    var bgColor: UIColor? {
        get {
            return ContentLabel.backgroundColor
        }
        set {
            ContentLabel.backgroundColor = newValue
        }
    }
    var borderColor: CGColor? {
        get {
            return layer.borderColor
        }
        set {
            ContentLabel.layer.borderColor = newValue
            layer.borderColor = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ContentLabel.textAlignment = .Center
    }

}
