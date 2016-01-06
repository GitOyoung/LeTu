//
//  BaseDialogViewController.swift
//  student
//
//  Created by luania on 16/1/3.
//  Copyright © 2016年 singlu. All rights reserved.
//

import UIKit

class BaseDialogViewController: QuestionBaseViewController {
    
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .Custom
        contentView.layer.cornerRadius = 6
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let p = touches.first!.locationInView(self.view)
        let content_x = contentView.frame.origin.x
        let content_y = contentView.frame.origin.y
        let content_w = contentView.frame.size.width
        let content_h = contentView.frame.size.height
        if(p.x > content_x &&
            p.x < content_x+content_w &&
            p.y > content_y &&
            p.y < content_y+content_h){
                //触摸位置在dialog内的时候
                return
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}
