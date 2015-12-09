//
//  AskTableViewCell.swift
//  student
//
//  Created by Jiang, Xinxing on 15/11/18.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class AskTableViewCell: UITableViewCell {

    @IBOutlet weak var etaskNameLabel: UILabel!
    @IBOutlet weak var adoptView: UIView!
    @IBOutlet weak var createdTimeLabel: UILabel!
    @IBOutlet weak var classStudentNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var picturesView: UIView!
    
    @IBOutlet weak var likeCountLable: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    
    func initCell(data: AskCellModel) {
        // set adopt
        if (data.isAdopted) {
            let bottomBorder = CALayer.init()
            bottomBorder.frame = CGRectMake(self.adoptView.frame.origin.x,self.adoptView.frame.height, self.adoptView.frame.width, 0.5)
            bottomBorder.backgroundColor = QKColor.lightGrayColor().CGColor
            self.adoptView.layer.addSublayer(bottomBorder)
        } else {
            self.adoptView.hidden = true
        }
        
        // set lables
        self.etaskNameLabel.text = data.etaskName as? String
        self.createdTimeLabel.text = (data.createdTime as? String)! + "  来自"
        self.classStudentNameLabel.text = data.classStudentName as? String
        self.titleLabel.text = data.title as? String
        
        // set images
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
