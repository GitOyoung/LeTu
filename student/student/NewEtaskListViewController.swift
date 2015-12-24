//
//  NewEtaskListViewController.swift
//  student
//
//  Created by Jiang, Xinxing on 15/12/13.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class NewEtaskListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
