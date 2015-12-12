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
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!
    @IBOutlet weak var image6: UIImageView!
    @IBOutlet weak var image7: UIImageView!
    @IBOutlet weak var image8: UIImageView!
    @IBOutlet weak var image9: UIImageView!
    
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
        self.likeCountLable.text = String(data.likeCount)
        self.commentCountLabel.text = String(data.commentCount)
        
        // set images
        image1.hidden = true
        image2.hidden = true
        image3.hidden = true
        image4.hidden = true
        image5.hidden = true
        image6.hidden = true
        image7.hidden = true
        image8.hidden = true
        image9.hidden = true
        
        for var index = 0; index < data.pictures.count; index++ {
            let image = UIImage(named: data.pictures[index] as String)
            switch index {
            case 0:
                image1.image = image
                image1.hidden = false
            case 1:
                image2.image = image
                image2.hidden = false
            case 2:
                image3.image = image
                image3.hidden = false
            case 3:
                image4.image = image
                image4.hidden = false
            case 4:
                image5.image = image
                image5.hidden = false
            case 5:
                image6.image = image
                image6.hidden = false
            case 6:
                image7.image = image
                image7.hidden = false
            case 7:
                image8.image = image
                image8.hidden = false
            default:
                image9.image = image
                image9.hidden = false
            }
        }
        
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
