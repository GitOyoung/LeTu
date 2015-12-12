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
    @IBOutlet weak var statusImgView: UIImageView!
    
    func initCell(data:EtaskModel) {
        titleLabel.text = data.name!
        detailLabel.text = data.subTitle!
        typeLabel.text = data.summary!
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
