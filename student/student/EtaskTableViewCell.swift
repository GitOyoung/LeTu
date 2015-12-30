//
//  EtaskTableViewCell.swift
//  student
//
//  Created by oyoung on 15/12/1.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class EtaskTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    
    func initCell(data:EtaskModel) {
        
        titleLabel.text = data.name!
        detailLabel.text = data.subTitle!
        typeLabel.text = data.summary!
        setupStatusContent(data)
    }
    
    func setupStatusContent(data: EtaskModel?)
    {
        for view in statusView.subviews
        {
            view.removeFromSuperview()
        }
        if let d = data
        {
            switch d.status
            {
            case .Finished, .Uncorrecting:
                setupProgressView(d.status, totalCount: d.questionCount!, correct: 0)
            default:
                setupUnfinishedView(status: d.status)
                break
            }
        }
    }
    
    func setupUnfinishedView(status s: EtaskStatus)
    {
        let status = StatusView(status: EtaskStatus.New)
        statusView.addSubview(status)
    }
    
    func setupProgressView(status:EtaskStatus, totalCount: Int, correct: Int)
    {
        let s: EtaskStatus
        switch status
        {
        case .Finished:
            s = .Finished
        default:
            s = .Unfinished
        }
        let statusProgressView = ProgressView(status: s, totalCount: totalCount, correctCount: correct)
        var frame = statusProgressView.frame
        frame.origin.x = 14
        frame.origin.y = 16
        statusProgressView.frame = frame
//        statusProgressView.backgroundColor = UIColor.cyanColor()
//        statusView.backgroundColor = UIColor.yellowColor()
        statusView.addSubview(statusProgressView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
