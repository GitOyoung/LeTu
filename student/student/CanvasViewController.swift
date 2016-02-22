//
//  CanvasViewController.swift
//  student
//
//  Created by luania on 16/1/12.
//  Copyright © 2016年 singlu. All rights reserved.
//

import UIKit

protocol PassImageDataDelegate{
    func passImageData(image:UIImage)
}

class CanvasViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var canvasView: CanvasView!
    
    var delegate:PassImageDataDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .Custom
        cancelButton.layer.cornerRadius = 6
        confirmButton.layer.cornerRadius = 6
    }
    
    @IBAction func cancelButtonClicked(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func confirmButtonClicked(sender: UIButton) {
        let rect:CGRect = canvasView.frame;
        UIGraphicsBeginImageContext(rect.size);
        canvasView.layer.renderInContext(UIGraphicsGetCurrentContext()!);
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dismissViewControllerAnimated(true, completion: nil)
        delegate.passImageData(img)
    }
}
