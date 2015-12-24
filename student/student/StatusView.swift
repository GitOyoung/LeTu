//
//  StatusView.swift
//  student
//
//  Created by oyoung on 15/12/24.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class StatusView: UIView {

    var statusView: UIImageView
    
    let dateOverImage: UIImageView
    let dateBeginImage: UIImageView
    
    let countLabel: UILabel
    let dateOverLabel: UILabel
    let dateBeginLabel: UILabel
    
    
    var beginTime: (Int, Int) = (0, 0) {
        didSet {
            dateBeginLabel.text = "\(beginTime.0):\(beginTime.1)"
        }
    }
    var overTime: (Int, Int) = (0, 0) {
        didSet {
            dateOverLabel.text = "\(overTime.0):\(overTime.1)"
        }
    }
    var count: (Int, Int) = (0, 0) {
        didSet {
            countLabel.text = "\(count.0)/\(count.1)"
        }
    }
    
    var status: EtaskStatus
    
    init(status: EtaskStatus) {
        self.status = status
        statusView = UIImageView(frame: CGRect(x: 0, y: 0, width: 54, height: 22))
        dateOverImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        dateBeginImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        countLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 10))
        dateOverLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 10))
        dateBeginLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 10))
        super.init(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        setupStatusImage()
        setupStatusLabel()
    }
    
    func setupStatusImage()
    {
        switch status
        {
        case .New:
            statusView.image = UIImage(named: "newTask")
        case .Unfinished:
            statusView.image = UIImage(named: "noDoneTask")
        default:
            statusView.hidden = true
        }
        dateOverImage.image = UIImage(named: "date_over")
        dateBeginImage.image = UIImage(named: "date_begin")
        
        addSubview(statusView)
        addSubview(dateOverImage)
        addSubview(dateBeginImage)
        
    }
    
    func setupStatusLabel()
    {
        let textColor = UIColor(white: 51.0/255, alpha: 1.0)
        let font = UIFont.systemFontOfSize(10)
        countLabel.textColor = textColor
        countLabel.textAlignment = .Left
        countLabel.font = font
        
        dateBeginLabel.textColor = textColor
        dateOverLabel.textColor = textColor
        dateOverLabel.font = font
        dateBeginLabel.font = font
        dateBeginLabel.textAlignment = .Right
        dateOverLabel.textAlignment = .Right
        
        
        dateBeginLabel.text = "20:30"
        dateOverLabel.text = "17:30"
        countLabel.text = "10/20"
        
        addSubview(countLabel)
        addSubview(dateOverLabel)
        addSubview(dateBeginLabel)
    }
    
    override func layoutSubviews() {
        var frame = bounds
        frame.origin.y = 4
        frame.size.width = statusView.frame.width
        frame.size.height = statusView.frame.height
        frame.origin.x = bounds.width - frame.width
        statusView.frame = frame
        
        
        frame = countLabel.frame
        frame.origin.x = 10
        frame.origin.y = 42
        countLabel.frame = frame
        
        frame = dateOverImage.frame
        frame.origin.x = bounds.width - 15
        frame.origin.y = 44
        dateOverImage.frame = frame
        frame.origin.y += 15
        dateBeginImage.frame = frame
        
        
        frame = dateOverLabel.frame
        frame.origin.x = bounds.width - 19 - frame.width
        frame.origin.y = 42
        dateOverLabel.frame = frame
        frame.origin.y += 20
        dateBeginLabel.frame = frame
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
