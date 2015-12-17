//
//  MeLoginViewController.swift
//  student
//
//  Created by zjueman on 15/11/12.
//  Copyright © 2015年 singlu. All rights reserved.
//

import UIKit

class MeLoginViewController: UIViewController {
    
    // MARK: properties
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: actions
    @IBAction func doLogin(sender: AnyObject) {
        print("开始登录，用户名是:\(name.text), 密码是:\(password.text)")
        
        let afterLoginViewController = MeAfterLoginViewController()
        
        if let tabbarVC = self.tabBarController {
            var vcs = tabbarVC.viewControllers!
            vcs[2] = afterLoginViewController
            tabbarVC.viewControllers = vcs
        }
        
        
        
        //presentViewController(afterLoginViewController, animated: true, completion: nil)
    }
    
}