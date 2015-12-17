//
//  EtaskDetailViewController.swift
//  student
//
//  Created by zjueman on 15/11/12.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class EtaskDetailViewController: UIViewController {
    
    // MARK: properties
    var etask:EtaskModel?
    
    override func viewDidLoad() {
        print("开始load etaskDetail")
        super.viewDidLoad()
        print(etask)
        if let etask = self.etask {
            
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    ///按钮 － 开始做作业
    @IBAction func startEtask(sender: AnyObject) {
        let etaskWorkonVC = EtaskWorkonViewController()
        self.presentViewController(etaskWorkonVC, animated: true, completion: nil)
    }
    
    ///按钮 － 查看已批改作业
    @IBAction func reviewEtask(sender: AnyObject) {
        var etaskWorkonVC = EtaskWorkonViewController()
        self.presentViewController(etaskWorkonVC, animated: true, completion: nil)
    }
    
    ///按钮 － 左上角返回
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}