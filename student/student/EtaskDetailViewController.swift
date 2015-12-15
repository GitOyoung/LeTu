//
//  EtaskDetailViewController.swift
//  student
//
//  Created by zjueman on 15/11/12.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class EtaskDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///按钮 － 开始做作业
    @IBAction func startEtask(sender: AnyObject) {
        var etaskWorkonVC = EtaskWorkonViewController()
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